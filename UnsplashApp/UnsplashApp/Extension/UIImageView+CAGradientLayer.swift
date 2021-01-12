//
//  UIImageView+CAGradientLayer.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/12.
//

import UIKit

extension UIImageView {
    
    @discardableResult
    func makeGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.black.cgColor,
        ]
        gradientLayer.opacity = 0.3
        layer.addSublayer(gradientLayer)
        
        return gradientLayer
    }
    
}


