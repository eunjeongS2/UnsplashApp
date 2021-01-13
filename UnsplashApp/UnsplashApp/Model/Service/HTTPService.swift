//
//  HTTPService.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/09.
//

import Foundation

final class HTTPService {
    
    private let session: URLSession
    private let concurrentQueue = DispatchQueue(label: Name.concurrentQueue,
                                                       qos: .utility,
                                                       attributes: .concurrent)
    
    init(session: URLSession) {
        self.session = session
    }

    private func request(url: URL, headers: HTTPHeaders?) -> URLRequest {
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        return request
    }

}

extension HTTPService: DataProvided {
    
    func data(url: URL?,
              headers: HTTPHeaders?,
              successHandler: @escaping (Data?) -> Void,
              failureHandler: ((Error) -> Void)? = nil) {
        guard let url = url
        else {
            failureHandler?(NetworkError.url)
            return
        }
        
        let dataRequest = request(url: url, headers: headers)
        
        concurrentQueue.async { [weak self] in
            self?.session.dataTask(with: dataRequest) { (data, response, error) in
                if let error = error {
                    failureHandler?(error)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    guard 200...299 ~= httpResponse.statusCode
                    else {
                        failureHandler?(NetworkError.http(code: httpResponse.statusCode))
                        return
                    }
                }
                successHandler(data)
            }.resume()
        }
    }
    
}

extension HTTPService: URLProvided {
    
    func url(url: URL?,
                  headers: HTTPHeaders?,
                  successHandler: @escaping (URL?) -> Void,
                  failureHandler: ((Error) -> Void)?) {
        guard let url = url
        else {
            failureHandler?(NetworkError.url)
            return
        }
        
        let imageRequest = request(url: url, headers: headers)
        
        concurrentQueue.async { [weak self] in
            self?.session.downloadTask(with: imageRequest) { (url, response, error) in
                if let error = error {
                    failureHandler?(error)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    guard 200...299 ~= httpResponse.statusCode
                    else {
                        failureHandler?(NetworkError.http(code: httpResponse.statusCode))
                        return
                    }
                }
                successHandler(url)
            }.resume()
        }
    }
    
}

private enum Name {
    static let concurrentQueue = "DataProviderConcurrentQueue"
}
