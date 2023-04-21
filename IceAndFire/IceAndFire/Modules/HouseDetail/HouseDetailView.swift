//
//  HouseDetailView.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import SwiftUI

struct HouseDetailView: View {
    
    let viewModel: HouseDetailViewModel
    
    var body: some View {
        Text(viewModel.house)
    }
}

struct HouseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HouseDetailView(viewModel: HouseDetailViewModel(house: "House Ambrose"))
    }
}
