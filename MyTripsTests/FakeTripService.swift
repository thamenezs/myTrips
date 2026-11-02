//
//  FakeTripService.swift
//  MyTrips
//
//  Created by Thais Menezes on 02/11/2026.
//

@testable import MyTrips

struct FakeTripService: TripFetching {
    var result: Result<[Trip], Error>
    
    func fetchTrips() async throws -> [MyTrips.Trip] {
        try result.get()
    }
    
    
}
