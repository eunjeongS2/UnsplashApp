//
//  UIView+Nib.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/10.
//

import UIKit

private extension NSObject {
    var typeName: String {
        String(describing: type(of: self))
    }
}

extension UIView {
    
    var viewFromNib: UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: typeName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func configureNib() {
        guard let view = viewFromNib else { return }
        view.frame = bounds
        addSubview(view)
    }
    
}
