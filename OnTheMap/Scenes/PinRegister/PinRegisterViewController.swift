//
//  PinRegisterViewController.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 12/06/21.
//

import UIKit
import MapKit

final class PinRegisterViewController: UIViewController {
    
    @IBOutlet private weak var linkTextField: CustomTextField!
    @IBOutlet private weak var linkTextFieldWrapperView: UIView!
    @IBOutlet private weak var mapViewWrapperView: UIView!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var findOnTheMapButton: UIButton!
    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    @IBOutlet private weak var whereAreYouStudyingLabel: UILabel!
    @IBOutlet private weak var findOnTheMapView: UIView!
    @IBOutlet private weak var locationTextField: CustomTextField! {
        didSet {
            locationTextField.setAttributedPlaceHolder("Enter your location here")
        }
    }
    
    private let apiClient: UdacityApiClient = UdacityApiClient()
    private var myLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTouchOutsideGesture()
        setStudyingLabelText()
    }
    
    private func setTouchOutsideGesture() {
        let gesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    private func setStudyingLabelText() {
        let string = "Where are you\nstudying\ntoday?"
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.setColor(color: .systemGray, forText: string)
        attributedString.setColor(color: .systemBlue, forText: "studying")
        whereAreYouStudyingLabel.attributedText = attributedString
    }
    
    @IBAction private func cancelButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func findOnTheMapButtonAction() {
        findOnTheMapButton.isEnabled = false
        let address = locationTextField.text ?? String()
        guard !address.isEmpty else {
            showErrorAlert(message: "Your location cant be empty", title: "Error")
            return
        }
        
        getCoordinates(from: address) { [weak self] location in
            DispatchQueue.main.async {
                guard let location = location else {
                    self?.showErrorAlert(message: "Error trying to get your coordinates", title: "Error")
                    return
                }
                self?.myLocation = location
                
                UIView.animate(withDuration: 1, animations: {
                    self?.whereAreYouStudyingLabel.isHidden = true
                    self?.findOnTheMapView.isHidden = true
                    self?.locationTextField.isHidden = true
                    self?.mapViewWrapperView.isHidden = false
                    self?.linkTextFieldWrapperView.isHidden = false
                }) { completed in
                    if completed {
                        self?.findOnTheMapButton.isEnabled = true
                        self?.setAnnotation(for: location, and: address)
                    }
                }
            }
        }
    }
    
    private func setAnnotation(for location: CLLocation, and address: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = address
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction private func submitButtonAction() {
        let link = linkTextField.text ?? String()
        let locationString = linkTextField.text ?? String()
        guard !link.isEmpty else {
            showErrorAlert(message: "Your link cant be empty", title: "Error")
            return
        }
        guard let loginSessionData = LoginSession.current?.get(),
              let coordinates = myLocation?.coordinate
        else {
            return
        }
        let addLocationRequest = AddStudentLocationRequestBody(uniqueKey: "",
                                                               firstName: loginSessionData.firstName,
                                                               lastName: loginSessionData.lastName,
                                                               mapString: locationString,
                                                               mediaURL: link,
                                                               latitude: coordinates.latitude,
                                                               longitude: coordinates.longitude)
        apiClient.addStudentLocation(studentLocationRequest: addLocationRequest) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    self?.showErrorAlert(message: error.localizedDescription, title: "Error")
                }
            }
        }
        
    }
    
    private func getCoordinates(from address: String,
                                completion: @escaping (CLLocation?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placeMarks, error) in
            guard error == nil else {
                completion(nil)
                return
            }
            guard let placeMarks = placeMarks,
                  let location = placeMarks.first else {
                completion(nil)
                return
            }
            completion(location.location)
        }
    }
}

extension PinRegisterViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Annotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
}