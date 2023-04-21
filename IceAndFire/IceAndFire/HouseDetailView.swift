//
//  HouseDetailView.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import SwiftUI

struct HouseDetailView: View {
    let house: String
    
    var body: some View {
        Text(house)
    }
}

struct HouseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HouseDetailView(house: "House Ambrose")
    }
}
