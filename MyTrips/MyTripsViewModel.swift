import Observation
import Foundation

@MainActor
@Observable
final class MyTripsViewModel {
    
    enum State: Equatable {      // Equatable: tests can compare states with XCTAssertEqual
        case empty
        case loading
        case loaded([Trip])
        case failure
    }
    
    private(set) var state: State = .loading
    private let service: any TripFetching          // a protocol now
    private let repository: any TripRepository
    
    init(
        service: any TripFetching = LegacyTripService(),
        repository: any TripRepository = RealmTripRepository()
    ) {
        self.service = service
        self.repository = repository
    }
    
    private func sortTripList(_ trips: [Trip]) -> [Trip] {
        trips.sorted { current, next in
            if current.isFavorited != next.isFavorited {
                return current.isFavorited
            }
            return current.name.localizedStandardCompare(next.name) == .orderedAscending
        }
    }
    
    func loadTrips(isRefresh: Bool = false) async {
        // 1. Show the saved trips right away
        let savedTrips = (try? repository.allTrips()) ?? []
        let sortedTrips = sortTripList(savedTrips)
        if !savedTrips.isEmpty {
            state = .loaded(sortedTrips)
        } else if !isRefresh {
            state = .loading
        }
        
        // 2. Always try to get fresh data from the network
        do {
            let serverTrips = try await service.fetchTrips()
            try await repository.save(serverTrips)
            let trips = try repository.allTrips()
            state = trips.isEmpty ? .empty : .loaded(sortTripList(trips))
        } catch is CancellationError {
            // Cancelled: keep what's on the screen
        } catch {
            // 3. Network failed: show the error only if nothing is saved
            if savedTrips.isEmpty {
                state = .failure
            }
        }
    }
    
    func toggleFavorited(_ trip: Trip) {
        do {
            try repository.setFavorite(!trip.isFavorited, tripId: trip.id)
            let trips = try repository.allTrips()
            state = .loaded(sortTripList(trips))
        } catch {
            print("Could not save favorite:", error)
        }
    }
}
