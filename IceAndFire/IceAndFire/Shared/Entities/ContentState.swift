//
//  ContentState.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 22.04.23.
//

import Foundation

enum ContentState<Content> {
    case initial
    case loading
    case content(Content)
    case error(String)
}

extension ContentState {
    func mapContent<T>(_ mapping: (Content) -> (T)) -> ContentState<T> {
        switch self {
            
        case .initial:
            return .initial
        case .loading:
            return .loading
        case .content(let content):
            return .content(mapping(content))
        case .error(let error):
            return .error(error)
        }
    }
}
