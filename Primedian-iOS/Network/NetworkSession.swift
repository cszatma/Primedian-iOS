//
//  NetworkSession.swift
//  Primedian-iOS
//
//  Created by Christopher Szatmary on 2019-08-04.
//

import Foundation

protocol NetworkSession {
    func fetch(from url: URL, completion: @escaping (Result<(Data, URLResponse), Error>) -> Void)
}

extension URLSession: NetworkSession {
    func fetch(from url: URL, completion: @escaping (Result<(Data, URLResponse), Error>) -> Void) {
        dataTask(with: url) { data, res, err in
            if let err = err {
                completion(.failure(err))
                return
            }
            
            guard let res = res, let data = data else {
                let error = NSError(domain: "Response and/or data is missing", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            completion(.success((data, res)))
        }.resume()
    }
}
