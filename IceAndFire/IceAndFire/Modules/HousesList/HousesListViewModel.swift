//
//  HousesListViewModel.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import Foundation

@MainActor
class HousesListViewModel: ObservableObject {
    
    @Published var house: [House] = []

    private let service: IceAndFireService
    
    init(service: IceAndFireService) {
        self.service = service
        
        Task { await loadHouses() }
    }
    
    func loadHouses() async {
        switch await service.fetchHouses() {
        case .success(let houses):
            self.house.append(contentsOf: houses)
        case .failure(let error):
            print("Fetching houses failed: \(error.localizedDescription)")
        }
    }
}
