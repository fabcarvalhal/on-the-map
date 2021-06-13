//
//  UIViewControllerExtension.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 13/06/21.
//

import UIKit

extension UIViewController {
    
    func showErrorAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setTouchOutsideGesture() {
        let gesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    // MARK: Keyboard functions
    @objc func keyboardWillShow(_ notification: Notification) {
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardFrame = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        return keyboardFrame?.cgRectValue.height ?? 0
    }
    
    func subscribeForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}
