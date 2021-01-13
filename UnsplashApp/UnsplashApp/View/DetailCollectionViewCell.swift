//
//  DetailCollectionViewCell.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/11.
//

import UIKit

final class DetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageViewCenterYConstraint: NSLayoutConstraint!
    private var imageHeight: CGFloat = .zero
    
    func configureView(image: UIImage?) {
        imageView.image = image
        guard let image = image else { return }
        
        imageHeight = image.size.height
    }
    
    func animate(startY: CGFloat) {
        let differ = startY - (frame.size.height - (imageHeight / 2)) / 2
        imageViewCenterYConstraint.constant = differ

        guard abs(differ) > 15 else { return }

        layoutIfNeeded()

        UIView.animate(
            withDuration: 0.5,
            delay: .zero,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.5,
            options: .curveEaseIn) { [weak self] in
            
            self?.imageViewCenterYConstraint.constant = .zero
            self?.layoutIfNeeded()
       }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageHeight = .zero
        imageViewCenterYConstraint.constant = .zero
    }
}

extension DetailCollectionViewCell {
    
    enum Identifier {
        static let reusableCell: String = "DetailPhotoCell"
    }
}
