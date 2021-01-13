//
//  UIView+Constraint.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/10.
//

import UIKit

extension UIView {
    func constraintFit(at view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leftAnchor.constraint(equalTo: view.leftAnchor),
            rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}
