//
//  DetailView.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/10.
//

import UIKit

class DetailView: UIView {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleItem: UINavigationItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureNib()
    }
    
}
