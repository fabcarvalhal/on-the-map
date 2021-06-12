//
//  ViewController.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 05/06/21.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var emailTextField: CustomTextField! {
        didSet {
            emailTextField.setAttributedPlaceHolder("Email")
        }
    }
    
    @IBOutlet private weak var passwordTextField: CustomTextField! {
        didSet {
            passwordTextField.setAttributedPlaceHolder("Password")
        }
    }
    
    @IBOutlet private weak var loginButton: UIButton!
    
    // MARK: - Variables and constans
    private let loggedInAreSegueIdentifier = "showLoggedInArea"
    private let apiClient: UdacityApiClientProtocol = UdacityApiClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK - Actions
    @IBAction func loginButtonTapAction(_ sender: UIButton) {
        loginButton.isEnabled = false
        let password = passwordTextField.text ?? String()
        let email = emailTextField.text ?? String()
        let request = UdacitySessionRequestBody(udacity: UdacityLoginInfo(username: email,
                                                                          password: password))
        apiClient.createSession(requestBody: request) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loginButton.isEnabled = true
                switch result {
                case .success(let response):
                    LoginSession.current?.set(response)
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: self.loggedInAreSegueIdentifier, sender: self)
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
}






