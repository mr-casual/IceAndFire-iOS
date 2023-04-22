//
//  View+Alignment.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 22.04.23.
//

import SwiftUI

public extension View {
    
    func alignLeft() -> some View {
        HStack(spacing: 0) {
            self
            Spacer(minLength: 0)
        }
    }
    
    func alignRight() -> some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
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
