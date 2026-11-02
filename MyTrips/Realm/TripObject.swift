//
//  TripObject.swift
//  MyTrips
//
//  Created by Thais Menezes on 02/11/2026.
//

import RealmSwift
import Foundation

nonisolated class TripObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var country: String
    @Persisted var durationInDays: Int
    @Persisted var isFavorited: Bool
}

extension Trip {
    init(_ object: TripObject) {
        self.init(id: object.id, name: object.name, country: object.country, days: object.durationInDays)
    }
}

nonisolated extension TripObject {
    convenience init(_ trip: Trip) {
        self.init()
        id = trip.id
        name = trip.name
        country = trip.country
        durationInDays = trip.days
    }
}
