//
//  MyTripsApp.swift
//  MyTrips
//
//  Created by Thais Menezes on 31/10/2026.
//

import SwiftUI

@main
struct MyTripsApp: App {
    @State var viewModel = MyTripsViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
