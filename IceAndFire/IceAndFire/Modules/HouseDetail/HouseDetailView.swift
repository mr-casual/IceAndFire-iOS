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
        Text(viewModel.house.name)
        
        switch viewModel.details {
        case .initial:
            Color.clear.frame(height: 1)
                .onAppear {
                    Task { await viewModel.loadDetails() }
                }
        case .loading:
            ProgressView()
        case .error(let errorText):
            Text(errorText)
        case .content(let details):
            Text("Overlord: \(details.overlord?.name ?? "")")
        }
    }
}

//struct HouseDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        HouseDetailView(viewModel: HouseDetailViewModel(house: "House Ambrose"))
//    }
//}
