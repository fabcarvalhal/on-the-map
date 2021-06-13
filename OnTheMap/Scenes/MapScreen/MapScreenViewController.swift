//
//  MapScreen.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 12/06/21.
//

import UIKit
import MapKit
import SafariServices

final class MapScreenViewController: UIViewController {
    
    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    private let apiClient: UdacityApiClientProtocol = UdacityApiClient()
    private let pinRegistrationSegueIdentifier = "showPinRegisterVC"
    private var locationToUpdate: StudentLocationResponseItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPins()
    }
    
    func loadPins() {
        view.showLoading()
        clearAnnotations()
        let request = StudentLocationRequest(limit: 200, skip: 0, order: "-updatedAt", userId: "")
        apiClient.getStudentLocations(studentLocationRequest: request) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view.hideLoading()
                switch result {
                case .success(let data):
                    guard let results = data.results else { return }
                    let annotations = self.createAnnotations(using: results)
                    self.mapView.addAnnotations(annotations)
                case .failure(let error):
                    self.showErrorAlert(message: error.localizedDescription, title: "Error")
                }
            }
        }
    }
    
    func verifyIfUserHasAlreadySentAPin(completion: @escaping (StudentLocationResponseItem?) -> Void) {
        guard let userId = LoginSession.current?.get()?.uniqueId else { return }
        view.showLoading()
        let request = StudentLocationRequest(limit: 1,
                                             skip: 0,
                                             order: "-updatedAt",
                                             userId: userId)
        apiClient.getStudentLocations(studentLocationRequest: request) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view.hideLoading()
                switch result {
                case .success(let data):
                    completion(data.results?.first)
                case .failure(let error):
                    self.showErrorAlert(message: error.localizedDescription, title: "Error")
                }
            }
        }
    }
    
    func createAnnotations(using studentLocations: [StudentLocationResponseItem]) -> [MKPointAnnotation] {
        return studentLocations.map { location in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude,
                                                           longitude: location.longitude)
            annotation.title = String(format: "%@ %@", location.firstName, location.lastName)
            annotation.subtitle = location.mediaURL
            return annotation
        }
    }
    
    func clearAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    @IBAction func reloadButtonAction() {
        loadPins()
    }
    
    @IBAction func addPinButtonAction() {
        verifyIfUserHasAlreadySentAPin { [weak self] location in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard location != nil else {
                    self.performSegue(withIdentifier: self.pinRegistrationSegueIdentifier, sender: self)
                    return
                }
                self.locationToUpdate = location
                let alert = UIAlertController(title: nil,
                                              message: "You have already posted a student location. Would you like to overwrite your current location?",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { _ in
                    self.performSegue(withIdentifier: self.pinRegistrationSegueIdentifier, sender: self)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == pinRegistrationSegueIdentifier {
            (segue.destination as? PinRegisterViewController)?.locationIdToUpdate = locationToUpdate?.objectId
            locationToUpdate = nil
        }
    }
}

extension MapScreenViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Annotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let accessoryButton = UIButton(type: .infoLight)
            annotationView?.rightCalloutAccessoryView = accessoryButton
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let annotationSubtitle = view.annotation?.subtitle ?? ""
        if let url = URL(string: annotationSubtitle ?? "") {
            guard UIApplication.shared.canOpenURL(url) else {
                showErrorAlert(message: "The URL can't be openned", title: "Error")
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
