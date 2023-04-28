//
//  RequestError+Presentation.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 22.04.23.
//

import Foundation

extension RequestError {
    var presentation: String {
        switch self {
        case .urlError(let urlError):
            return urlError.localizedDescription
        case .clientError(response: let response, data: _):
            return "Error \(response.statusCode)"
        case .serverError(response: let response, data: _):
            return "Error \(response.statusCode)"
        case .serializationError:
            return "Decoding failed :("
        case .unknown:
            return "Unknown error occurred"
        }
    }
}
