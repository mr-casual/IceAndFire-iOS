//
//  HouseDetailView.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import SwiftUI

struct HouseDetailView: View {
    let house: House
    
    var body: some View {
        Text(house.name)
    }
}

struct HouseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HouseDetailView(house: .init(name: "House Ambrose"))
    }
}
