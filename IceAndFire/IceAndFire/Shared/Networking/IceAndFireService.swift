//
//  IceAndFireService.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import Foundation

protocol AnyIceAndFireService {
    func fetchHouses() async -> Result<[House], RequestError>
    func fetchHouse(from url: URL) async -> Result<House, RequestError>
    func fetchCharacter(from url: URL) async -> Result<Character, RequestError>
}

class IceAndFireService: AnyIceAndFireService {

    private let httpClient: HTTPClient
    private let baseURL = URL(string: "https://www.anapioficeandfire.com/api/")!

    init(urlSession: URLSession) {
        self.httpClient = .init(urlSession: urlSession, decoder: JSONDecoder())
    }
    
    func fetchHouses() async -> Result<[House], RequestError> {
        let url = baseURL.appendingPathComponent("houses")
        let result: HTTPClient.Result<[House]> = await httpClient.GET(url)
        switch result {
        case .success(let success):
            return .success(success.object)
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
