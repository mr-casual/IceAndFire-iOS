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
        let secondPage = URL(string: "\(APIConstants.baseURLString)houses?page=2&pageSize=\(APIConstants.pageSize)")!
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
        let urlPattern = "\(APIConstants.baseURLString.withEscapedSlashes)houses\\/(.+)"
        guard let id = url.absoluteString.matchGroups(regex: urlPattern).first,
              let path = Bundle.main.path(forResource: "house\(id)", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
              let house = try? JSONDecoder().decode(House.self, from: data) else {
            return .failure(.unknow(nil, data: nil))
        }
        return .success(house)
    }
    
    var mockCharacter: (URL) -> Result<Character, RequestError> = { url in
        let urlPattern = "\(APIConstants.baseURLString.withEscapedSlashes)characters\\/(.+)"
        guard let id = url.absoluteString.matchGroups(regex: urlPattern).first,
              let path = Bundle.main.path(forResource: "character\(id)", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
              let character = try? JSONDecoder().decode(Character.self, from: data) else {
            return .failure(.unknow(nil, data: nil))
        }
        return .success(character)
    }
    
    func fetchHouses(from url: URL?) async -> Result<PageResponse<House>, RequestError> {
        await keepLoadingIfNeeded()
        return mockHouses(url)
    }
    
    func fetchHouse(from url: URL) async -> Result<House, RequestError> {
        await keepLoadingIfNeeded()
        return mockHouse(url)
    }
        
    func fetchCharacter(from url: URL) async -> Result<Character, RequestError> {
        await keepLoadingIfNeeded()
        return mockCharacter(url)
    }
    
    func keepLoadingIfNeeded() async {
        if loading {
            while true {
                try? await Task.sleep(nanoseconds: .max)
            }
        }
    }
}

fileprivate extension String {
    var withEscapedSlashes: Self {
        return self.replacingOccurrences(of: "/", with: #"\/"#)
    }
}

#endif
