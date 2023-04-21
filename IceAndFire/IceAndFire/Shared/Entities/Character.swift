//
//  Character.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import Foundation

struct Character: Decodable {
    
    /// The hypermedia URL of this resource
    let url: URL?
    
    /// The name of this character
    let name: String
    
    /// The gender of this character.
    let gender: String
    
    /// Textual representation of when and where this character died.
    let died: String
    
    /// The aliases that this character goes by.
    let aliases: [String]
    
    /// An array of actor names that has played this character in the TV show Game Of Thrones.
    let playedBy: [String]
}

extension Character: Equatable, Hashable {}
