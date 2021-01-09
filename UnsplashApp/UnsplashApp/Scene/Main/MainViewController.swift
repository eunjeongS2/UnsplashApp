//
//  MainViewController.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/08.
//

import UIKit

final class MainViewController: UIViewController {

    @IBOutlet private weak var photoCollectionView: UICollectionView!
    private var photos = [Photo]()
    
    private let httpService = HTTPService(session: URLSession(configuration: .default))
    private lazy var photoService: PhotoServicing = {
        PhotoService(dataProvider: httpService)
    }()
    
    private lazy var imageService: ImageServicing = {
        ImageService(urlProvider: httpService)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestPhotos(page: 1) { [weak self] in
            self?.configureCollectionView()
        }
    }
    
    private func requestPhotos(page: Int, compeltion: @escaping () -> Void) {
        let endPoint = UnsplashEndPoint.photos(page: page, count: Count.perPage)
        
        photoService.photos(page: page, endPoint: endPoint) { [weak self] in
            guard let photos = $0 else { return }
            self?.photos += photos
            compeltion()
        }
    }
    
    private func configureCollectionView() {
        PhotoCollectionViewCell.registerNib(collectionView: photoCollectionView)
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }

}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        
        photos.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let reuseIdentifier = PhotoCollectionViewCell.Identifier.reusableCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        guard let photoCell = cell as? PhotoCollectionViewCell,
              let photo = photos[safe: indexPath.item]
        else {
            return cell
        }
        
        photoCell.configureCell(username: photo.username,
                                sponsored: photo.sponsored,
                                imageSize: cell.frame.size)
        
        return photoCell
    }
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let photo = photos[safe: indexPath.item] else { return .zero }
        let width = view.frame.width
        let ratio = CGFloat(photo.height) / CGFloat(photo.width)
        let height = width * ratio
        return CGSize(width: width, height: height)
    }
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath) {
        
        if indexPath.item == photos.count - 1 {
            let page = Int(ceil(Double(photos.count) / Double(Count.perPage))) + 1
            requestPhotos(page: page) {
                collectionView.reloadData()
            }
        }
        
        guard let photoCell = cell as? PhotoCollectionViewCell,
              let photo = photos[safe: indexPath.item]
        else {
            return
        }
        
        let width = Int(view.frame.width * UIScreen.main.scale)
        let endPoint = UnsplashEndPoint.photoURL(url: photo.url, width: width)
        
        imageService.imageURL(endPoint: endPoint) {
            let maxItem = collectionView.indexPathsForVisibleItems.map { $0.item }.max() ?? indexPath.item
            if (maxItem - 5...maxItem + 5).contains(indexPath.item) {
                photoCell.configureCell(image: $0)
            }
        }
    }
    
}

private extension MainViewController {
    
    enum Count {
        static let perPage: Int = 30
    }
}
