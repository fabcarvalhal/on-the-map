//
//  ViewController.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 05/06/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: CustomTextField! {
        didSet {
            emailTextField.setAttributedPlaceHolder("Email")
        }
    }
    
    @IBOutlet weak var passwordTextField: CustomTextField! {
        didSet {
            passwordTextField.setAttributedPlaceHolder("Password")
        }
    }
    
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Variables and constans
    let apiClient: UdacityApiClientProtocol = UdacityApiClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK - Actions
    @IBAction func loginButtonTapAction(_ sender: UIButton) {
        let req = StudentLocationRequest(limit: 10, skip: 0, order: "-updatedAt")
        apiClient.getStudentLocations(studentLocationRequest: req) { response in
            print(response)
        }
    }
}






