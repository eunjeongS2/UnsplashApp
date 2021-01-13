//
//  UIView+Attribute.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/13.
//

import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
}
