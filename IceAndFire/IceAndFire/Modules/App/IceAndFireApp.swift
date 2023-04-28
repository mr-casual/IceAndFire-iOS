//
//  IceAndFireApp.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import SwiftUI

@main
struct IceAndFireApp: App {
    
    private let service: AnyIceAndFireService
    
    init() {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("TESTING") {
            UIView.setAnimationsEnabled(false)
            service = MockIceAndFireService()
        } else {
            service = IceAndFireService(urlSession: .shared)
        }
        #else
        service = IceAndFireService(urlSession: .shared)
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HousesListView(viewModel: HousesListViewModel(service: service))
            }
        }
    }
}
