//
//  IceAndFireService.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import Foundation

protocol AnyIceAndFireService {
    func fetchHouses() async -> Result<[House], Error>
}

class IceAndFireService {
    
    private let urlSession: URLSession
    private let baseURL = URL(string: "https://www.anapioficeandfire.com/api/")!
    private let decoder = JSONDecoder()
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func fetchHouses() async -> Result<[House], Error> {
        let url = baseURL.appendingPathComponent("houses")
        
        let request = URLRequest(url: url)
        do {
            let (data, _) = try await urlSession.data(for: request)
            return .success(try decoder.decode([House].self, from: data))
        } catch {
            return .failure(error)
        }
    }
    
    func fetchHouse(from url: URL) async -> Result<House, Error> {
        let request = URLRequest(url: url)
        do {
            let (data, _) = try await urlSession.data(for: request)
            return .success(try decoder.decode(House.self, from: data))
        } catch {
            return .failure(error)
        }
    }
}
