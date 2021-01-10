//
//  PhotoDataStore.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/11.
//

import Foundation

protocol PhotoStorable {
    subscript (index: Int) -> Photo? { get }
    
    func append(_ photos: [Photo])
    var count: Int { get }
}

class PhotoDataStore: PhotoStorable {
    
    private var photos = [Photo]()
    
    subscript (index: Int) -> Photo? {
        photos[safe: index]
    }
    
    func append(_ photos: [Photo]) {
        self.photos += photos
    }
    
    var count: Int {
        photos.count
    }
    
}
