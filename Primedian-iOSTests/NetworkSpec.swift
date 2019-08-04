//
//  NetworkSpec.swift
//  Primedian-iOSTests
//
//  Created by Christopher Szatmary on 2019-08-04.
//

import Quick
import Nimble
@testable import Primedian_iOS

class NetworkSpec: QuickSpec {
    override func spec() {
        describe("Network tests") {
            var mockSession: MockNetworkSession!
            
            describe("fetchResult tests") {
                context("complete") {
                    it("fetches the data from the Primedian API") {
                        let upperLimit: UInt64 = 10
                        let url = URL(string: "\(baseURL)/api/median-prime?n=\(upperLimit)")!
                        let mockData = try! JSONEncoder().encode([3, 5])
                        let mockRes = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "1.1", headerFields: ["Content-Type": "application/json"])!
                        mockSession = MockNetworkSession(result: .success((mockData, mockRes)))
                        let expected: [UInt64] = [3, 5]
                        
                        waitUntil { done in
                            fetchResult(upperLimit: upperLimit, session: mockSession) { status in
                                guard case let .complete(result) = status else {
                                    fail("result was not complete")
                                    return
                                }

                                expect(result).to(equal(expected))
                                done()
                            }
                        }
                    }
                }
                
                context("error") {
                    it("responses with an error") {
                        let upperLimit: UInt64 = 1
                        let url = URL(string: "\(baseURL)/api/median-prime?n=\(upperLimit)")!
                        let json = ["error": ["type": 3, "message": "Query parameter n must be greater than 2."]]
                        let mockData = try! JSONSerialization.data(withJSONObject: json, options: [])
                        let mockRes = HTTPURLResponse(url: url, statusCode: 400, httpVersion: "1.1", headerFields: ["Content-Type": "application/json"])!
                        mockSession = MockNetworkSession(result: .success((mockData, mockRes)))
                        
                        waitUntil { done in
                            fetchResult(upperLimit: upperLimit, session: mockSession) { status in
                                guard case let .error(error) = status else {
                                    fail("result was not error")
                                    return
                                }
                                
                                expect(error).to(equal(APIError.invalidValue(required: 2)))
                                done()
                            }
                        }
                    }
                }
            }
        }
    }
}

