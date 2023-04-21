//
//  HousesListView.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import SwiftUI

struct ListItem<T>: Identifiable {
    let id = UUID()
    let content: T
}

struct HousesListView: View {
    
    @StateObject var viewModel: HousesListViewModel

    var body: some View {
        List {
            ForEach(viewModel.house, id: \.self) { item in
                NavigationLink {
                    HouseDetailView(viewModel: HouseDetailViewModel(house: item.name))
                } label: {
                    Text(item.name)
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
