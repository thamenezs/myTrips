//
//  FakeTripRepository.swift
//  MyTrips
//
//  Created by Thais Menezes on 02/11/2026.
//

@testable import MyTrips


struct FakeTripRepository: TripRepository {
    var trips: [Trip] = []
    func allTrips() throws -> [MyTrips.Trip] {
        trips
    }
    
    func save(_ trips: [MyTrips.Trip]) async throws {
    }
    
    
}
