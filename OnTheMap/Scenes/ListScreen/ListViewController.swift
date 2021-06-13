//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 13/06/21.
//

import UIKit

final class ListViewController: UITableViewController {
    
    private let apiClient: UdacityApiClientProtocol = UdacityApiClient()
    private let pinRegistrationSegueIdentifier = "showPinRegisterVC"
    private var locationToUpdate: StudentLocationResponseItem?
    private let cellIdentifier = "StudentLocationCellIdentifier"
    private let cellHeight: CGFloat = 120
    
    private var locations = [StudentLocationResponseItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLocations()
    }
    
    func loadLocations() {
        UIApplication.shared.windows.first?.showLoading()
        let request = StudentLocationRequest(limit: 100,
                                             skip: 0,
                                             order: "-updatedAt",
                                             userId: "")
        apiClient.getStudentLocations(studentLocationRequest: request) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                UIApplication.shared.windows.first?.hideLoading()
                switch result {
                case .success(let data):
                    guard let results = data.results else { return }
                    self.locations = results
                    self.tableView.reloadData()
                case .failure(let error):
                    self.showErrorAlert(message: error.localizedDescription, title: "Error")
                }
            }
        }
    }
    
    func verifyIfUserHasAlreadySentALocation(completion: @escaping (StudentLocationResponseItem?) -> Void) {
        guard let userId = LoginSession.current?.get()?.uniqueId else { return }
        UIApplication.shared.windows.first?.showLoading()
        let request = StudentLocationRequest(limit: 1,
                                             skip: 0,
                                             order: "-updatedAt",
                                             userId: userId)
        apiClient.getStudentLocations(studentLocationRequest: request) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                UIApplication.shared.windows.first?.hideLoading()
                switch result {
                case .success(let data):
                    completion(data.results?.first)
                case .failure(let error):
                    self.showErrorAlert(message: error.localizedDescription, title: "Error")
                }
            }
        }
    }

    @IBAction func reloadButtonAction() {
        loadLocations()
    }
    
    @IBAction func addPinButtonAction() {
        verifyIfUserHasAlreadySentALocation { [weak self] location in
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
    
    @IBAction func logoutButtonAction() {
        UIApplication.shared.windows.first?.showLoading()
        apiClient.logout { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                UIApplication.shared.windows.first?.hideLoading()
                switch response {
                case .success:
                    LoginSession.current?.erase()
                    let loginViewController = self.storyboard?.instantiateViewController(identifier: "LoginNavigation")
                    UIApplication.shared.windows.first?.rootViewController = loginViewController
                    
                case .failure(let error):
                    self.showErrorAlert(message: error.localizedDescription, title: "Error")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == pinRegistrationSegueIdentifier {
            (segue.destination as? PinRegisterViewController)?.locationIdToUpdate = locationToUpdate?.objectId
            locationToUpdate = nil
        }
    }
    
    // MARK: - Tableview methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locations.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? StudentLocationCell else {
            return UITableViewCell()
        }
        
        let location = locations[indexPath.row]
        let title = String(format: "%@ %@", location.firstName, location.lastName)
        cell.setData(title: title, subtitle: location.mediaURL)
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: locations[indexPath.row].mediaURL) {
            guard UIApplication.shared.canOpenURL(url) else {
                showErrorAlert(message: "The URL can't be openned", title: "Error")
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}
