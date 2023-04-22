//
//  CharacterTests.swift
//  IceAndFireTests
//
//  Created by Martin Klöpfel on 21.04.23.
//

import XCTest
@testable import IceAndFire

final class CharacterTests: XCTestCase {
    
    let decoder = JSONDecoder()
    
    func testDecodingOfSingleCharacter() throws {
        guard let path = Bundle.main.path(forResource: "character894", ofType: "json") else {
            return XCTFail("Missing mock data: character894.json")
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let decodeCharacter = try decoder.decode(Character.self, from: data)
        let testCharacter = Character.Mock.character894
        
        XCTAssertEqual(decodeCharacter, testCharacter, "Decoded character doesn't match test data.")
    }
    
    func testDecodingArrayOfCharacters() throws {
        guard let path = Bundle.main.path(forResource: "characters", ofType: "json") else {
            return XCTFail("Missing mock data: characters.json")
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let houses = try decoder.decode([Character].self, from: data)
        
        XCTAssert(houses.count == 50, "Number of characters should be 50.")
    }
}
