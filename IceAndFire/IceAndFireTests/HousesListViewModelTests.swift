//
//  HousesListViewModelTests.swift
//  IceAndFireTests
//
//  Created by Martin Klöpfel on 22.04.23.
//

import XCTest
import Combine
@testable import IceAndFire

final class HousesListViewModelTests: XCTestCase {
    
    private let service = MockIceAndFireService()
    private var subscriptions = [AnyCancellable]()
    
    override func tearDown() {
        service.loading = false
        subscriptions.removeAll()
    }
    
    @MainActor func testLoadingFirstPage() async throws {
        // setup mock
        let testHouses = try House.Mock.page1()
        service.mockHouses = { _ in
            return .success(.init(items: testHouses, nextPage: nil))
        }
        // load first page
        let viewModel = HousesListViewModel(service: service)
        await viewModel.loadMore()
        
        // validate loaded houses
        XCTAssertEqual(viewModel.houses, testHouses, "`houses` doesn't match expected test data.")
    }
    
    @MainActor func testIsLoading() async throws {
        // setup mock
        service.loading = true
        
        let expectation = expectation(description: "isLoading")
        
        // load first page
        let viewModel = HousesListViewModel(service: service)
        var isLoading: Bool = viewModel.isLoading
        Task {
            await viewModel.loadMore()
        }
        
        viewModel.$isLoading
            .filter { $0 }
            .sink {
                isLoading = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        await fulfillment(of: [expectation], timeout: 1)

        // view model should
        XCTAssert(isLoading, "`isLoading` should be true")
    }
    
    @MainActor func testIsMoreAvailable() async throws {
        // setup mock
        let testHouses = try House.Mock.page1()
        service.mockHouses = { _ in
            let nextPage = URL(string: "https://www.anapioficeandfire.com/api/houses?page=2&pageSize=20")!
            return .success(.init(items: testHouses, nextPage: nextPage))
        }
        // load first page
        let viewModel = HousesListViewModel(service: service)
        await viewModel.loadMore()
        
        // view model should
        XCTAssert(viewModel.isMoreAvailable, "`isMoreAvailable` should be true")
    }
    
    @MainActor func testLoadingNextPage() async throws {
        // setup mock for first page
        let page1 = try House.Mock.page1()
        service.mockHouses = { _ in
            let nextPage = URL(string: "https://www.anapioficeandfire.com/api/houses?page=2&pageSize=20")!
            return .success(.init(items: page1, nextPage: nextPage))
        }
        // load first page
        let viewModel = HousesListViewModel(service: service)
        await viewModel.loadMore()
        
        // setup mock for second page
        let page2 = try House.Mock.page2()
        service.mockHouses = { _ in
            return .success(.init(items: page2, nextPage: nil))
        }
        // load second page
        await viewModel.loadMore()
        
        XCTAssertEqual(viewModel.houses, page1+page2, "`houses` doesn't match expected test data.")
        XCTAssertFalse(viewModel.isMoreAvailable, "`isMoreAvailable` should be false")
    }
}
