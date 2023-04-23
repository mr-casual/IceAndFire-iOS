//
//  Character.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import Foundation

struct Character {
    
    /// The hypermedia URL of this resource
    let resourceURL: URL?
    
    /// The name of this character
    let name: String
    
    /// The gender of this character.
    let gender: String
    
    /// Textual representation of when and where this character died.
    let died: String?
    
    /// The aliases that this character goes by.
    let aliases: [String]
    
    /// An array of actor names that has played this character in the TV show Game Of Thrones.
    let playedBy: [String]
}

extension Character: Equatable, Hashable {}

extension Character: Decodable {
    init(from decoder: Decoder) throws {
        let response = try _CharacterResponse(from: decoder)
        self.init(resourceURL: URL(string: response.url),
                  name: response.name,
                  gender: response.gender,
                  died: response.died.isNotEmpty ? response.died : nil,
                  aliases: response.aliases.filter(\.isNotEmpty),
                  playedBy: response.playedBy.filter(\.isNotEmpty))
    }
    
    private struct _CharacterResponse: Decodable {
        let url: String
        let name: String
        let gender: String
        let died: String
        let aliases: [String]
        let playedBy: [String]
    }
}
