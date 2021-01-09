//
//  Photo.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/08.
//

import Foundation

class Photo: Codable {
    let id: String
    let url: String
    let username: String
    let width: Int
    let height: Int
    let sponsored: Bool
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        url = try container.decode(PhotoURL.self, forKey: .url).raw
        username = try container.decode(User.self, forKey: .username).name
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        sponsored = try !container.decodeNil(forKey: .sponsored)
    }
    
}

private extension Photo {
    
    enum CodingKeys: String, CodingKey {
        case id
        case url = "urls"
        case username = "user"
        case width
        case height
        case sponsored
    }
}
