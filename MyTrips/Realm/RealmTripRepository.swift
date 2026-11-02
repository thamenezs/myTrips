//
//  RealTripRepository.swift
//  MyTrips
//
//  Created by Thais Menezes on 02/11/2026.
//

import RealmSwift
import Foundation

protocol TripRepository {
    func allTrips() throws -> [Trip]
    func save(_ trips: [Trip]) async throws
}

class RealmTripRepository: TripRepository {
    
    func allTrips() throws -> [Trip] {
        let realm = try Realm()
        return realm.objects(TripObject.self).map { Trip($0)}
    }
    
    func save(_ trips: [Trip]) async throws {
//        let realm = try Realm()
//            try realm.write {
//                for trip in trips {
//                    realm.add(TripObject(trip), update: .modified)
//                }
//            }
        
        try await Task.detached {
            let realm = try Realm()
            try realm.write {
                for trip in trips {
                    realm.add(TripObject(trip), update: .modified)
                }
            }
        }.value
        
    }
    
    
}
