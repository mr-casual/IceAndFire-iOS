//
//  HouseDetailView.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import SwiftUI

struct HouseDetailView: View {

    @StateObject var viewModel: HouseDetailViewModel
        
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // region
                if let region = viewModel.region {
                    Text("📍 " + region)
                        .font(.title2)
                        .alignLeft()
                }
                
                // coatOfArms
                if let coatOfArms = viewModel.coatOfArms {
                    Text(coatOfArms)
                        .font(.body)
                }

                // basic details
                ForEach(viewModel.basicDetails, id: \.self) { item in
                    DetailItemView(item: item)
                }
                
                // loaded details
                switch viewModel.moreDetails {
                case .initial:
                    Color.clear.frame(height: 1)
                        .onAppear {
                            Task { await viewModel.loadDetails() }
                        }
                case .loading:
                    ProgressView()
                        .alignCentered()
                        .padding(32)
                case .error(let errorText):
                    Text(errorText)
                case .content(let details):
                    ForEach(details, id: \.self) { item in
                        DetailItemView(item: item)
                    }
                }
            }
            .padding(16)
            .navigationTitle(viewModel.title)
        }
    }
}

extension HouseDetailView {
    struct DetailItemView: View {
        
        let item: HouseDetailViewModel.DetailItem
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Divider()
                Text(item.title.uppercased())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(item.value)
                    .font(.body)
            }
        }
    }
}

struct HouseDetailView_Previews: PreviewProvider {
    
    static let mockDetailsService = MockIceAndFireService()
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
                HouseDetailView(viewModel: .init(house: .Mock.house7,
                                                 service: mockDetailsService))
            }
            NavigationView {
                HouseDetailView(viewModel: .init(house: .Mock.house7,
                                                 service: loadingService))
            }
            NavigationView {
                HouseDetailView(viewModel: .init(house: .Mock.house7,
                                                 service: errorService))
            }
        }
    }
}
