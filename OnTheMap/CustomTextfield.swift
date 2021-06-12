//
//  OnTheMapTextfield.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 05/06/21.
//

import UIKit

final class CustomTextField: UITextField {
    
    private let customInset: CGFloat = 10
    
    
    func setAttributedPlaceHolder(_ placeHolder: String) {
        attributedPlaceholder = NSAttributedString(string: placeHolder,
                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: customInset, dy: customInset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: customInset, dy: customInset)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: customInset, dy: customInset)
    }
}
