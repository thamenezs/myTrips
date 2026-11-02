//
//  FakeTripRepository.swift
//  MyTrips
//
//  Created by Thais Menezes on 02/11/2026.
//

@testable import MyTrips
import Foundation


struct FakeTripRepository: TripRepository {
    func setFavorite(_ isFavorited: Bool, tripId: Int) throws {
    }
    
    var trips: [Trip] = []
    func allTrips() throws -> [MyTrips.Trip] {
        trips
    }
    
    func save(_ trips: [MyTrips.Trip]) async throws {
    }
    
    
}

final class InMemoryTripRepository: TripRepository, @unchecked Sendable {
    func setFavorite(_ isFavorited: Bool, tripId: Int) throws {
    }
    
    private let lock = NSLock()   // protects `trips` from being used by two threads at once
    private var trips: [Trip]

    init(trips: [Trip] = []) {
        self.trips = trips
    }

    func allTrips() throws -> [Trip] {
        lock.withLock { trips }
    }

    func save(_ newTrips: [Trip]) async throws {
        lock.withLock { trips = newTrips }
    }
}
