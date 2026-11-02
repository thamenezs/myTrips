//
//  TripFetching.swift
//  MyTrips
//
//  Created by Thais Menezes on 02/11/2026.
//

protocol TripFetching {
    func fetchTrips() async throws -> [Trip]
}


extension LegacyTripService: TripFetching {}
