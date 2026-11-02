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
        case failure
    }
    
    private(set) var state: State = .loading
    private let service: LegacyTripService
    private let repository: RealmTripRepository
    
    init(
        service: LegacyTripService = LegacyTripService(),
        repository: RealmTripRepository = RealmTripRepository()
    ){
        self.service = service
        self.repository = repository
    }
    
    func loadTrips(isRefresh: Bool = false) async {
        let savedTrips = (try? repository.allTrips()) ?? []
        if !savedTrips.isEmpty {
            state = .loaded(savedTrips)
        } else if !isRefresh {
            state = .loading
        }
        //        do {
        //            let trips = try await service.fetchTrip()
        //            state = trips.isEmpty ? .empty : .loaded(trips)
        //        } catch let error as TripServiceError {
        //            state = .failure(error)
        //        } catch is CancellationError {
        //
        //        }
        //        catch {
        //
        //        }
        
        do {
            let serviceTrips = try await service.fetchTrip()
            try await repository.save(serviceTrips)
            let trips = try repository.allTrips()
            state = trips.isEmpty ? .empty : .loaded(trips)
            
        } catch is CancellationError {
            
        } catch {
            if savedTrips.isEmpty {
                state = .failure
            }
            
        }
        
    }
    
    
}
