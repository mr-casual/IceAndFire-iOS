//
//  IceAndFireUITests.swift
//  IceAndFireUITests
//
//  Created by Martin Klöpfel on 21.04.23.
//

import XCTest

final class IceAndFireUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    private func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }
}
