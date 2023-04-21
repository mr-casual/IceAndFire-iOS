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
        return await httpClient.GET(url)
    }

    func fetchHouse(from url: URL) async -> Result<House, RequestError> {
        return await httpClient.GET(url)
    }

    func fetchCharacter(from url: URL) async -> Result<Character, RequestError> {
        return await httpClient.GET(url)
    }
}
