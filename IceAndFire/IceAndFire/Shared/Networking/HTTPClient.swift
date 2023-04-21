//
//  HTTPClient.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import Foundation

/// Errors which can occur during request.
enum RequestError: Error {
    
    /// Errors in the URL error domain. For example `.notConnectedToInternet`
    case urlError(URLError)

    /// HTTP responds status code 400...451
    case clientError(response: HTTPURLResponse, data: Data?)

    /// Error on the server (HTTP status code 500...511)
    case serverError(response: HTTPURLResponse, data: Data?)

    /// Parsing the body into expected type failed.
    case serializationError(error: Error, data: Data?)
    
    /// Unknown error
    case unknow(Error?, data: Data?)
}

class HTTPClient {
    
    typealias Result<ResponseObject> = Swift.Result<Success<ResponseObject>, RequestError>
    
    private let urlSession: URLSession
    private let decoder: JSONDecoder

    init(urlSession: URLSession,
         decoder: JSONDecoder) {
        self.urlSession = urlSession
        self.decoder = decoder
    }

    func GET<ResponseObject: Decodable>(_ url: URL) async -> Result<ResponseObject> {
        let request = URLRequest(url: url)
        return await perform(request: request)
    }
    
    private func perform<ResponseObject: Decodable>(request: URLRequest) async -> Result<ResponseObject> {
        var responseBody: Data?
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.unknow(nil, data: data))
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 400...451:
                return .failure(.clientError(response: httpResponse, data: data))
            case 500...511:
                return .failure(.serverError(response: httpResponse, data: data))
            default:
                return .failure(.unknow(nil, data: data))
            }
            
            responseBody = data
            let responseObject: ResponseObject = try decoder.decode(ResponseObject.self, from: data)
            return .success(.init(object: responseObject, response: httpResponse))
        } catch let error as DecodingError {
            return .failure(.serializationError(error: error, data: responseBody))
        } catch let error as URLError {
            return .failure(.urlError(error))
        } catch {
            return .failure(.unknow(error, data: responseBody))
        }
    }
}

extension HTTPClient {
    struct Success<ResponseObject> {
        let object: ResponseObject
        let response: HTTPURLResponse
    }
}
