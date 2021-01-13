//
//  URLProvided.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/09.
//

import Foundation

protocol URLProvided {
    
    func url(url: URL?,
             headers: HTTPHeaders?,
             successHandler: @escaping (URL?) -> Void,
             failureHandler: ((Error) -> Void)?)
    
}
