//
//  Network.swift
//  Primedian-iOS
//
//  Created by Christopher Szatmary on 2019-08-04.
//

import Foundation

enum Status {
    case loading
    case complete(result: [UInt64])
    case error(_ error: APIError)
}

enum APIError: Error {
    case missingParameter
    case invalidParameterType
    case invalidValue(required: UInt64)
    case unknown(message: String)
    
    init(code: Int, message: String) {
        switch code {
        case 1:
            self = .missingParameter
        case 2:
            self = .invalidParameterType
        case 3:
            let required: UInt64 = message.contains("2") ? 2 : 100000000
            self = .invalidValue(required: required)
        default:
            self = .unknown(message: "Server error occurred")
        }
    }
}

let baseURL = ProcessInfo.processInfo.environment["PRIMEDIAN_API_BASE_URL"]

func fetchResult(upperLimit: UInt64, completion: @escaping (Status) -> Void) {
    guard let baseURL = baseURL else {
        fatalError("Required environment variable PRIMEDIAN_API_BASE_URL is not set!")
    }
    
    let primeURL = URL(string: "\(baseURL)/api/median-prime?n=\(upperLimit)")
    
    guard let url = primeURL else {
        fatalError("Malformed URL provided!")
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let err = error {
            completion(Status.error(APIError.unknown(message: err.localizedDescription)))
            return
        }
        
        guard let res = response as? HTTPURLResponse, res.mimeType == "application/json", let data = data else {
            completion(Status.error(APIError.unknown(message: "Invalid HTTP response")))
            return
        }
        
        if res.statusCode == 200 {
            do {
                let json = try JSONDecoder().decode([UInt64].self, from: data)
                completion(Status.complete(result: json))
            } catch let err {
                completion(Status.error(APIError.unknown(message: err.localizedDescription)))
            }
        } else if res.statusCode == 400 {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: Any]]
                guard let type = json?["error"]?["type"] as? Int, let message = json?["error"]?["message"] as? String else {
                    completion(Status.error(APIError.unknown(message: "Invalid JSON response")))
                    return
                }
                
                completion(Status.error(APIError(code: type, message: message)))
            } catch let err {
                completion(Status.error(APIError.unknown(message: err.localizedDescription)))
            }
        } else {
            completion(Status.error(APIError.unknown(message: "Valid response was not received")))
        }
    }
    
    task.resume()
}
