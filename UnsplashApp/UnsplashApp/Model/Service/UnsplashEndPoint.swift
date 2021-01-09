//
//  UnsplashEndPoint.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/09.
//

import Foundation

enum UnsplashEndPoint {
    case photos(page: Int, count: Int)
    case photo(id: String)
    case photoURL(url: String, width: Int)
}

extension UnsplashEndPoint: EndPoint {
    
    var url: URL? {
        switch self {
        case .photos(let page, let count):
            return URL(string: "\(UnsplashEndPoint.baseURL)/photos?page=\(page)&per_page=\(count)")
        case .photo(let id):
            return URL(string: "\(UnsplashEndPoint.baseURL)/photos/\(id)")
        case .photoURL(let url, let width):
            return URL(string: "\(url)&w=\(width)&fit=max")
        }
    }
    
    var headers: HTTPHeaders? {
        ["Authorization" : "Client-ID \(UnsplashKey.accessKey)"]
    }

}

private extension UnsplashEndPoint {
    
    static let baseURL: String = "https://api.unsplash.com"
    
}
