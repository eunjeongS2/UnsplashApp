//
//  PhotoService.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/09.
//

import Foundation

final class PhotoService: PhotoServicing {
    
    private let dataProvider: DataProvided
    private var photosCache = [Int: [Photo]]()
    
    init(dataProvider: DataProvided) {
        self.dataProvider = dataProvider
    }
    
    func photos(page: Int,
                endPoint: EndPoint,
                successHandler: @escaping ([Photo]?) -> Void,
                failureHandler: ((Error) -> Void)? = nil) {
        
        if let cachedPhotos = photosCache[page] {
            successHandler(cachedPhotos)
            return
        }
        
        photosFromNotCache(page: page,
                           endPoint: endPoint,
                           successHandler: successHandler,
                           failureHandler: failureHandler)
        
    }
    
    func photosFromNotCache(page: Int,
                            endPoint: EndPoint,
                            successHandler: @escaping ([Photo]?) -> Void,
                            failureHandler: ((Error) -> Void)? = nil) {
        
        dataProvider.data(
            url: endPoint.url,
            headers: endPoint.headers,
            successHandler: { [weak self] data in
                guard let data = data else { return successHandler(nil) }
                
                let decoder = JSONDecoder()
                guard let photos = try? decoder.decode([Photo].self, from: data)
                else {
                    return successHandler(nil)
                }
                
                DispatchQueue.main.async {
                    successHandler(photos)
                }
                self?.photosCache[page] = photos
                
            }, failureHandler: failureHandler)
    }

}
