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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPins()
    }
    
    func loadPins() {
        clearAnnotations()
        let request = StudentLocationRequest(limit: 200, skip: 0, order: "-updatedAt")
        apiClient.getStudentLocations(studentLocationRequest: request) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let annotations = self.createAnnotations(using: data.results)
                    self.mapView.addAnnotations(annotations)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func createAnnotations(using studentLocations: [StudentLocationResponseItem]) -> [MKPointAnnotation] {
        return studentLocations.map { location in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude,
                                                           longitude: location.latitude)
            annotation.title = String(format: "%@ %@", location.firstName, location.lastName)
            annotation.subtitle = location.mediaURL
            return annotation
        }
    }
    
    func clearAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    func showErrorAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func reloadButtonAction() {
        loadPins()
    }
    
    @IBAction func addPinButtonAction() {
        
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
