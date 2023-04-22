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
        let testHouse = House.Mock.house7
        XCTAssertEqual(decodeHouse, testHouse, "Decoded house doesn't match test data.")
    }
    
    func testDecodingArrayOfHouses() throws {
        guard let path = Bundle.iceAndFireTests.path(forResource: "houses_page1", ofType: "json") else {
            return XCTFail("Missing mock data: houses.json")
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let houses = try decoder.decode([House].self, from: data)
        
        XCTAssert(houses.count == 20, "Number of houses should be 50.")
    }
}
