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
    private let udacitySignUpUrl = URL(string: "https://www.udacity.com/account/auth#!/signup")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeForKeyboardNotifications()
        setTouchOutsideGesture()
    }
    
    deinit {
        removeObservers()
    }
    
    // MARK - Actions
    @IBAction func loginButtonTapAction(_ sender: UIButton) {
        loginButton.isEnabled = false
        let password = passwordTextField.text ?? String()
        let email = emailTextField.text ?? String()
        let request = UdacitySessionRequestBody(udacity: UdacityLoginInfo(username: email,
                                                                          password: password))
        let userDataResponseHandler = { [weak self] (response: GetUserDataResponse, userId: String) in
            guard let self = self else  { return }
            self.loginButton.isEnabled = true
            let data = UserDataSession(firstName: response.firstName,
                                       lastName: response.lastName,
                                       uniqueId: userId)
            LoginSession.current?.set(data)
            self.performSegue(withIdentifier: self.loggedInAreSegueIdentifier, sender: self)
        }
        view.showLoading()
        apiClient.createSession(requestBody: request) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.getUserData(userId: response.account.key, completion: userDataResponseHandler)
                case .failure(let failure):
                    self.view.hideLoading()
                    self.loginButton.isEnabled = true
                    self.showErrorAlert(message: failure.localizedDescription, title: "Error")
                }
            }
        }
    }
    
    func getUserData(userId: String, completion: @escaping (GetUserDataResponse, String) -> Void) {
        apiClient.getStudentUserData(studentId: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.view.hideLoading()
                switch result {
                case .success(let response):
                    completion(response, userId)
                case .failure(let error):
                    self?.showErrorAlert(message: error.localizedDescription, title: "Error")
                }
            }
        }
    }
    
    @IBAction private func signUpButtonAction() {
        guard let url = udacitySignUpUrl else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
