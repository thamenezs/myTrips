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
    func setFavorite(_ isFavorited: Bool, tripId: Int) throws
}

class RealmTripRepository: TripRepository {
    func setFavorite(_ isFavorited: Bool, tripId: Int) throws {
        let realm = try Realm()
        guard let trip = realm.object(ofType: TripObject.self, forPrimaryKey: tripId) else {
            return
        }
        try realm.write {
            trip.isFavorited = isFavorited
        }
        
    }
    
    
    func allTrips() throws -> [Trip] {
        let realm = try Realm()
        return realm.objects(TripObject.self).map { Trip($0)}
    }
    
    func save(_ trips: [Trip]) async throws {
        try await Task.detached {
            let realm = try Realm()
            try realm.write {
                for trip in trips {
                    if let existing = realm.object(ofType: TripObject.self, forPrimaryKey: trip.id) {
                        existing.name = trip.name
                        existing.country = trip.country
                        existing.durationInDays = trip.days
                    } else {
                        realm.add(TripObject(trip))
                    }
                }
            }
        }.value
    }
    
    
}
