//
//  MockIceAndFireService.swift
//  IceAndFireTests
//
//  Created by Martin Klöpfel on 22.04.23.
//
#if DEBUG
import Foundation

class MockIceAndFireService: AnyIceAndFireService {
    
    var loading: Bool = false
    
    var mockHouses: (URL?) -> Result<PageResponse<House>, RequestError> = { _ in
        return .success(.init(items: (try? House.Mock.page1()) ?? [], nextPage: nil))
    }
    
    var mockHouse: (URL) -> Result<House, RequestError> = { _ in
        return .success(.Mock.house7)
    }
    
    var mockCharacter: (URL) -> Result<Character, RequestError> = { _ in
        return .success(.Mock.character894)
    }
    
    func fetchHouses(from url: URL?) async -> Result<PageResponse<House>, RequestError> {
        if loading {
            while true {
                try? await Task.sleep(nanoseconds: .max)
            }
        }
        
        return mockHouses(url)
    }
    
    func fetchHouse(from url: URL) async -> Result<House, RequestError> {
        if loading {
            while true {
                try? await Task.sleep(nanoseconds: .max)
            }
        }
        return mockHouse(url)
    }
    
    func fetchCharacter(from url: URL) async -> Result<Character, RequestError> {
        if loading {
            while true {
                try? await Task.sleep(nanoseconds: .max)
            }
        }
        return mockCharacter(url)
    }
}
#endif
