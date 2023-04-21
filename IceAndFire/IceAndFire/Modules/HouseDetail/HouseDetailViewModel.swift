//
//  HouseDetailViewModel.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import Foundation

class HouseDetailViewModel: ObservableObject {
    
    let house: String
    
    init(house: String) {
        self.house = house
    }
}
