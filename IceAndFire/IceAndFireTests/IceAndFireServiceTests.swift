//
//  IceAndFireTests.swift
//  IceAndFireTests
//
//  Created by Martin Klöpfel on 21.04.23.
//

import XCTest
@testable import IceAndFire

final class IceAndFireServiceTests: XCTestCase {
    
    private let urlSession: URLSession = {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.protocolClasses = [MockURL.self]
        return URLSession(configuration: sessionConfiguration)
    }()
    
    private lazy var service = IceAndFireService(urlSession: urlSession)

    override func tearDown() {
        MockURL.removeAllMocks()
    }

    func testFetchFirstPageOfHouses() async throws {
        // setup mock response
        let url = URL(string: "https://www.anapioficeandfire.com/api/houses?pageSize=20")!
        let response = HTTPURLResponse(url: url,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        let path = Bundle.iceAndFireTests.path(forResource: "houses_page1", ofType: "json")!
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        MockURL.addMock(for: url, result: .success((response, data)))
        
        // fetch houses
        let result = await service.fetchHouses(from: nil)
        switch result {
        case .success(let page):
            XCTAssert(page.items.count == 20, "Service returned unexpected number of houses.")
        case .failure(let error):
            XCTFail("Failed to fetch houses: \(error.localizedDescription)")
        }
    }
    
    func testFetchNextPageOfHouses() async throws {
        // setup mock response
        let url = URL(string: "https://www.anapioficeandfire.com/api/houses?page=2&pageSize=20")!
        let response = HTTPURLResponse(url: url,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        let path = Bundle.iceAndFireTests.path(forResource: "houses_page2", ofType: "json")!
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        MockURL.addMock(for: url, result: .success((response, data)))
        
        // fetch houses
        let result = await service.fetchHouses(from: url)
        switch result {
        case .success(let page):
            XCTAssert(page.items.count == 20, "Service returned unexpected number of houses.")
        case .failure(let error):
            XCTFail("Failed to fetch houses: \(error.localizedDescription)")
        }
    }
    
    func testFetchHouse() async throws {
        // setup mock response
        let url = URL(string: "https://www.anapioficeandfire.com/api/houses/7")!
        let response = HTTPURLResponse(url: url,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        let path = Bundle.iceAndFireTests.path(forResource: "house7", ofType: "json")!
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        MockURL.addMock(for: url, result: .success((response, data)))
        
        // fetch house 7
        let result = await service.fetchHouse(from: url)
        switch result {
        case .success(let house):
            XCTAssertEqual(house.name, "House Arryn of the Eyrie", "Name of house should be \"House Arryn of the Eyrie\"")
        case .failure(let error):
            XCTFail("Failed to fetch house: \(error.localizedDescription)")
        }
    }
    
    func testFetchCharacter() async throws {
        // setup mock response
        let url = URL(string: "https://www.anapioficeandfire.com/api/characters/894")!
        let response = HTTPURLResponse(url: url,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        let path = Bundle.iceAndFireTests.path(forResource: "character894", ofType: "json")!
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        MockURL.addMock(for: url, result: .success((response, data)))
        
        // fetch character 894
        let result = await service.fetchCharacter(from: url)
        switch result {
        case .success(let character):
            XCTAssertEqual(character.name, "Robert Arryn", "Name of character should be \"Robert Arryn\"")
        case .failure(let error):
            XCTFail("Failed to fetch character: \(error.localizedDescription)")
        }
    }
}
