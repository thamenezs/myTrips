//
//  TripsModel.swift
//  MyTrips
//
//  Created by Thais Menezes on 31/10/2026.
//

import Foundation


struct Trip: Identifiable, Hashable {
    let id: Int
    let name: String
    let country: String
    let days: Int
    var isFavorited = false
}
