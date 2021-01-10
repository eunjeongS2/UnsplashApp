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
        configureTransparentNavigationBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureNib()
        configureTransparentNavigationBar()
    }
    
    func configureView(username: String, tempImage: UIImage?) {
        titleItem.title = username
        imageView.image = tempImage
    }
    
    func configureView(detailImage: UIImage?) {
        imageView.image = detailImage
    }

    private func configureTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }

    @IBAction private func cancelButtonTouched(_ sender: UIBarButtonItem) {
        isHidden = true
    }
    
}
