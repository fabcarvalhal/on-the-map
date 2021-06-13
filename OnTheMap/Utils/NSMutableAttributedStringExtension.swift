//
//  NSMutableAttributedStringExtension.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 12/06/21.
//

import UIKit

extension NSMutableAttributedString {
   
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
}
