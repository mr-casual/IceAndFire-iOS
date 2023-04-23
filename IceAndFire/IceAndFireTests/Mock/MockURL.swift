//
//  MockURL.swift
//  IceAndFireTests
//
//  Created by Martin Klöpfel on 21.04.23.
//

import Foundation

class MockURL: URLProtocol {
    
    private static var mockRegister = [URL: Result<(HTTPURLResponse?, Data?), Error>]()
    
    static func addMock(for url: URL, result: Result<(HTTPURLResponse?, Data?), Error>) {
        mockRegister[url] = result
    }
    
    static func removeAllMocks() {
        mockRegister.removeAll()
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let url = request.url {
            switch MockURL.mockRegister[url] {
            case .success(let (response, data)):
                if let response {
                    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                }
                if let data {
                    client?.urlProtocol(self, didLoad: data)
                }
                client?.urlProtocolDidFinishLoading(self)
            case .failure(let error):
                client?.urlProtocol(self, didFailWithError: error)
            default: break
            }
        }
    }
    
    override func stopLoading() {}
}
    
    

