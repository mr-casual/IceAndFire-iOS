//
//  View+Alignment.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 22.04.23.
//

import SwiftUI

public extension View {
    
    func alignLeading() -> some View {
        VStack(alignment: .leading) {
            self
        }
    }

    func alignCentered() -> some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            self
            Spacer(minLength: 0)
        }
    }
}
