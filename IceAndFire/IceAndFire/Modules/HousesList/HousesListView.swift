//
//  HousesListView.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import SwiftUI

struct HousesListView: View {
    
    @StateObject var viewModel: HousesListViewModel
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.houses, id: \.self) { house in
                    NavigationLink {
                        HouseDetailView(viewModel: .init(house: house,
                                                         service: viewModel.service))
                    } label: {
                        Text(house.name)
                    }
                }
            } footer: {
                if viewModel.isLoading {
                    ProgressView()
                        .alignCentered()
                        .padding(16)
                } else if let errorText = viewModel.errorText {
                    ErrorView(errorText: errorText) {
                        Task { viewModel.loadMore }
                    }
                } else if viewModel.isMoreAvailable {
                    Color.clear
                        .frame(height: 1)
                        .onAppear {
                            Task { await viewModel.loadMore() }
                        }
                }
            }
        }
        .navigationTitle("Houses of Ice and Fire")
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    
    static let firstPageService = MockIceAndFireService()
    static let loadingService: MockIceAndFireService = {
        let service = MockIceAndFireService()
        service.loading = true
        return service
    }()
    static let errorService: MockIceAndFireService = {
        let service = MockIceAndFireService()
        service.mockHouses = { _ in
            return .failure(.urlError(.init(.notConnectedToInternet)))
        }
        return service
    }()
    
    static var previews: some View {
        Group {
            NavigationView {
                HousesListView(viewModel: .init(service: firstPageService))
            }
            .previewDisplayName("Content")
            
            NavigationView {
                HousesListView(viewModel: .init(service: loadingService))
            }
            .previewDisplayName("Loading")
            
            NavigationView {
                HousesListView(viewModel: .init(service: errorService))
            }
            .previewDisplayName("Error")
        }
    }
}
#endif
