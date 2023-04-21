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
        case .failure:
            XCTFail("Failed to fetch houses.")
        }
    }
    
    func testFetchHouse() async {
        let url = URL(string: "https://www.anapioficeandfire.com/api/houses/7")!
        let result = await service.fetchHouse(from: url)
        switch result {
        case .success(let house):
            XCTAssertEqual(house.name, "House Arryn of the Eyrie", "Name of house should be \"House Arryn of the Eyrie\"")
        case .failure:
            XCTFail("Failed to fetch house.")
        }
    }
}
