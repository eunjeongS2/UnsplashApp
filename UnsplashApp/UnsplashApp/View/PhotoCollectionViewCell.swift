//
//  ImageCollectionViewCell.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/08.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    func configureCell(image: UIImage?) {
        imageView.image = image
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