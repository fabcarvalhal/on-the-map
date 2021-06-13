//
//  Gradient.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 05/06/21.
//

import UIKit

enum Gradient {
    
    case loginBackground
    
    var colors: [CGColor] {
        switch self{
        case .loginBackground:
            return [UIColor(red: 68.0/255.0, green: 170.0/255.0, blue: 155.0/255.0, alpha: 1.0).cgColor,
                    UIColor.systemBlue.cgColor]
        }
    }
    
    var layer: CAGradientLayer {
        switch self {
        case .loginBackground:
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = self.colors
            gradientLayer.locations = [0.0, 1.0]
            return gradientLayer
        }
    }
    
}
