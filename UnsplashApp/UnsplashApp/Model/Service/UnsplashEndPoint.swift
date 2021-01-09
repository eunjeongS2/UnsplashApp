//
//  UnsplashEndPoint.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/09.
//

import Foundation

enum UnsplashEndPoint {
    case photos
    case photo(id: String)
}

extension UnsplashEndPoint: EndPoint {
    
    var url: URL? {
        switch self {
        case .photos:
            return URL(string: "\(UnsplashEndPoint.baseURL)/photos/")
        case .photo(let id):
            return URL(string: "\(UnsplashEndPoint.baseURL)/photos/\(id)")
        }
    }
    
    var headers: HTTPHeaders? {
        ["Authorization" : "Client-ID \(UnsplashKey.accessKey)"]
    }

}

private extension UnsplashEndPoint {
    
    static let baseURL: String = "https://api.unsplash.com"
    
}
