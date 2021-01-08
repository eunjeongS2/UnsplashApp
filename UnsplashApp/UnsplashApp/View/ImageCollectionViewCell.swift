//
//  ImageCollectionViewCell.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/08.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    
}

extension ImageCollectionViewCell {
    
    private static var typeName: String {
        String(describing: type(of: self))
    }
    
    static func registerNib(collectionView: UICollectionView) {
        let nib = UINib(nibName: ImageCollectionViewCell.typeName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Identifier.reusableCell)
    }
    
}

private extension ImageCollectionViewCell {
    
    enum Identifier {
        static let reusableCell: String = "ImageCell"
    }
}
