//
//  EndPoint.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/09.
//

import Foundation

protocol EndPoint {
    var url: URL? { get }
    var headers: HTTPHeaders? { get }
}
