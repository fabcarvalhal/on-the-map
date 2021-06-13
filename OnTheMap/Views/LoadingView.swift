//
//  LoadingView.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 13/06/21.
//

import UIKit

final class LoadingView: UIView {
    
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.systemGray3.withAlphaComponent(0.4)
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = .systemBlue
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func startAnimating() {
        activityIndicatorView.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }
}
