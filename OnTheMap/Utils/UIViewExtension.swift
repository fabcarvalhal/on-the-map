//
//  UIViewExtension.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 13/06/21.
//

import UIKit


extension UIView {
    
    func showLoading() {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingView)
        loadingView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        loadingView.startAnimating()
    }
    
    func hideLoading() {
        let loadingView = subviews.first { $0 is LoadingView } as? LoadingView
        loadingView?.stopAnimating()
        loadingView?.removeFromSuperview()
    }
}
