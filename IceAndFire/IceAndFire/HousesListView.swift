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
    
    let houses: [ListItem<String>] = [.init(content: "House Algood"),
                                      .init(content: "House Allyrion of Godsgrace"),
                                      .init(content: "House Amber")]
    
    var body: some View {
        List {
            ForEach(houses) { item in
                NavigationLink {
                    HouseDetailView(house: item.content)
                } label: {
                    Text(item.content)
                }
            }
        }
        .navigationTitle("IceAndFire Houses")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HousesListView()
        }
    }
}
