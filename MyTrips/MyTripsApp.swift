//
//  MyTripsApp.swift
//  MyTrips
//
//  Created by Thais Menezes on 31/10/2026.
//

import SwiftUI
import RealmSwift
import Realm

@main
struct MyTripsApp: App {
    init() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 2, migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < 2 {
                migration.renameProperty(onType: TripObject.className(),
                                         from: "days",
                                         to: "durationInDays")
            }
        })
    }
    
    @State private var viewModel = MyTripsViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
