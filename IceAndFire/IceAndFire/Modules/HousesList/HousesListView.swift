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
            ForEach(viewModel.houses, id: \.self) { house in
                NavigationLink {
                    HouseDetailView(viewModel: HouseDetailViewModel(house: house.name))
                } label: {
                    Text(house.name)
                }
            }
            
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .padding(16)
                    Spacer()
                }
            } else if let errorText = viewModel.errorText {
                VStack(alignment: .center, spacing: 16) {
                    Text(errorText)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        Task { await viewModel.loadMore() }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .alignCentered()
                .padding(16)
            } else if viewModel.isMoreAvailable {
                Color.clear
                    .frame(height: 1)
                    .onAppear {
                        Task { await viewModel.loadMore() }
                    }
            }
        }
        .navigationTitle("Houses of Ice and Fire")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HousesListView(viewModel: HousesListViewModel(service: IceAndFireService(urlSession: .shared)))
        }
    }
}
