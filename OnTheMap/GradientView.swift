//
//  GradientView.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 05/06/21.
//

import UIKit

class LoginGradientView: UIView {

    private let gradientLayer = Gradient.loginBackground.layer

    override func awakeFromNib() {
        gradientLayer.frame = frame
    }

    override func layoutSubviews() {
        gradientLayer.frame = bounds
    }
}
