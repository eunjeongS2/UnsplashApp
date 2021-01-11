//
//  PhotoDataStore.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/11.
//

import Foundation

protocol PhotoStorable {
    subscript (index: Int) -> Photo? { get }
    
    var count: Int { get }
    func append(_ photos: [Photo])
    func requestPhotos(page: Int, endPoint: EndPoint, compeltion: (() -> Void)?)
    func addPhotosChangeHandler(_ handler: @escaping () -> Void)
}

class PhotoDataStore: PhotoStorable {
    
    private var photos = [Photo]() {
        didSet {
            photosChangeHandlers.forEach {
                $0()
            }
        }
    }
    private let photoService: PhotoServicing
    private var photosChangeHandlers = [() -> Void]()
    
    init(photoService: PhotoServicing) {
        self.photoService = photoService
    }
    
    subscript (index: Int) -> Photo? {
        photos[safe: index]
    }
    
    var count: Int {
        photos.count
    }
    
    func append(_ photos: [Photo]) {
        self.photos += photos
    }
    
    func requestPhotos(page: Int, endPoint: EndPoint, compeltion: (() -> Void)? = nil) {
        photoService.photos(page: page, endPoint: endPoint) { [weak self] in
            guard let photos = $0 else { return }
            self?.append(photos)
            compeltion?()
        }
    }
    
    func addPhotosChangeHandler(_ handler: @escaping () -> Void) {
        photosChangeHandlers.append(handler)
    }

}
