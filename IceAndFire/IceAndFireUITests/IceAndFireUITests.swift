//
//  IceAndFireUITests.swift
//  IceAndFireUITests
//
//  Created by Martin Klöpfel on 21.04.23.
//

import XCTest

final class HousesListUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        app.launchArguments += ["TESTING"]
        app.launch()
    }

    override func tearDown() {
        app.terminate()
    }

    func testFirstPage() throws {
        // testing a bunch of houses of first page (not all)
        let testExamples = ["House Algood",
                            "House Allyrion of Godsgrace",
                            "House Amber",
                            "House Ambrose",
                            "House Appleton of Appleton"]
        
        for testExample in testExamples {
            XCTAssert(app.staticTexts[testExample].exists, "Text \"\(testExample)\" should be shown")
        }
    }
    
    func testPagination() throws {
        // testing a bunch of houses of second page (not all)
        let testExamples = ["House Bigglestone",
                            "House Blackbar of Bandallon",
                            "House Blackfyre of King's Landing",
                            "House Blackmont of Blackmont",
                            "House Blackmyre"]
        app.swipeUp()
        app.swipeUp()
        
        for testExample in testExamples {
            XCTAssert(app.staticTexts[testExample].exists, "Text \"\(testExample)\" should be shown")
        }
    }
    
    func testNavigation() throws {
        app.staticTexts["House Baratheon of King's Landing"].tap()
        XCTAssert(app.otherElements["HouseDetailView"].exists, "Navigation failed.")
    }
}
