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
                guard let data = data else { return successHandler(nil) }
                
                let decoder = JSONDecoder()
                guard let photos = try? decoder.decode([Photo].self, from: data)
                else {
                    return successHandler(nil)
                }
                
                DispatchQueue.main.async {
                    successHandler(photos)
                }
                
            },
            failureHandler: failureHandler)
    }

}
