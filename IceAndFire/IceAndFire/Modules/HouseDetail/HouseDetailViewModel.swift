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
    
    var title: String {
        return house.name.replacingOccurrences(of: "House ", with: "")
    }
    
    var region: String? {
        house.region
    }
    
    var coatOfArms: String? {
        house.coatOfArms
    }
    
    let basicDetails: [DetailItem]
    
    @Published var moreDetails: ContentState<[DetailItem]> = .initial
    
    private let house: House

    private let service: AnyIceAndFireService
    
    init(house: House,
         service: AnyIceAndFireService) {
        self.house = house
        self.service = service
        self.basicDetails = house.toDetailItems()
    }
    
    func loadDetails() async {
        switch moreDetails {
        case .loading, .content:
            return // do not load a twice
        default: break
        }
        
        moreDetails = .loading
        
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
            // filter out nil values and sort by name,
            // because merge and collect results in random order
            let sortedCadetBranches = cadetBranches.compactMap { $0 }.sorted { $0.name < $1.name }
            let sortedSwornMembers = swornMembers.compactMap { $0 }.sorted { $0.name < $1.name }
            
            return HouseDetails(currentLord: firstPart.0,
                                heir: firstPart.1,
                                overlord: firstPart.2,
                                founder: firstPart.3,
                                cadetBranches: sortedCadetBranches,
                                swornMembers: sortedSwornMembers)
        }
        
        var subscriptions = Set<AnyCancellable>()
        let houseDetails = await withCheckedContinuation { continuation in
            combinedDetailsPublisher
                .map { ContentState<HouseDetails>.content($0) }
                .catch({ Just(.error($0.presentation)) })
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: {
                    continuation.resume(returning: $0)
                })
                .store(in: &subscriptions)
        }
        // map house details to array of details item
        moreDetails = houseDetails.mapContent { $0.toDetailItems() }
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
