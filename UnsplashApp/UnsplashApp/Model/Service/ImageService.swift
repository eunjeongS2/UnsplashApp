//
//  ImageService.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/09.
//

import UIKit

final class ImageService: ImageServicing {
    
    private let urlProvider: URLProvided
    private let imageCache = NSCache<NSString, UIImage>()
    
    init(urlProvider: URLProvided) {
        self.urlProvider = urlProvider
    }
    
    func imageURL(endPoint: EndPoint,
                  successHandler: @escaping (UIImage?) -> Void,
                  failureHandler: ((Error) -> Void)? = nil) {
        
        if let url = endPoint.url,
           let cachedImage = imageCache.object(forKey: url.lastPathComponent as NSString) {
            
            successHandler(cachedImage)
            return
        }
        
        imageURLFromNotCache(endPoint: endPoint,
                             successHandler: successHandler,
                             failureHandler: failureHandler)
    }
    
    func imageURLFromNotCache(endPoint: EndPoint,
                  successHandler: @escaping (UIImage?) -> Void,
                  failureHandler: ((Error) -> Void)? = nil) {
        
        urlProvider.url(url: endPoint.url, headers: endPoint.headers, successHandler: { [weak self] imageURL in
            guard let imageURL = imageURL,
                  let data = try? Data(contentsOf: imageURL),
                  let image = UIImage(data: data)
            else {
                successHandler(nil)
                return
            }
            
            DispatchQueue.main.async {
                successHandler(image)
            }
            if let url = endPoint.url {
                self?.imageCache.setObject(image, forKey: url.lastPathComponent as NSString)
            }
            
        }, failureHandler: failureHandler)
    }

}
