//
//  ErrorView.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 23.04.23.
//

import SwiftUI

struct ErrorView: View {
    
    let errorText: String
    let retry: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack(alignment: .center, spacing: 16) {
                Image(systemName: "xmark.circle")
                    .font(.title)
                    .foregroundColor(.red)
                Text(errorText)
            }
            Button("Retry") {
                retry()
            }
            .buttonStyle(.borderedProminent)
        }
        .alignCentered()
        .padding(.vertical, 16)
    }
}
