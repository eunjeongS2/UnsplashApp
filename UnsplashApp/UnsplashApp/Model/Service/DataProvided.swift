//
//  DataProvider.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/09.
//

import Foundation

protocol DataProvided {
    
    func data(url: URL?,
              headers: HTTPHeaders?,
              successHandler: @escaping (Data?) -> Void,
              failureHandler: ((Error) -> Void)?)
    
}
