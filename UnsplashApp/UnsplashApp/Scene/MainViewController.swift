//
//  MainViewController.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/08.
//

import UIKit

final class MainViewController: UIViewController {

    @IBOutlet private weak var photoCollectionView: UICollectionView!
    private var selectedPhotoIndexPath: IndexPath = .init()
    private var selectedPhotoY: CGFloat = .zero

    private let httpService = HTTPService(session: URLSession(configuration: .default))
    private lazy var photoService: PhotoServicing = {
        PhotoService(dataProvider: httpService)
    }()
    
    private lazy var photoStorage: PhotoStorable = {
        PhotoDataStore(photoService: photoService)
    }()
    
    private lazy var imageService: ImageServicing = {
        ImageService(urlProvider: httpService)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestPhotos(page: 1) { [weak self] in
            self?.configureCollectionView()
        }
        photoStorage.addPhotosChangeHandler { [weak self] in
            self?.photoCollectionView.reloadData()
        }
    }
    
    private func requestPhotos(page: Int, compeltion: @escaping () -> Void) {
        let endPoint = UnsplashEndPoint.photos(page: page, count: Count.perPage)
        
        photoService.photos(page: page, endPoint: endPoint) { [weak self] in
            guard let photos = $0 else { return }
            self?.photoStorage.append(photos)
            compeltion()
        }
    }
    
    private func configureCollectionView() {
        PhotoCollectionViewCell.registerNib(collectionView: photoCollectionView)
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }
    
    @IBSegueAction private func presentDetailViewController(_ coder: NSCoder) -> DetailViewController? {
        return DetailViewController(coder: coder,
                                    photoStorage: photoStorage,
                                    imageService: imageService,
                                    firstPhotoIndexPath: selectedPhotoIndexPath,
                                    animationStartY: selectedPhotoY)
    }

}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        
        photoStorage.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let photo = photoStorage[indexPath.item] else { return .zero }
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
        
        if indexPath.item == photoStorage.count - 1 {
            let page = Int(ceil(Double(photoStorage.count) / Double(Count.perPage))) + 1
            requestPhotos(page: page) {
                collectionView.reloadData()
            }
        }
        
        guard let photoCell = cell as? PhotoCollectionViewCell,
              let photo = photoStorage[indexPath.item]
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        let cellFrame = cell.frame.origin
        let screenY = cell.convert(cellFrame, to: view).y
        let collectionViewY = cell.frame.origin.y
        selectedPhotoIndexPath = indexPath
        selectedPhotoY = screenY - collectionViewY
            
        performSegue(withIdentifier: Identifier.detailSegue, sender: nil)
    }
    
}

private extension MainViewController {
    
    enum Count {
        static let perPage: Int = 30
    }
    
    enum Identifier {
        static let detailSegue: String = "MainToDetailSegue"
    }
    
    func photosEndPoint(page: Int) -> EndPoint {
        UnsplashEndPoint.photos(page: page, count: Count.perPage)
    }
}
