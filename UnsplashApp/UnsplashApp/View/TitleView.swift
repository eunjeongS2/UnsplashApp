//
//  TitleImageView.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/12.
//

import UIKit

protocol TitleViewDelegate: class {
    func searchViewDidTouched()
}

final class TitleView: UIView {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var searchViews: [UIView]!
    @IBOutlet private weak var searchBarView: UIView!
    
    private var imageViewHeight: CGFloat = .zero
    
    weak var delegate: TitleViewDelegate?

    func configureView(image: UIImage?) {
        imageView.image = image
    }
    
    func configureView(username: String) {
        usernameLabel.text = "Photo by \(username)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.makeGradientLayer()
        imageViewHeight = imageView.frame.height
        searchViews.forEach {
            configureTouchEvent(view: $0, action: #selector(searchViewTouched(_:)))
        }
    }
    
    private func configureTouchEvent(view: UIView, action: Selector) {
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: action))
    }
    
    @objc private func searchViewTouched(_ sender: UIImageView) {
        delegate?.searchViewDidTouched()
    }
    
}

private extension TitleView {
    
    enum Size {
        static let height: CGFloat = 56
    }
    
}
