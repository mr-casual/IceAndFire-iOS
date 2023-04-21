//
//  HousesListView.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import SwiftUI

struct HousesListView: View {
    
    let houses: [House] = [.init(name: "House Algood"),
                           .init(name: "House Allyrion of Godsgrace"),
                           .init(name: "House Amber")]
    
    var body: some View {
        List {
            ForEach(houses) { house in
                NavigationLink {
                    HouseDetailView(house: house)
                } label: {
                    Text(house.name)
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
