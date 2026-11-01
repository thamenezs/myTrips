import Foundation

// MARK: - Exercise 1: Starter code
// Add this file to a new iOS app project (SwiftUI, iOS 17+).
// You write the view model and the views. Don't change this part.



enum TripServiceError: Error {
    case network
}

struct TripService {
    enum Mode {
        case success   // returns 5 trips
        case empty     // returns no trips
        case failure   // throws an error
    }

    /// Change this to test each state of your screen.
    var mode: Mode = .success

    func fetchTrips() async throws -> [Trip] {
        try await Task.sleep(for: .seconds(1.5))   // simulates a slow network

        switch mode {
        case .success:
            return [
                Trip(id: 1, name: "Lisbon weekend", country: "Portugal", days: 3),
                Trip(id: 2, name: "Backpacking Vietnam", country: "Vietnam", days: 21),
                Trip(id: 3, name: "Road trip Scotland", country: "United Kingdom", days: 10),
                Trip(id: 4, name: "Summer in Croatia", country: "Croatia", days: 8),
                Trip(id: 5, name: "Christmas in Belo Horizonte", country: "Brazil", days: 14)
            ]
        case .empty:
            return []
        case .failure:
            throw TripServiceError.network
        }
    }
}

// MARK: - Exercise 2: Starter code

final class TripDetailViewModel {
    var title = "Lisbon weekend"
    var onUpdate: (() -> Void)?

    init() { print("init TripDetailViewModel") }
    deinit { print("deinit TripDetailViewModel") }

    func setup() {
        // TODO: store a closure in onUpdate that creates a retain cycle.
        onUpdate = { [weak self] in
            guard let self  else {
                return
            }
            print(self.title)
        }
    }
}
