//
//  ImageServicing.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/09.
//

import UIKit

protocol ImageServicing {
    func imageURL(endPoint: EndPoint,
                  successHandler: @escaping (UIImage?) -> Void,
                  failureHandler: ((Error) -> Void)?)
    
    func imageURLFromNotCache(endPoint: EndPoint,
                              successHandler: @escaping (UIImage?) -> Void,
                              failureHandler: ((Error) -> Void)?)
}

extension ImageServicing {
    
    func imageURL(endPoint: EndPoint,
                  successHandler: @escaping (UIImage?) -> Void,
                  failureHandler: ((Error) -> Void)? = nil) {
        
        imageURL(endPoint: endPoint, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    func imageURLFromNotCache(endPoint: EndPoint,
                              successHandler: @escaping (UIImage?) -> Void,
                              failureHandler: ((Error) -> Void)? = nil) {
        
        imageURLFromNotCache(endPoint: endPoint,
                             successHandler: successHandler,
                             failureHandler: failureHandler)
    }
    
}
