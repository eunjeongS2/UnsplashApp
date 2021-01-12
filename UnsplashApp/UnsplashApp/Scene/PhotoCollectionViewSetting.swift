//
//  PhotoCollectionViewSetting.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/13.
//

import UIKit

final class PhotoCollectionViewSetting: NSObject {
    
    private let headerIdentifier: String
    private let photoStorage: PhotoStorable
    private let imageService: ImageServicing
    private let perPageCount: Int
    private let photosEndPoint: (Int) -> EndPoint
    private let photoURLEndPoint: (String) -> EndPoint
    private let didSelectHandler: (IndexPath, CGFloat) -> Void
    private let didScrollHandler: ((UIScrollView) -> Void)?

    private var selectedPhotoIndexPath: IndexPath = .init()
    private var selectedPhotoY: CGFloat = .zero
    
    init(collectionView: UICollectionView,
         headerIdentifier: String,
         photoStorage: PhotoStorable,
         imageService: ImageServicing,
         perPageCount: Int,
         photosEndPoint: @escaping (Int) -> EndPoint,
         photoURLEndPoint: @escaping (String) -> EndPoint,
         didSelectHandler: @escaping (IndexPath, CGFloat) -> Void,
         didScrollHandler: ((UIScrollView) -> Void)? = nil) {
        
        self.headerIdentifier = headerIdentifier
        self.photoStorage = photoStorage
        self.imageService = imageService
        self.perPageCount = perPageCount
        self.photosEndPoint = photosEndPoint
        self.photoURLEndPoint = photoURLEndPoint
        self.didSelectHandler = didSelectHandler
        self.didScrollHandler = didScrollHandler
        
        PhotoCollectionViewCell.registerNib(collectionView: collectionView)
    }
    
    private func requestImage(url: String, completion: @escaping (UIImage?) -> Void) {
        let endPoint = self.photoURLEndPoint(url)
        
        imageService.imageURL(endPoint: endPoint) {
            completion($0)
        }
    }
    
}

extension PhotoCollectionViewSetting: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath) {
                
        if indexPath.item == photoStorage.count - 1 {
            let page = Int(ceil(Double(photoStorage.count) / Double(perPageCount))) + 1
            let endPoint = photosEndPoint(page)
            
            photoStorage.requestPhotos(endPoint: endPoint, compeltion: nil)
        }
        
        guard let photoCell = cell as? PhotoCollectionViewCell,
              let photo = photoStorage[indexPath.item]
        else {
            return
        }
        requestImage(url: photo.url) {
            let maxItem = collectionView.indexPathsForVisibleItems.map { $0.item }.max() ?? indexPath.item
            if (maxItem - 5...maxItem + 5).contains(indexPath.item) {
                photoCell.configureCell(image: $0)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        let cellFrame = cell.frame.origin
        let view = collectionView.superview ?? collectionView
        let screenY = cell.convert(cellFrame, to: view).y

        selectedPhotoIndexPath = indexPath
        selectedPhotoY = screenY - cellFrame.y
            
        didSelectHandler(selectedPhotoIndexPath, selectedPhotoY)
    }
    
}

extension PhotoCollectionViewSetting: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoStorage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = PhotoCollectionViewCell.Identifier.reusableCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        guard let photoCell = cell as? PhotoCollectionViewCell,
              let photo = photoStorage[indexPath.item]
        else {
            return cell
        }
        
        photoCell.configureCell(username: photo.username,
                                sponsored: photo.sponsored,
                                imageSize: cell.frame.size)
        
        return photoCell
    }
        
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {

        return collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerIdentifier, for: indexPath)
    }
    
}

extension PhotoCollectionViewSetting: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let photo = photoStorage[indexPath.item] else { return .zero }
        let width = collectionView.frame.width
        let ratio = CGFloat(photo.height) / CGFloat(photo.width)
        let height = width * ratio
        return CGSize(width: width, height: height)
    }
    
}

extension PhotoCollectionViewSetting: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScrollHandler?(scrollView)
    }
    
}
