//
//  IceAndFireApp.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import SwiftUI

@main
struct IceAndFireApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HousesListView()
            }
        }
    }
}
