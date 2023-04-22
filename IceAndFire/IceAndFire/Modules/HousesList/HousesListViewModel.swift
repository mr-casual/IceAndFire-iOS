//
//  HousesListViewModel.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import Foundation

@MainActor
class HousesListViewModel: ObservableObject {
    
    @Published var houses: [House] = []
    @Published var isMoreAvailable: Bool = true
    @Published var isLoading: Bool = false
    @Published var errorText: String?
    
    private var nextPage: URL? {
        didSet {
            isMoreAvailable = nextPage != nil
        }
    }
    private let service: AnyIceAndFireService
    
    init(service: AnyIceAndFireService) {
        self.service = service
    }
    
    func loadMore() async {
        isLoading = true
        switch await service.fetchHouses(from: nextPage) {
        case .success(let page):
            houses.append(contentsOf: page.items)
            nextPage = page.nextPage
            errorText = nil
        case .failure(let error):
            print("Fetching houses failed: \(error.localizedDescription)")
            errorText = error.presentation
        }
        isLoading = false
    }
}
