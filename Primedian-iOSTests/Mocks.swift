//
//  Mocks.swift
//  Primedian-iOSTests
//
//  Created by Christopher Szatmary on 2019-08-04.
//

import UIKit
@testable import Primedian_iOS

class MockNetworkSession: NetworkSession {
    var result: Result<(Data, URLResponse), Error>
    
    init(result: Result<(Data, URLResponse), Error>) {
        self.result = result
    }
    
    func fetch(from url: URL, completion: @escaping (Result<(Data, URLResponse), Error>) -> Void) {
        completion(self.result)
    }
}
