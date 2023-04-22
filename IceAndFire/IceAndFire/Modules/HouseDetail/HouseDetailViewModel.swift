//
//  HouseDetailViewModel.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 21.04.23.
//

import Foundation
import Combine

@MainActor
class HouseDetailViewModel: ObservableObject {
        
    let house: House
    @Published var details: ContentState<House.Details> = .initial
    
    private let service: AnyIceAndFireService
    
    init(house: House,
         service: AnyIceAndFireService) {
        self.house = house
        self.service = service
    }
    
    func loadDetails() async {
        switch details {
        case .loading, .content:
            return // do not load a twice
        default: break
        }
        
        details = .loading
        
        // create future for each partial resource
        let currentLordFuture = service.characterPublisher(url: house.currentLordURL)
        let heirFuture = service.characterPublisher(url: house.heirURL)
        let overlordFuture = service.housePublisher(url: house.overlordURL)
        let founderFuture = service.characterPublisher(url: house.founderURL)
        let cadetBranchesFutures = house.cadetBranchesURLs.map { service.housePublisher(url: $0) }
        let swornMembersFutures = house.swornMembersURLs.map { service.characterPublisher(url: $0) }
        // combine sub parts
        let firstPartPublisher = currentLordFuture.zip(heirFuture,
                                                       overlordFuture,
                                                       founderFuture)
        let cadetBranchesPublisher = Publishers.MergeMany(cadetBranchesFutures).collect().compactMap { $0 }
        let swornMembersPublisher = Publishers.MergeMany(swornMembersFutures).collect().compactMap { $0 }
        // combine everything together and map to house details
        let combinedDetailsPublisher = firstPartPublisher.zip(cadetBranchesPublisher,
                                                              swornMembersPublisher) { firstPart, cadetBranches, swornMembers in
            House.Details(currentLord: firstPart.0,
                          heir: firstPart.1,
                          overlord: firstPart.2,
                          founder: firstPart.3,
                          cadetBranches: cadetBranches.compactMap { $0 },
                          swornMembers: swornMembers.compactMap { $0 })
        }
        
        var subscriptions = Set<AnyCancellable>()
        details = await withCheckedContinuation { continuation in
            combinedDetailsPublisher
                .map { ContentState<House.Details>.content($0) }
                .catch({ Just(.error($0.presentation)) })
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: {
                    continuation.resume(returning: $0)
                })
                .store(in: &subscriptions)
        }
    }
}

// map the async service methods to futures
fileprivate extension AnyIceAndFireService {
    
    func characterPublisher(url: URL?) -> Future<Character?, RequestError> {
        return Future(asyncFunc: { [weak self] in
            guard let self, let url else { return .success(nil) }
            return await self.fetchCharacter(from: url).withOptionalSuccess()
        })
    }
    
    func housePublisher(url: URL?) -> Future<House?, RequestError> {
        return Future(asyncFunc: { [weak self] in
            guard let self, let url else { return .success(nil) }
            return await self.fetchHouse(from: url).withOptionalSuccess()
        })
    }
}
