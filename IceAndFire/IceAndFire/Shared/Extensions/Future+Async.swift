//
//  Future+Async.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 22.04.23.
//

import Combine

extension Future {
    convenience init(asyncFunc: @escaping () async -> Result<Output, Failure>) {
        self.init { promise in
            Task {
                switch await asyncFunc() {
                case .success(let success):
                    promise(.success(success))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
}
