//
//  HouseDetails.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 22.04.23.
//

import Foundation

extension HouseDetailViewModel {
    struct HouseDetails {
        /// The Character of this house's current lord.
        let currentLord: Character?
        
        /// The Character of this house's heir.
        let heir: Character?
        
        /// The House that this house answers to.
        let overlord: House?

        /// The Character that founded this house.
        let founder: Character?
        
        /// An array of Houses that was founded from this house.
        let cadetBranches: [House]

        /// An array of Characters that are sworn to this house.
        let swornMembers: [Character]
    }
}
