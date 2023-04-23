//
//  House+DetailItems.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 23.04.23.
//

import Foundation

extension House {
    func toDetailItems() -> [DetailItem] {
        var details = [DetailItem]()
        
        if let words {
            details.append(.init(title: "Words", value: words))
        }
        if !titles.isEmpty {
            let titlesString = titles.joined(separator: "\n")
            details.append(.init(title: "Titles", value: titlesString))
        }
        if !seats.isEmpty {
            let seatsString = seats.joined(separator: "\n")
            details.append(.init(title: "Seats", value: seatsString))
        }
        if let founded {
            details.append(.init(title: "Founded", value: founded))
        }
        if let diedOut {
            details.append(.init(title: "Died out", value: diedOut))
        }
        if !ancestralWeapons.isEmpty {
            let ancestralWeaponsString = ancestralWeapons.joined(separator: "\n")
            details.append(.init(title: "Ancestral Weapons", value: ancestralWeaponsString))
        }
        return details
    }
}
