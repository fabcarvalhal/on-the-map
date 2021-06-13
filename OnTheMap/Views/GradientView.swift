//
//  GradientView.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 05/06/21.
//

import UIKit

class LoginGradientView: UIView {

    private let gradientLayer = Gradient.loginBackground.layer

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradientLayer, at: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.insertSublayer(gradientLayer, at: .zero)
    }
    
    override func awakeFromNib() {
        gradientLayer.frame = frame
    }

    override func layoutSubviews() {
        gradientLayer.frame = bounds
    }
}
