//
//  ImageCollectionViewCell.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/08.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var sponsoredLabel: UILabel!
    private var gradientLayer: CAGradientLayer?
    
    func configureCell(username: String, sponsored: Bool, imageSize: CGSize) {
        usernameLabel.text = username
        sponsoredLabel.isHidden = !sponsored
        gradientLayer?.frame.size = imageSize
    }
    
    func configureCell(image: UIImage?) {
        imageView.image = image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gradientLayer = imageView.makeGradientLayer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
}

extension PhotoCollectionViewCell {

    static func registerNib(collectionView: UICollectionView) {
        let nib = UINib(nibName: PhotoCollectionViewCell.Name.typeName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Identifier.reusableCell)
    }
    
}

extension PhotoCollectionViewCell {
    
    enum Identifier {
        static let reusableCell: String = "PhotoCell"
    }
    
    enum Name {
        static let typeName: String = "PhotoCollectionViewCell"
    }
}
