//
//  ImageCollectionViewCell.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/08.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    func configureCell(image: UIImage?) {
        imageView.image = image
    }
    
}

extension ImageCollectionViewCell {

    static func registerNib(collectionView: UICollectionView) {
        let nib = UINib(nibName: ImageCollectionViewCell.Name.typeName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Identifier.reusableCell)
    }
    
}

extension ImageCollectionViewCell {
    
    enum Identifier {
        static let reusableCell: String = "ImageCell"
    }
    
    enum Name {
        static let typeName: String = "ImageCollectionViewCell"
    }
}
