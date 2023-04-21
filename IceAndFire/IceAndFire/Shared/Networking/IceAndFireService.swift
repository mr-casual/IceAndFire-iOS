//
//  IceAndFireService.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import Foundation

struct PageResponse<T> {
    let items: [T]
    let nextPage: URL?
}

protocol AnyIceAndFireService {
    func fetchHouses(from url: URL?) async -> Result<PageResponse<House>, RequestError>
    func fetchHouse(from url: URL) async -> Result<House, RequestError>
    func fetchCharacter(from url: URL) async -> Result<Character, RequestError>
}

class IceAndFireService: AnyIceAndFireService {

    private let httpClient: HTTPClient

    init(urlSession: URLSession) {
        self.httpClient = .init(urlSession: urlSession, decoder: JSONDecoder())
    }
    
    func fetchHouses(from url: URL?) async -> Result<PageResponse<House>, RequestError> {
        let firstPageURL = URL(string: "https://www.anapioficeandfire.com/api/houses?pageSize=20")!
        let result: HTTPClient.Result<[House]> = await httpClient.GET(url ?? firstPageURL)
        switch result {
        case .success(let success):
            var nextPage: URL?
            if let linkHeader = success.response.value(forHTTPHeaderField: "Link"),
               let nextLinkString = linkHeader.components(separatedBy: ",").first(where: { $0.matches(regex: #"rel="next""#) }),
               let urlString = nextLinkString.matchGroups(regex: #"<(.+)>"#).first {
                nextPage = URL(string: urlString)
            }
            return .success(PageResponse(items: success.object, nextPage: nextPage))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func fetchHouse(from url: URL) async -> Result<House, RequestError> {
        let result: HTTPClient.Result<House> = await httpClient.GET(url)
        switch result {
        case .success(let success):
            return .success(success.object)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func fetchCharacter(from url: URL) async -> Result<Character, RequestError> {
        let result: HTTPClient.Result<Character> = await httpClient.GET(url)
        switch result {
        case .success(let success):
            return .success(success.object)
        case .failure(let error):
            return .failure(error)
        }
    }
}
