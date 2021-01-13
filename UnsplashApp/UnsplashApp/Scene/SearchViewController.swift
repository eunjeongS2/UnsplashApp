//
//  SearchViewController.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/13.
//

import UIKit

final class SearchViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var photoCollectionView: UICollectionView!
    private var selectedPhotoIndexPath: IndexPath = .init()
    private var selectedPhotoY: CGFloat = .zero
    private var query: String = .blank {
        didSet {
            requestPhotos(page: 1)
        }
    }
    
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
                                   didSelectHandler: collectionViewDidSelectHandler)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        searchBar.delegate = self
        photoCollectionView.isHidden = true
        photoStorage.addPhotosChangeHandler { [weak self] in
            self?.photoCollectionView.reloadData()
        }
    }
    
    private func configureCollectionView() {
        photoCollectionView.delegate = collectionViewSetting
        photoCollectionView.dataSource = collectionViewSetting
    }
    
    private func collectionViewDidSelectHandler(indexPath: IndexPath, y: CGFloat) {
        selectedPhotoIndexPath = indexPath
        selectedPhotoY = y
        performSegue(withIdentifier: Identifier.detailSegue, sender: nil)
    }
    
    private func photosEndPoint(page: Int) -> EndPoint {
        UnsplashEndPoint.searchPhotos(page: page, count: Count.perPage, query: query)
    }
    
    private func photoURLEndPoint(url: String) -> EndPoint {
        let width = Int(view.frame.width * UIScreen.main.scale)
        return UnsplashEndPoint.photoURL(url: url, width: width)
    }
    
    private func requestPhotos(page: Int) {
        photoCollectionView.isHidden = false

        let endPoint = photosEndPoint(page: page)
        photoStorage.requestPhotos(endPoint: endPoint, compeltion: nil)
    }

    @IBAction private func cancelButtonTouched(_ sender: UIButton) {
        dismiss(animated: false)
        view.endEditing(true)
    }
    
    @IBSegueAction private func prsentDetailViewController(_ coder: NSCoder) -> DetailViewController? {
        return DetailViewController(
            coder: coder,
            photoStorage: photoStorage,
            imageService: imageService,
            firstPhotoIndexPath: selectedPhotoIndexPath,
            animationStartY: selectedPhotoY) { [weak self] in
            self?.photoCollectionView.scrollToItem(at: $0, at: .centeredVertically, animated: false)
        }
    }
    
    @IBAction private func trendKeywordTouched(_ sender: UIButton) {
        query = sender.title(for: .normal) ?? .blank
        searchBar.text = query
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        query = searchBar.text ?? .blank
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == .blank {
            photoCollectionView.isHidden = true
            photoStorage.reset()
        }
    }
}

private extension SearchViewController {
    
    enum Count {
        static let perPage: Int = 30
    }
    
    enum Identifier {
        static let detailSegue: String = "SearchToDetailSegue"
        static let header: String = "SearchHeader"
    }

}
