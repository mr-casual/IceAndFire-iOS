//
//  DetailPresentable.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 23.04.23.
//

import Foundation

protocol DetailPresentable {
    var detailPresentation: String { get }
}

extension House: DetailPresentable {
    var detailPresentation: String {
        let name = name.replacingOccurrences(of: "House ", with: "")
        return "🏠 \(name)"
    }
}

extension Character: DetailPresentable {
    var detailPresentation: String {
        var presentation = "👤 \(name)"
        if let died {
            presentation += " (♰ \(died))"
        }
        if !aliases.isEmpty {
            presentation += "\nAliases: \(aliases.joined(separator: ", "))"
        }
        return presentation
    }
}
