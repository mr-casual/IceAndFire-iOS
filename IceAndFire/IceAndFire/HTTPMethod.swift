//
//  HTTPMethod.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import Foundation

/**
 HTTP Methods
 
 See [IETF document](https://tools.ietf.org/html/rfc7231#section-4.3)
 */
public enum HTTPMethod : String {

    case GET

    case POST

    case PUT

    case DELETE

    case OPTIONS

    case HEAD

    case PATCH

    case TRACE

    case CONNECT
}
