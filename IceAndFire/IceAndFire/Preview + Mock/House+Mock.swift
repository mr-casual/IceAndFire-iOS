//
//  House+Mock.swift
//  IceAndFireTests
//
//  Created by Martin Klöpfel on 22.04.23.
//
#if DEBUG
import Foundation

extension House {
    struct Mock {
        static var house7: House {
            House(resourceURL: .init(string: "https://www.anapioficeandfire.com/api/houses/7")!,
                  name: "House Arryn of the Eyrie",
                  region: "The Vale",
                  coatOfArms: "A sky-blue falcon soaring against a white moon, on a sky-blue field(Bleu celeste, upon a plate a falcon volant of the field)",
                  words: "As High as Honor",
                  titles: ["King of Mountain and Vale (formerly)",
                           "Lord of the Eyrie",
                           "Defender of the Vale",
                           "Warden of the East"],
                  seats: ["The Eyrie (summer)",
                          "Gates of the Moon (winter)"],
                  currentLordURL: .init(string: "https://www.anapioficeandfire.com/api/characters/894")!,
                  heirURL: .init(string: "https://www.anapioficeandfire.com/api/characters/477")!,
                  overlordURL: .init(string: "https://www.anapioficeandfire.com/api/houses/16")!,
                  founded: "Coming of the Andals",
                  founderURL: .init(string: "https://www.anapioficeandfire.com/api/characters/144")!,
                  diedOut: nil,
                  ancestralWeapons: [],
                  cadetBranchesURLs: [.init(string: "https://www.anapioficeandfire.com/api/houses/6")!],
                  swornMembersURLs: [.init(string: "https://www.anapioficeandfire.com/api/characters/49")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/92")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/93")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/107")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/223")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/265")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/300")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/356")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/477")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/508")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/540")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/548")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/558")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/572")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/688")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/894")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/1068")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/1193")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/1280")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/1443")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/1655")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/1693")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/1715")!,
                                     .init(string: "https://www.anapioficeandfire.com/api/characters/1884")!])
        }
        
        static func page1() throws -> [House] {
            let path = Bundle.main.path(forResource: "houses_page1", ofType: "json")!
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return try JSONDecoder().decode([House].self, from: data)
        }
        
        static func page2() throws -> [House] {
            let path = Bundle.main.path(forResource: "houses_page2", ofType: "json")!
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return try JSONDecoder().decode([House].self, from: data)
        }
    }
}
#endif
