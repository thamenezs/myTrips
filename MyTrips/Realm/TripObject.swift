//
//  TripObject.swift
//  MyTrips
//
//  Created by Thais Menezes on 02/11/2026.
//

import RealmSwift
import Foundation

class TripObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var country: String
    @Persisted var days: Int
}

extension Trip {
    init(_ object: TripObject) {
        self.init(id: object.id, name: object.name, country: object.country, days: object.days)
    }
}

extension TripObject {
    convenience init(_ trip: Trip) {
        self.init()
        id = trip.id
        name = trip.name
        country = trip.country
        days = trip.days
    }
}
