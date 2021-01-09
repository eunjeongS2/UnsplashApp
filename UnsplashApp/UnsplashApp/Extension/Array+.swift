//
//  Array+.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/09.
//

import Foundation

extension Array {
    
    subscript (safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
    
}
