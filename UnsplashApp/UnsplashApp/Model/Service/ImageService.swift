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
            return successHandler(cachedImage)
        }
        
        imageURLFromNotCache(
            endPoint: endPoint,
            successHandler: { [weak self] image in
                if let url = endPoint.url, let image = image {
                    self?.imageCache.setObject(image, forKey: url.lastPathComponent as NSString)
                }
                successHandler(image)
            },
            failureHandler: failureHandler)
    }
    
    func imageURLFromNotCache(endPoint: EndPoint,
                  successHandler: @escaping (UIImage?) -> Void,
                  failureHandler: ((Error) -> Void)? = nil) {
        
        urlProvider.url(url: endPoint.url, headers: endPoint.headers, successHandler: { imageURL in
            guard let imageURL = imageURL,
                  let data = try? Data(contentsOf: imageURL),
                  let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    successHandler(nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                successHandler(image)
            }
            
        }, failureHandler: failureHandler)
    }

}
