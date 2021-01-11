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
    private let animationStartY: CGFloat

    init?(coder: NSCoder,
          photoStorage: PhotoStorable,
          imageService: ImageServicing,
          firstPhotoIndexPath: IndexPath,
          animationStartY: CGFloat) {
        
        self.firstPhotoIndexPath = firstPhotoIndexPath
        self.animationStartY = animationStartY
        self.photoStorage = photoStorage
        self.imageService = imageService
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
    
    @IBAction private func cancelButtonTouched(_ sender: UIBarButtonItem) {
        dismiss(animated: true) {}
    }
    
}
