//
//  HousesDetailUITests.swift
//  IceAndFireUITests
//
//  Created by Martin Klöpfel on 23.04.23.
//

import XCTest

final class HousesDetailUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        app.launchArguments += ["TESTING"]
        app.launch()
    }

    func testError() throws {
        // navigation
        app.staticTexts["House Baratheon of King's Landing"].tap()

        // test content
        XCTAssert(app.buttons["Retry"].exists, "Retry button should be shown.")
    }
    
    func testFullDetails() throws {
        // navigation
        app.staticTexts["House Arryn of the Eyrie"].tap()

        // test content
        let testExamples = ["The Vale",
                            "A sky-blue falcon soaring against a white moon, on a sky-blue field",
                            "As High as Honor",
                            "King of Mountain and Vale",
                            "Lord of the Eyrie",
                            "Defender of the Vale",
                            "Warden of the East",
                            "The Eyrie",
                            "Gates of the Moon",
                            "Coming of the Andals",
                            "Robert Arryn",
                            "Harrold Hardyng",
                            "Baratheon of King",
                            "Artys I Arryn",
                            "Arryn of Gulltown",
                            "Aemma Arryn",
                            "Alyssa Arryn",
                            "Jeyne Arryn",
                            "Jon Arryn",
                            "Becca",
                            "Rodrik Arryn"]
        for example in testExamples {
            let predicate = NSPredicate(format: "label CONTAINS '\(example)'")
            let element = app.staticTexts.containing(predicate).firstMatch
            XCTAssert(element.exists, "Text \"\(example)\" should be shown")
        }
    }
}
