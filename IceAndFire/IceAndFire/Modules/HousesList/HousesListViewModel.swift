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
    @Published var isMoreAvailable: Bool = true
    @Published var isLoading: Bool = false
    
    private var nextPage: URL? {
        didSet {
            isMoreAvailable = nextPage != nil
        }
    }
    private let service: IceAndFireService
    
    init(service: IceAndFireService) {
        self.service = service
    }
    
    func loadMore() {
        Task {
            switch await service.fetchHouses(from: nextPage) {
            case .success(let page):
                house.append(contentsOf: page.items)
                nextPage = page.nextPage
            case .failure(let error):
                print("Fetching houses failed: \(error.localizedDescription)")
            }
        }
    }
}
