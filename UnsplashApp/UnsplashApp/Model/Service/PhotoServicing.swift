//
//  PhotoServicing.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/09.
//

import Foundation

protocol PhotoServicing {
    func photos(page: Int,
                endPoint: EndPoint,
                successHandler: @escaping ([Photo]?) -> Void,
                failureHandler: ((Error) -> Void)?)
    
    func photosFromNotCache(page: Int,
                            endPoint: EndPoint,
                            successHandler: @escaping ([Photo]?) -> Void,
                            failureHandler: ((Error) -> Void)?)
}

extension PhotoServicing {
    
    func photos(page: Int,
                endPoint: EndPoint,
                successHandler: @escaping ([Photo]?) -> Void,
                failureHandler: ((Error) -> Void)? = nil) {
        
        photos(page: page, endPoint: endPoint, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    func photosFromNotCache(page: Int,
                            endPoint: EndPoint,
                            successHandler: @escaping ([Photo]?) -> Void,
                            failureHandler: ((Error) -> Void)? = nil) {
        
        photosFromNotCache(page: page,
                           endPoint: endPoint,
                           successHandler: successHandler,
                           failureHandler: failureHandler)
    }
    
}
