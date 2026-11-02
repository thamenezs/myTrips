//
//  Test.swift
//  MyTrips
//
//  Created by Thais Menezes on 02/11/2026.
//

import XCTest

class Test: XCTestCase {

//    @Test func showSavedTripsWhenOffline() async throws {
//        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
//        if case .loaded(let trips) = viewModel.state {
//                #expect(trips.count == 2)
//            } else {
//                Issue.record("Expected the saved trips to be shown")
//            }
//    }
    
    private let viewModel: MyTripsViewModel
    
    init(viewModel: MyTripsViewModel = MyTripsViewModel(service: LegacyTripServiceMock, repository: RealmTripRepositoryMock)) {
        self.viewModel = viewModel
    }
    
    func showSavedTripsOffline() async throws {
        
    }

}
