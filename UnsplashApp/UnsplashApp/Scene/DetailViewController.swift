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
    
    private var photoStorage: PhotoStorable?
    private var imageService: ImageServicing?
    private let firstPhotoNumber: Int
    private let animationStartY: CGFloat

    init?(coder: NSCoder,
          photoStorage: PhotoStorable,
          imageService: ImageServicing,
          firstPhotoNumber: Int,
          animationStartY: CGFloat) {
        
        self.firstPhotoNumber = firstPhotoNumber
        self.animationStartY = animationStartY
        self.photoStorage = photoStorage
        self.imageService = imageService
        super.init(coder: coder)

    }
    
    required init?(coder: NSCoder) {
        firstPhotoNumber = .zero
        animationStartY = .zero
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTransparentNavigationBar()
    }
    
    private func configureTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    @IBAction private func cancelButtonTouched(_ sender: UIBarButtonItem) {
        dismiss(animated: true) {}
    }
}
