//
//  MainViewController.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/08.
//

import UIKit

final class MainViewController: UIViewController {

    @IBOutlet private weak var photoCollectionView: UICollectionView!
    @IBOutlet private weak var titleView: TitleView!
    
    private var selectedPhotoIndexPath: IndexPath = .init()
    private var selectedPhotoY: CGFloat = .zero

    private let httpService = HTTPService(session: URLSession(configuration: .default))

    private lazy var photoStorage: PhotoStorable = {
        let photoService = PhotoService(dataProvider: httpService)
        return PhotoDataStore(photoService: photoService)
    }()
    
    private lazy var imageService: ImageServicing = {
        ImageService(urlProvider: httpService)
    }()
    
    private lazy var collectionViewSetting: PhotoCollectionViewSetting = {
        PhotoCollectionViewSetting(collectionView: photoCollectionView,
                                   headerIdentifier: Identifier.header,
                                   photoStorage: photoStorage,
                                   imageService: imageService,
                                   perPageCount: Count.perPage,
                                   photosEndPoint: photosEndPoint,
                                   photoURLEndPoint: photoURLEndPoint,
                                   didSelectHandler: collectionViewDidSelectHandler,
                                   didScrollHandler: didScrollHandler)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let endPoint = photosEndPoint(page: 1)

        photoStorage.requestPhotos(endPoint: endPoint) { [weak self] in
            self?.configureCollectionView()
            self?.configureTitleView()
        }
        photoStorage.addPhotosChangeHandler { [weak self] in
            self?.photoCollectionView.reloadData()
        }
    }
    
    private func configureCollectionView() {
        photoCollectionView.delegate = collectionViewSetting
        photoCollectionView.dataSource = collectionViewSetting
    }
    
    private func configureTitleView() {
        guard let photo = photoStorage.randomPhoto() else { return }
        
        titleView.delegate = self
        titleView.configureView(username: photo.username)
        requestImage(url: photo.url) { [weak self] in
            self?.titleView.configureView(image: $0)
        }
    }
    
    private func requestImage(url: String, completion: @escaping (UIImage?) -> Void) {
        let endPoint = self.photoURLEndPoint(url: url)
        
        imageService.imageURL(endPoint: endPoint) {
            completion($0)
        }
    }
    
    private func collectionViewDidSelectHandler(indexPath: IndexPath, y: CGFloat) {
        selectedPhotoIndexPath = indexPath
        selectedPhotoY = y
        performSegue(withIdentifier: Identifier.detailSegue, sender: nil)
    }
    
    private func photosEndPoint(page: Int) -> EndPoint {
        UnsplashEndPoint.photos(page: page, count: Count.perPage)
    }
    
    private func photoURLEndPoint(url: String) -> EndPoint {
        let width = Int(view.frame.width * UIScreen.main.scale)
        return UnsplashEndPoint.photoURL(url: url, width: width)
    }
    
    private func didScrollHandler(_ scrollView: UIScrollView) {
        titleView.updateSize(heightToSubtract: scrollView.contentOffset.y)
    }
    
    @IBSegueAction private func presentDetailViewController(_ coder: NSCoder) -> DetailViewController? {
        return DetailViewController(
            coder: coder,
            photoStorage: photoStorage,
            imageService: imageService,
            firstPhotoIndexPath: selectedPhotoIndexPath,
            animationStartY: selectedPhotoY) { [weak self] in
            self?.photoCollectionView.scrollToItem(at: $0, at: .centeredVertically, animated: false)
        }
    }

}

extension MainViewController: TitleViewDelegate {
    
    func searchViewDidTouched() {
        performSegue(withIdentifier: Identifier.searchSegue, sender: nil)
    }
    
}

private extension MainViewController {
    
    enum Count {
        static let perPage: Int = 30
    }
    
    enum Identifier {
        static let detailSegue: String = "MainToDetailSegue"
        static let searchSegue: String = "MainToSearchSegue"
        static let header: String = "PhotoHeader"
    }

}
