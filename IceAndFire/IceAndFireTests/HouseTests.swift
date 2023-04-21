//
//  HouseTests.swift
//  IceAndFireTests
//
//  Created by Martin Klöpfel on 21.04.23.
//

import XCTest
@testable import IceAndFire

final class HouseTests: XCTestCase {
    
    let decoder = JSONDecoder()
    
    func testDecodingOfSingleHouse() throws {
        guard let path = Bundle.iceAndFireTests.path(forResource: "house7", ofType: "json") else {
            return XCTFail("Missing mock data: house7.json")
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let decodeHouse = try decoder.decode(House.self, from: data)
        let testHouse = House(resourceURL: .init(string: "https://www.anapioficeandfire.com/api/houses/7")!,
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
                              diedOut: "",
                              ancestralWeapons: [""],
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
        
        XCTAssertEqual(decodeHouse, testHouse, "Decoded house doesn't match test data.")
    }
    
    func testDecodingArrayOfHouses() throws {
        guard let path = Bundle.iceAndFireTests.path(forResource: "houses", ofType: "json") else {
            return XCTFail("Missing mock data: houses.json")
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let houses = try decoder.decode([House].self, from: data)
        
        XCTAssert(houses.count == 50, "Number of houses should be 50.")
    }
}
