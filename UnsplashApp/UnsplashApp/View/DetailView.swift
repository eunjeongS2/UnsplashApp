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
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var imageViewCenterYConstraint: NSLayoutConstraint!
    
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
    
    func configureView(username: String, tempImage: UIImage?, animationStartY: CGFloat) {
        titleItem.title = username
        imageView.image = tempImage
        
        guard let tempImage = tempImage else { return }
        
        let differ = animationStartY - (frame.size.height - (tempImage.size.height / 2)) / 2
        imageViewCenterYConstraint.constant = differ
        layoutIfNeeded()

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.5, options: .curveEaseIn) {
            self.imageViewCenterYConstraint.constant = 0
            self.layoutIfNeeded()
        }
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
        imageView.image = nil
    }
    
}
