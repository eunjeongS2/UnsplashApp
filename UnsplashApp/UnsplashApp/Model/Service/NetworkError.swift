//
//  NetworkError.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/09.
//

import Foundation

enum NetworkError: Error {
    case url, http(code: Int)
    
    var localizedDescription: String {
        switch self {
        case .url:
            return "잘못된 주소 입니다."
        case .http(let code):
            return "\(code) 에러입니다."
        }
    }
}
