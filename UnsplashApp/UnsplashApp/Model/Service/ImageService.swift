//
//  ImageService.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/09.
//

import UIKit

final class ImageService: ImageServicing {
    
    private let urlProvided: URLProvided
    
    init(urlProvided: URLProvided) {
        self.urlProvided = urlProvided
    }
    
    func imageURL(endPoint: EndPoint,
                  successHandler: @escaping (UIImage?) -> Void,
                  failureHandler: ((Error) -> Void)? = nil) {
        
    }
    
    func imageURLFromNotCache(endPoint: EndPoint,
                  successHandler: @escaping (UIImage?) -> Void,
                  failureHandler: ((Error) -> Void)? = nil) {
        
        urlProvided.url(url: endPoint.url, headers: endPoint.headers, successHandler: { [weak self] imageURL in
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
            
        }, failureHandler: failureHandler)
    }

}
