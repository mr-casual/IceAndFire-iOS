//
//  IceAndFireTests.swift
//  IceAndFireTests
//
//  Created by Martin Klöpfel on 21.04.23.
//

import XCTest
@testable import IceAndFire

final class IceAndFireServiceTests: XCTestCase {
    
    let service = IceAndFireService(urlSession: URLSession.shared)

    override func setUp() {

    }

    override func tearDown() {

    }

    func testFetchHouses() async {
        let result = await service.fetchHouses()
        switch result {
        case .success(let houses):
            XCTAssert(houses.count == 10, "Service returned unexpected number of houses.")
        case .failure(let error):
            XCTFail("Failed to fetch houses: \(error.localizedDescription)")
        }
    }
    
    func testFetchHouse() async {
        let url = URL(string: "https://www.anapioficeandfire.com/api/houses/7")!
        let result = await service.fetchHouse(from: url)
        switch result {
        case .success(let house):
            XCTAssertEqual(house.name, "House Arryn of the Eyrie", "Name of house should be \"House Arryn of the Eyrie\"")
        case .failure(let error):
            XCTFail("Failed to fetch house: \(error.localizedDescription)")
        }
    }
    
    func testFetchCharacter() async {
        let url = URL(string: "https://www.anapioficeandfire.com/api/characters/894")!
        let result = await service.fetchCharacter(from: url)
        switch result {
        case .success(let character):
            XCTAssertEqual(character.name, "Robert Arryn", "Name of character should be \"Robert Arryn\"")
        case .failure(let error):
            XCTFail("Failed to fetch character: \(error.localizedDescription)")
        }
    }
}
