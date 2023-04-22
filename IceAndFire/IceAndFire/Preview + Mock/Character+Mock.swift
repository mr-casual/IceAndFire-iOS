//
//  Character+Mock.swift
//  IceAndFireTests
//
//  Created by Martin Klöpfel on 22.04.23.
//
#if DEBUG
import Foundation

extension Character {
    struct Mock {
        static var character894: Character {
            Character(url: .init(string: "https://www.anapioficeandfire.com/api/characters/894"),
                      name: "Robert Arryn",
                      gender: "Male",
                      died: "",
                      aliases: ["Sweetrobin",
                                "True Warden of the East"],
                      playedBy: ["Lino Facioli"])
        }
    }
}
#endif
