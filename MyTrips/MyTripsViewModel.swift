//
//  MyTripsViewModel.swift
//  MyTrips
//
//  Created by Thais Menezes on 31/10/2026.
//

import Observation

@MainActor
@Observable
final class MyTripsViewModel {
    
    enum State {
        case empty
        case loading
        case loaded([Trip])
        case failure(TripServiceError)
    }
    
    private(set) var state: State = .loading
    private let service: LegacyTripService
    
    init(service: LegacyTripService = LegacyTripService()){
        self.service = service
    }

    func loadTrips(isRefresh: Bool = false) async {
        if !isRefresh {
            state = .loading
        }
        do {
            let trips = try await service.fetchTrip()
            state = trips.isEmpty ? .empty : .loaded(trips)
        } catch let error as TripServiceError {
            state = .failure(error)
        } catch is CancellationError {
            
        }
        catch {
            
        }
                
    }
    
    
}
