//
//  MyTripsTests.swift
//  MyTripsTests
//
//  Created by Thais Menezes on 02/11/2026.
//

import XCTest
@testable import MyTrips

@MainActor
final class MyTripsViewModelTests: XCTestCase {

    func testShowsSavedTripsWhenOffline() async {
        // Arrange
        let savedTrips = [
            Trip(id: 1, name: "Brasil 21", country: "Brasil", days: 21),
            Trip(id: 2, name: "Italia 2", country: "Italy", days: 4)
        ]
        let viewModel = MyTripsViewModel(
            service: FakeTripService(result: .failure(LegacyTripError.network)),
            repository: FakeTripRepository(trips: savedTrips)
        )

        // Act
        await viewModel.loadTrips()

        // Assert
        XCTAssertEqual(viewModel.state, .loaded(savedTrips))
    }

    func testShowsErrorWhenOfflineAndNothingSaved() async {
        let viewModel = MyTripsViewModel(
            service: FakeTripService(result: .failure(LegacyTripError.network)),
            repository: FakeTripRepository()
        )

        await viewModel.loadTrips()

        XCTAssertEqual(viewModel.state, .failure)
    }

    func testShowsEmptyWhenServerReturnsNoTrips() async {
        let viewModel = MyTripsViewModel(
            service: FakeTripService(result: .success([])),
            repository: FakeTripRepository()
        )

        await viewModel.loadTrips()

        XCTAssertEqual(viewModel.state, .empty)
    }
    
    func testShowsServerTripsWhenOnline() async {
        
        let trips = [Trip(id: 1, name: "Brasil 21", country: "Brasil", days: 21),
                     Trip(id: 2, name: "Italia 2", country: "Italy", days: 4)]
        
        let viewModel = MyTripsViewModel(
            service: FakeTripService(result: .success(trips)),
            repository: InMemoryTripRepository(trips: [])
        )
        
        await viewModel.loadTrips()
        
        XCTAssertEqual(viewModel.state, .loaded(trips))
    }
}
