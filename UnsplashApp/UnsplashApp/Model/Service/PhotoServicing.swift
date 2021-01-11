//
//  PhotoServicing.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/09.
//

import Foundation

protocol PhotoServicing {
    func photos(endPoint: EndPoint,
                successHandler: @escaping ([Photo]?) -> Void,
                failureHandler: ((Error) -> Void)?)
}

extension PhotoServicing {
    
    func photos(endPoint: EndPoint,
                successHandler: @escaping ([Photo]?) -> Void,
                failureHandler: ((Error) -> Void)? = nil) {
        
        photos(endPoint: endPoint, successHandler: successHandler, failureHandler: failureHandler)
    }
    
}
