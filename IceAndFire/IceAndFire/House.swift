//
//  House.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import Foundation

/// A House is a house branch within the Ice And Fire universe.
struct House {

    /// The hypermedia URL of this resource
    let resourceURL: URL?

    /// The name of this house
    let name: String

    /// The region that this house resides in.
    let region: String

    /// Text describing the coat of arms of this house.
    let coatOfArms: String

    ///The words of this house.
    let words: String

    /// The titles that this house holds.
    let titles: [String]

    /// The seats that this house holds.
    let seats: [String]

    /// The Character resource URL of this house's current lord.
    let currentLordURL: URL?

    /// The Character resource URL of this house's heir.
    let heirURL: URL?

    /// The House resource URL that this house answers to.
    let overlordURL: URL?

    /// The year that this house was founded.
    let founded: String

    /// The Character resource URL that founded this house.
    let founderURL: URL?

    /// The year that this house died out.
    let diedOut: String

    /// An array of names of the noteworthy weapons that this house owns.
    let ancestralWeapons: [String]

    /// An array of House resource URLs that was founded from this house.
    let cadetBranchesURLs: [URL]

    /// An array of Character resource URLs that are sworn to this house.
    let swornMembersURLs: [URL]
}

extension House: Equatable {}

extension House: Decodable {
    init(from decoder: Decoder) throws {
        let response = try _HouseResponse(from: decoder)
        self.init(resourceURL: URL(string: response.url),
                  name: response.name,
                  region: response.region,
                  coatOfArms: response.coatOfArms,
                  words: response.words,
                  titles: response.titles,
                  seats: response.seats,
                  currentLordURL: URL(string: response.currentLord),
                  heirURL: URL(string: response.currentLord),
                  overlordURL: URL(string: response.currentLord),
                  founded: response.founded,
                  founderURL: URL(string: response.currentLord),
                  diedOut: response.diedOut,
                  ancestralWeapons: response.ancestralWeapons,
                  cadetBranchesURLs: response.cadetBranches.compactMap { URL(string: $0) },
                  swornMembersURLs: response.swornMembers.compactMap { URL(string: $0) })
    }
    
    private struct _HouseResponse: Decodable {
        let url: String
        let name: String
        let region: String
        let coatOfArms: String
        let words: String
        let titles: [String]
        let seats: [String]
        let currentLord: String
        let heir: String
        let overlord: String
        let founded: String
        let founder: String
        let diedOut: String
        let ancestralWeapons: [String]
        let cadetBranches: [String]
        let swornMembers: [String]
    }
}
