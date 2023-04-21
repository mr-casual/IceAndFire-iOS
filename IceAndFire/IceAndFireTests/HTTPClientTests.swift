//
//  HTTPClientTests.swift
//  IceAndFireTests
//
//  Created by Martin Klöpfel on 21.04.23.
//

import Foundation
import XCTest
@testable import IceAndFire

final class HTTPClientTests: XCTestCase {
    
    private struct TestEntity: Decodable, Equatable {
        let test: String
    }
    
    private let urlSession: URLSession = {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.protocolClasses = [MockURL.self]
        return URLSession(configuration: sessionConfiguration)
    }()
    
    private lazy var httpClient = HTTPClient(urlSession: urlSession, decoder: JSONDecoder())

    override func tearDown() {
        MockURL.removeAllMocks()
    }

    func test200ResponseWithTestModel() async throws {
        // setup mock response
        let url = URL(string: "https://test.test")!
        let response = HTTPURLResponse(url: url,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        let data = """
                   {
                      "test": "Test"
                   }
                   """.data(using: .utf8)
        MockURL.addMock(for: url, result: .success((response, data)))
        
        // test request and decoding
        let result: HTTPClient.Result<TestEntity> = await httpClient.GET(url)
        switch result {
        case .success(let success):
            XCTAssertEqual(success.object, TestEntity(test: "Test"), "Decoded `TestEntity` doesn't match expected test data.")
        case .failure:
            XCTFail("Request should succeed.")
        }
    }
    
    func testClientErrorResponse() async throws {
        // setup mock response
        let url = URL(string: "https://test.test")!
        let response = HTTPURLResponse(url: url,
                                       statusCode: 400,
                                       httpVersion: nil,
                                       headerFields: nil)
        MockURL.addMock(for: url, result: .success((response, nil)))
        
        // test request
        let assertionMessage = "Request should fail with `clientError`."
        let result: HTTPClient.Result<TestEntity> = await httpClient.GET(url)
        switch result {
        case .success:
            XCTFail(assertionMessage)
        case .failure(let error):
            switch error {
            case .clientError: break // expected error
            default:
                XCTFail(assertionMessage)
            }
        }
    }
    
    func testServerErrorResponse() async throws {
        // setup mock response
        let url = URL(string: "https://test.test")!
        let response = HTTPURLResponse(url: url,
                                       statusCode: 503,
                                       httpVersion: nil,
                                       headerFields: nil)
        MockURL.addMock(for: url, result: .success((response, nil)))
        
        // test request
        let assertionMessage = "Request should fail with `serverError`."
        let result: HTTPClient.Result<TestEntity> = await httpClient.GET(url)
        switch result {
        case .success:
            XCTFail(assertionMessage)
        case .failure(let error):
            switch error {
            case .serverError: break // expected error
            default:
                XCTFail(assertionMessage)
            }
        }
    }
    
    func testDecodingError() async throws {
        // setup mock response
        let url = URL(string: "https://test.test")!
        let response = HTTPURLResponse(url: url,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        let data = """
                   {
                      "should": "fail"
                   }
                   """.data(using: .utf8)
        MockURL.addMock(for: url, result: .success((response, data)))
        
        // test request and decoding
        let assertionMessage = "Request should fail with `serializationError`."
        let result: HTTPClient.Result<TestEntity> = await httpClient.GET(url)
        switch result {
        case .success:
            XCTFail(assertionMessage)
        case .failure(let error):
            switch error {
            case .serializationError: break // expected error
            default:
                XCTFail(assertionMessage)
            }
        }
    }
    
    func testNotConnectedToInternet() async throws {
        // setup mock response
        let url = URL(string: "https://test.test")!
        MockURL.addMock(for: url, result: .failure(URLError(.notConnectedToInternet)))
        
        // test request and decoding
        let assertionMessage = "Request should fail with `urlError`."
        let result: HTTPClient.Result<TestEntity> = await httpClient.GET(url)
        switch result {
        case .success:
            XCTFail(assertionMessage)
        case .failure(let error):
            switch error {
            case .urlError(URLError.notConnectedToInternet): break // expected error
            default:
                XCTFail(assertionMessage)
            }
        }
    }
}
