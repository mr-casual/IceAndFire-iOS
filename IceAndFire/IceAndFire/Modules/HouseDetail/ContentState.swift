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
