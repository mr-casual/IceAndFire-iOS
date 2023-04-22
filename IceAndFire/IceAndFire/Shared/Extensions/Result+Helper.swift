//
//  Result+Helper.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 22.04.23.
//

import Foundation

extension Result {
    func withOptionalSuccess() -> Result<Success?, Failure> {
        switch self {
        case .success(let success):
            return .success(success)
        case .failure(let error):
            return .failure(error)
        }
    }
}
