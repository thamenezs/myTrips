//
//  Day2Starter.swift
//  MyTrips
//
//  Created by Thais Menezes on 01/11/2026.
//

import Foundation

// Add this file to your MyTrips project (it uses your Trip struct).

// MARK: - Exercise 1: an "old" service that uses completion handlers
// Don't change LegacyTripService. Your job is the TODO at the end of this section.

enum LegacyTripError: Error {
    case network
}

final class LegacyTripService: Sendable {
    enum Mode: Sendable {
        case success   // returns 5 trips
        case empty     // returns no trips
        case failure   // returns an error
    }
    
    let mode: Mode
    
    init(mode: Mode = .success) {
        self.mode = mode
    }
    
    /// Old style 1: the result comes as a `Result`.
    func fetchTrips(completion: @escaping @Sendable (Result<[Trip], LegacyTripError>) -> Void) {
        let result = makeResult()
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {   // simulates a slow network
            completion(result)
        }
    }
    
    /// Old style 2 (very common in Objective-C code): two optionals, the trips OR an error.
    func fetchTripsOldStyle(completion: @escaping @Sendable ([Trip]?, Error?) -> Void) {
        let result = makeResult()
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            switch result {
            case .success(let trips):
                completion(trips, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    private func makeResult() -> Result<[Trip], LegacyTripError> {
        switch mode {
        case .success:
            return .success([
                Trip(id: 1, name: "Lisbon weekend", country: "Portugal", days: 3),
                Trip(id: 2, name: "Backpacking Vietnam", country: "Vietnam", days: 21),
                Trip(id: 3, name: "Road trip Scotland", country: "United Kingdom", days: 10),
                Trip(id: 4, name: "Summer in Croatia", country: "Croatia", days: 8),
                Trip(id: 5, name: "Christmas in Belo Horizonte", country: "Brazil", days: 14)
            ])
        case .empty:
            return .success([])
        case .failure:
            return .failure(.network)
        }
    }
}

// TODO (Exercise 1): write the async versions here.
extension LegacyTripService {
    // func fetchTrips() async throws -> [Trip] { ... }
    
    func fetchTrip() async throws -> [Trip] {
        try await withCheckedThrowingContinuation { continuation in
            fetchTrips { result in
                continuation.resume(with: result)
            }
        }
    }
    
    // Bonus:
    func fetchTripsFromOldStyle() async throws -> [Trip] {
        try await withCheckedThrowingContinuation { continuation in
            fetchTripsOldStyle { result, error in
                if let result {
                    continuation.resume(with: .success(result))
                } else if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(with: .failure(LegacyTripError.network))
                }
            }
        }
    }
}

// MARK: - Exercise 2: a data race on purpose

// @unchecked Sendable = "trust me" (Day 2, Part 2B).
// Here we LIE to the compiler on purpose, so it lets us create a data race.
// nonisolated = this code does NOT run on the main actor.
//FIX A
//nonisolated final class PhotoCounter: @unchecked Sendable {
//    let countQueue = DispatchQueue(label: "count")
//    var count = 0
//
//    func increment() {
//        countQueue.sync{
//            self.count += 1
//        }
//    }
//}

//FIX B:
final actor PhotoCounter {
    var count = 0
    
    func increment() {
        count += 1
    }
}

func runPhotoCounterTest() async {
    let counter = PhotoCounter()
    
    await withTaskGroup { group in
        for _ in 1...10000 {
            group.addTask {
                await counter.increment()
            }
        }
        await group.waitForAll()
    }
    
    print("Expected 10000, got \(await counter.count)")
}


//nonisolated func runPhotoCounterTest() {
//    let counter = PhotoCounter()
//
//    // Runs the closure 10,000 times, in parallel, on several threads at the same time.
//    DispatchQueue.concurrentPerform(iterations: 10_000) { _ in
//        counter.increment()
//    }
//
//    print("Expected 10000, got \(counter.count)")
//}
