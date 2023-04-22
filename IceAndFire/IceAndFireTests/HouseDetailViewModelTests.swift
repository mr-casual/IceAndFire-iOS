//
//  HouseDetailViewModelTests.swift
//  IceAndFireTests
//
//  Created by Martin Klöpfel on 22.04.23.
//

import XCTest
import Combine
@testable import IceAndFire

final class HouseDetailViewModelTests: XCTestCase {
    
    private let service = MockIceAndFireService()
    private var subscriptions = [AnyCancellable]()
    
    override func tearDown() {
        service.loading = false
        subscriptions.removeAll()
    }
    
    @MainActor func testHouse() async throws {
        let viewModel = HouseDetailViewModel(house: .Mock.house7, service: service)
        XCTAssertEqual(viewModel.house, .Mock.house7, "`house` doesn't match expected test data. ")
    }
    
    @MainActor func testLoadDetails() async throws {
        // load details
        let viewModel = HouseDetailViewModel(house: .Mock.house7, service: service)
        await viewModel.loadDetails()
        
        // validate loaded houses
        guard let details = viewModel.details.content else {
            return XCTFail("Details not loaded.")
        }
        let isValid = details.currentLord?.name == "Robert Arryn"
        && details.heir?.name == "Harrold Hardyng"
        && details.overlord?.name == "House Baratheon of King's Landing"
        && details.founder?.name == "Artys I Arryn"
        && details.cadetBranches.count == 1
        && details.swornMembers.count == 24
        
        XCTAssert(isValid, "House details invalid.")
    }
}

extension ContentState {
    var content: Content? {
        switch self {
        case .content(let content):
            return content
        default:
            return nil
        }
    }
    
    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }
    
    var error: String? {
        switch self {
        case .error(let errorText):
            return errorText
        default:
            return nil
        }
    }
}
