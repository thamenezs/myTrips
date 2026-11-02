import Observation

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

    func loadTrips(isRefresh: Bool = false) async {
        // 1. Show the saved trips right away
        let savedTrips = (try? repository.allTrips()) ?? []
        if !savedTrips.isEmpty {
            state = .loaded(savedTrips)
        } else if !isRefresh {
            state = .loading
        }

        // 2. Always try to get fresh data from the network
        do {
            let serverTrips = try await service.fetchTrips()
            try await repository.save(serverTrips)
            let trips = try repository.allTrips()
            state = trips.isEmpty ? .empty : .loaded(trips)
        } catch is CancellationError {
            // Cancelled: keep what's on the screen
        } catch {
            // 3. Network failed: show the error only if nothing is saved
            if savedTrips.isEmpty {
                state = .failure
            }
        }
    }
}
