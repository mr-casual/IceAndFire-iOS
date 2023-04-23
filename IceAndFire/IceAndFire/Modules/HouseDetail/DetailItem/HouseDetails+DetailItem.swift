//
//  Character+DetailItem.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 23.04.23.
//

import Foundation

extension HouseDetailViewModel.HouseDetails {
    func toDetailItems() -> [DetailItem] {
        var details = [DetailItem]()
        
        if let currentLord {
            details.append(.init(title: "Current Lord",
                                 value: currentLord.detailPresentation))
        }
        if let heir {
            details.append(.init(title: "Heir",
                                 value: heir.detailPresentation))
        }
        if let overlord {
            details.append(.init(title: "Overlord",
                                 value: overlord.detailPresentation))
        }
        if let founder {
            details.append(.init(title: "Founder",
                                 value: founder.detailPresentation))
        }
        if !cadetBranches.isEmpty {
            let cadetBranches = cadetBranches
                .map(\.detailPresentation)
                .joined(separator: "\n")
            details.append(.init(title: "Cadet Branches",
                                 value: cadetBranches))
        }
        if !swornMembers.isEmpty {
            let swornMembers = swornMembers
                .map(\.detailPresentation)
                .joined(separator: "\n\n\n")
            details.append(.init(title: "Sworn Members",
                                 value: swornMembers))
        }
        
        return details
    }
}
