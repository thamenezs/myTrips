//
//  ContentView.swift
//  MyTrips
//
//  Created by Thais Menezes on 31/10/2026.
//

import SwiftUI

struct ContentView: View {
    let viewModel: MyTripsViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .empty:
                    ContentUnavailableView("No trips yet", systemImage: "globe.desk")
                case .loading:
                    ProgressView {
                        Text("Loading...")
                    }
                case .loaded(let trips):
                    List {
                        ForEach(trips) { trip in
                            VStack(alignment: .leading) {
                                Text(trip.name)
                                    .font(.title2)
                                Text(trip.country)
                                    .font(.title3)
                                Text(trip.duration)
                                    .font(.footnote)
                            }
                            
                        }
                    }
                    .refreshable {
                        await viewModel.loadTrips(isRefresh: true)
                    }
                case .failure:
                    ContentUnavailableView {
                        Label("Could not load trips", systemImage: "wifi.exclamationmark")
                    } description: {
                        Text("Please check your internet connection")
                    } actions: {
                        Button("Try again"){
                            Task {
                                await viewModel.loadTrips()
                            }
                        }
                    }
                    
                }
            }
            .navigationTitle("My trips")
            .toolbar {
                Button("Test Memory") {
                    let viewModel = TripDetailViewModel()
                    viewModel.setup()
                }
                Button("Race test") {
                    Task {
                        await runPhotoCounterTest()
                    }
                }
                
            }
        }
        .task {
            await viewModel.loadTrips()
        }
    }
    
}

extension Trip {
    var duration: String {days == 1 ? "1 day" : "\(days) days"}
}

#Preview {
    ContentView(viewModel: MyTripsViewModel(service: LegacyTripService()))
}
