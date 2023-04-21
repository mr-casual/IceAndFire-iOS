//
//  IceAndFireApp.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import SwiftUI

@main
struct IceAndFireApp: App {
    
    private let service = IceAndFireService(urlSession: .shared)
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HousesListView(viewModel: HousesListViewModel(service: service))
            }
        }
    }
}
