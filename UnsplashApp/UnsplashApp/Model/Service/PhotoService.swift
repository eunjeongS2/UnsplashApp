//
//  PhotoService.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/09.
//

import Foundation

struct PhotoService: PhotoServicing {
    
    private let dataProvider: DataProvided
    
    init(dataProvider: DataProvided) {
        self.dataProvider = dataProvider
    }
    
    func photos(endPoint: EndPoint,
                successHandler: @escaping ([Photo]?) -> Void,
                failureHandler: ((Error) -> Void)? = nil) {
        
        dataProvider.data(
            url: endPoint.url,
            headers: endPoint.headers,
            successHandler: { data in
                guard let data = data
                else {
                    DispatchQueue.main.async {
                        successHandler(nil)
                    }
                    return
                }
                
                let decoder = JSONDecoder()
         
                if let photos = try? decoder.decode([Photo].self, from: data) {
                    DispatchQueue.main.async {
                        successHandler(photos)
                    }
                    return
                }
                
                if let photos = try? decoder.decode(SearchPhoto.self, from: data).results {
                    DispatchQueue.main.async {
                        successHandler(photos)
                    }
                    return
                }
                DispatchQueue.main.async {
                    successHandler(nil)
                }
            },
            failureHandler: failureHandler)
    }
}

private struct SearchPhoto: Codable {
    let results: [Photo]
}
