//
//  UICollectionView+visibleIndexPath.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/11.
//

import UIKit

extension UICollectionView {
    
    var visibleIndexPath: IndexPath? {
        let visibleRect = CGRect(origin: contentOffset, size: bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        return indexPathForItem(at: visiblePoint)
    }
    
}
