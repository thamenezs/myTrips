//
//  RealmTripRepositoryMock.swift
//  MyTrips
//
//  Created by Thais Menezes on 02/11/2026.
//

final class RealmTripRepositoryMock: TripRepository {
    
    func allTrips() throws -> [Trip] {
        [Trip(id: 1, name: "Brasil 21", country: "Brasil", days: 21), Trip(id: 2, name: "Italia 2", country: "Italy", days: 4)]
    }
    
    func save(_ trips: [Trip]) async throws {
        print("SAVED")
    }
}
