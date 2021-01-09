//
//  MainViewController.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/08.
//

import UIKit

class MainViewController: UIViewController {

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
        
        requestPhotos() { [weak self] in
            self?.configureCollectionView()
        }
    }
    
    private func requestPhotos(compeltion: @escaping () -> Void) {
        let endPoint = UnsplashEndPoint.photos(page: 1, count: 20)
        
        photoService.photos(page: 1, endPoint: endPoint) { [weak self] in
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = PhotoCollectionViewCell.Identifier.reusableCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        guard let photoCell = cell as? PhotoCollectionViewCell,
              let photo = photos[safe: indexPath.item]
        else {
            return cell
        }
        
        let endPoint = UnsplashEndPoint.photoURL(url: photo.url, width: Int(view.frame.width))
        
        imageService.imageURL(endPoint: endPoint) {
            photoCell.configureCell(image: $0)
        }
        
        return photoCell
    }
    
}

extension MainViewController: UICollectionViewDelegate {}
