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
    
    var mockHouses: (URL?) -> Result<PageResponse<House>, RequestError> = { url in
        let secondPage = URL(string: "https://www.anapioficeandfire.com/api/houses?page=2&pageSize=20")!
        switch url {
        case .none:
            return .success(.init(items: (try? House.Mock.page1()) ?? [], nextPage: secondPage))
        case secondPage:
            return .success(.init(items: (try? House.Mock.page2()) ?? [], nextPage: nil))
        default:
            return .success(.init(items: [], nextPage: nil))
        }
    }
    
    var mockHouse: (URL) -> Result<House, RequestError> = { url in
        let urlPattern = #"https:\/\/www.anapioficeandfire.com\/api\/houses\/(.+)"#
        guard let id = url.absoluteString.matchGroups(regex: urlPattern).first,
              let path = Bundle.main.path(forResource: "house\(id)", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
              let house = try? JSONDecoder().decode(House.self, from: data) else {
            return .failure(.unknow(nil, data: nil))
        }
        return .success(house)
    }
    
    var mockCharacter: (URL) -> Result<Character, RequestError> = { url in
        let urlPattern = #"https:\/\/www.anapioficeandfire.com\/api\/characters\/(.+)"#
        guard let id = url.absoluteString.matchGroups(regex: urlPattern).first,
              let path = Bundle.main.path(forResource: "character\(id)", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
              let character = try? JSONDecoder().decode(Character.self, from: data) else {
            return .failure(.unknow(nil, data: nil))
        }
        return .success(character)
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
