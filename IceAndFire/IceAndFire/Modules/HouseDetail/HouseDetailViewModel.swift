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
        self.basicDetails = Self.basicDetails(house: house)
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
            House.Details(currentLord: firstPart.0,
                          heir: firstPart.1,
                          overlord: firstPart.2,
                          founder: firstPart.3,
                          cadetBranches: cadetBranches.compactMap { $0 },
                          swornMembers: swornMembers.compactMap { $0 })
        }
        
        var subscriptions = Set<AnyCancellable>()
        let houseDetails = await withCheckedContinuation { continuation in
            combinedDetailsPublisher
                .map { ContentState<House.Details>.content($0) }
                .catch({ Just(.error($0.presentation)) })
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: {
                    continuation.resume(returning: $0)
                })
                .store(in: &subscriptions)
        }
        // map house details to array of details item
        moreDetails = houseDetails.mapContent { Self.moreDetails(houseDetails: $0) }
    }
    
    static func basicDetails(house: House) -> [DetailItem] {
        var details = [DetailItem]()
        
        if let words = house.words {
            details.append(.init(title: "Words", value: words))
        }
        if !house.titles.isEmpty {
            let titlesString = house.titles.joined(separator: "\n")
            details.append(.init(title: "Titles", value: titlesString))
        }
        if !house.seats.isEmpty {
            let seatsString = house.seats.joined(separator: "\n")
            details.append(.init(title: "Seats", value: seatsString))
        }
        if let founded = house.founded {
            details.append(.init(title: "Founded", value: founded))
        }
        if let diedOut = house.diedOut {
            details.append(.init(title: "Died out", value: diedOut))
        }
        if !house.ancestralWeapons.isEmpty {
            let ancestralWeaponsString = house.ancestralWeapons.joined(separator: "\n")
            details.append(.init(title: "Ancestral Weapons", value: ancestralWeaponsString))
        }
        return details
    }
    
    static func moreDetails(houseDetails: House.Details) -> [DetailItem] {
        var details = [DetailItem]()
        
        if let currentLord = houseDetails.currentLord {
            details.append(.init(title: "Current Lord",
                                 value: currentLord.detailPresentation))
        }
        if let heir = houseDetails.heir {
            details.append(.init(title: "Heir",
                                 value: heir.detailPresentation))
        }
        if let overlord = houseDetails.overlord {
            details.append(.init(title: "Overlord",
                                 value: overlord.detailPresentation))
        }
        if let founder = houseDetails.founder {
            details.append(.init(title: "Founder",
                                 value: founder.detailPresentation))
        }
        if !houseDetails.cadetBranches.isEmpty {
            let cadetBranches = houseDetails.cadetBranches
                .map(\.detailPresentation)
                .joined(separator: "\n")
            details.append(.init(title: "Cadet Branches",
                                 value: cadetBranches))
        }
        if !houseDetails.swornMembers.isEmpty {
            let swornMembers = houseDetails.swornMembers
                .map(\.detailPresentation)
                .joined(separator: "\n\n\n")
            details.append(.init(title: "Sworn Members",
                                 value: swornMembers))
        }
        
        return details
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
