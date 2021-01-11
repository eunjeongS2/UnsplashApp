//
//  DetailViewController.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/11.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet private weak var titleItem: UINavigationItem!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var detailCollectionView: UICollectionView!
    
    private var photoStorage: PhotoStorable?
    private var imageService: ImageServicing?
    private var firstPhotoIndexPath: IndexPath?
    private var lastIndexPathHandler: ((IndexPath) -> Void)?
    private let animationStartY: CGFloat

    init?(coder: NSCoder,
          photoStorage: PhotoStorable,
          imageService: ImageServicing,
          firstPhotoIndexPath: IndexPath,
          animationStartY: CGFloat,
          lastIndexPathHandler: ((IndexPath) -> Void)? = nil) {
        
        self.firstPhotoIndexPath = firstPhotoIndexPath
        self.animationStartY = animationStartY
        self.photoStorage = photoStorage
        self.imageService = imageService
        self.lastIndexPathHandler = lastIndexPathHandler
        super.init(coder: coder)

    }
    
    required init?(coder: NSCoder) {
        animationStartY = .zero
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTransparentNavigationBar()
        configureCollectionView()
        
        photoStorage?.addPhotosChangeHandler { [weak self] in
            self?.detailCollectionView.reloadData()
        }
    }
    
    private func configureTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    private func configureCollectionView() {
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        
        guard let firstPhotoIndexPath = firstPhotoIndexPath else { return }
        
        detailCollectionView.layoutIfNeeded()
        detailCollectionView.scrollToItem(at: firstPhotoIndexPath, at: .left, animated: false)
        titleItem.title = photoStorage?[firstPhotoIndexPath.item]?.username ?? .blank
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let firstPhotoIndexPath = firstPhotoIndexPath else { return }
        
        let detailCell = detailCollectionView.cellForItem(at: firstPhotoIndexPath) as? DetailCollectionViewCell
        detailCell?.animate(startY: animationStartY)
    }
    
    @IBAction private func cancelButtonTouched(_ sender: UIBarButtonItem) {
        guard let visibleIndexPath = detailCollectionView.visibleIndexPath
        else {
            return
        }
        lastIndexPathHandler?(visibleIndexPath)
        dismiss(animated: true)
    }
    
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}

extension DetailViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath) {
        
        guard let photoStorage = photoStorage else { return }
        
        if indexPath.item == photoStorage.count - 1 {
            let page = Int(ceil(Double(photoStorage.count) / Double(Count.perPage))) + 1
            let endPoint = photosEndPoint(page: page)
            
            photoStorage.requestPhotos(page: page, endPoint: endPoint, compeltion: nil)
        }
    }
        
}

extension DetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoStorage?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = DetailCollectionViewCell.Identifier.reusableCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
 
        guard let detailPhotoCell = cell as? DetailCollectionViewCell,
              let photo = photoStorage?[indexPath.item]
        else {
            return cell
        }
        
        let width = Int(view.frame.width * UIScreen.main.scale)
        let tempPhotoEndPoint = UnsplashEndPoint.photoURL(url: photo.url, width: width)

        imageService?.imageURL(endPoint: tempPhotoEndPoint) {
            detailPhotoCell.configureView(image: $0)
        }
        return detailPhotoCell
    }

}

extension DetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let visibleIndexPath = detailCollectionView.visibleIndexPath
        else {
            return
        }
        titleItem.title = photoStorage?[visibleIndexPath.item]?.username ?? .blank
    }
    
}

private extension DetailViewController {
    
    enum Count {
        static let perPage: Int = 30
    }
    
    func photosEndPoint(page: Int) -> EndPoint {
        UnsplashEndPoint.photos(page: page, count: Count.perPage)
    }
    
}
