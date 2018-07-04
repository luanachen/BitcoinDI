//
//  HTTPNetworking.swift
//  BitcoinDI
//
//  Created by Luana Chen on 04/07/18.
//  Copyright © 2018 lccj. All rights reserved.
//

import Foundation

protocol Networking {
    typealias CompletionHandler =  (Data?, Swift.Error?) -> Void
    
    func request(from: EndPoint, completion: @escaping CompletionHandler)
}

struct HTTPNetworking: Networking {
    
    func request(from: EndPoint, completion: @escaping Networking.CompletionHandler) {
        guard let url = URL(string: from.path) else { return }
        let request = createRequest(from: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func createRequest(from url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        return request
    }
    
    private func createDataTask(from request: URLRequest,
                                completion: @escaping CompletionHandler) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, httpResponse, error in
            completion(data, error)
        }
    }
    
}
