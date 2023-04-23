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
    
    @MainActor func testTitle() async throws {
        let viewModel = HouseDetailViewModel(house: .Mock.house7, service: service)
        XCTAssertEqual(viewModel.title, "Arryn of the Eyrie", "Wrong title.")
    }
    
    @MainActor func testRegion() async throws {
        let viewModel = HouseDetailViewModel(house: .Mock.house7, service: service)
        XCTAssertEqual(viewModel.region, "The Vale", "Wrong title.")
    }
    
    @MainActor func testCoatOfArms() async throws {
        let viewModel = HouseDetailViewModel(house: .Mock.house7, service: service)
        let coatOfArms = "A sky-blue falcon soaring against a white moon, on a sky-blue field(Bleu celeste, upon a plate a falcon volant of the field)"
        XCTAssertEqual(viewModel.coatOfArms, coatOfArms, "Wrong title.")
    }
    
    @MainActor func testLoadDetails() async throws {
        // load details
        let viewModel = HouseDetailViewModel(house: .Mock.house7, service: service)
        await viewModel.loadDetails()
        
        // validate loaded houses
        guard let moreDetails = viewModel.moreDetails.content else {
            return XCTFail("Details not loaded.")
        }
        let currentLordItem = moreDetails.first { $0.title == "Current Lord" }
        let heirItem = moreDetails.first { $0.title == "Heir" }
        let overlordItem = moreDetails.first { $0.title == "Overlord" }
        let founderItem = moreDetails.first { $0.title == "Founder" }
        let cadetBranchesItem = moreDetails.first { $0.title == "Cadet Branches" }
        let swornMembersItem = moreDetails.first { $0.title == "Sworn Members" }
        
        let isValid = (currentLordItem?.value.matches(regex: "Robert Arryn") ?? true)
        && (heirItem?.value.matches(regex: "Harrold Hardyng") ?? true)
        && (overlordItem?.value.matches(regex: "Baratheon of King's Landing") ?? true)
        && (founderItem?.value.matches(regex: "Artys I Arryn") ?? true)
        && (cadetBranchesItem?.value.matches(regex: "Arryn of Gulltown") ?? true)
        && (swornMembersItem?.value.matches(regex: "Aemma Arryn") ?? true)
        && (swornMembersItem?.value.matches(regex: "Rodrik Arryn") ?? true)

        XCTAssert(isValid, "House details invalid.")
    }
    
    @MainActor func testIsLoading() throws {
        // setup mock
        service.loading = true
        
        let expectation = expectation(description: "isLoading")
        
        // load first page
        let viewModel = HouseDetailViewModel(house: .Mock.house7, service: service)
        var isLoading: Bool = viewModel.moreDetails.isLoading
        Task {
            await viewModel.loadDetails()
        }
        
        viewModel.$moreDetails
            .filter { $0.isLoading }
            .sink { _ in
                isLoading = true
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 1)
        
        // view model should
        XCTAssert(isLoading, "`isLoading` should be true")
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
