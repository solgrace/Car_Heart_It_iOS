//
//  EventMapView.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 26/9/2023.
//

import SwiftUI
import MapboxMaps
import CoreLocation
import Combine
import _MapKit_SwiftUI

//// CORRECT VERSION. THE VERSION THAT IS CAPABLE OF LOCATING REAL-TIME LOCATION IF RUN ON A REAL DEVICE. SADLY SIMULATORS DOES NOT HAVE THIS CAPABILITY
//struct CarRentalMapView: View {
//    @StateObject var locationManager = LocationManager()
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                MapViewContainer(userLocation: $locationManager.userLocation)
//                    .onAppear {
//                        // Check the authorization status before requesting location updates
//                        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
//                            locationManager.startUpdatingLocation()
//                        } else {
//                            // Handle other cases as needed
//                        }
//                    }
//                    .onReceive(locationManager.$userLocation) { newUserLocation in
//                        // Handle user location updates here, e.g., update the map
//                        // newUserLocation contains the updated user location
//                    }
//
//                if let userLocation = locationManager.userLocation {
//                    Text("Latitude: \(userLocation.latitude), Longitude: \(userLocation.longitude)")
//                } else {
//                    Text("Waiting for location...")
//                }
//            }
//            .padding()
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//}





//// THE VERSION OF MANUALLY SETTING INITIAL LOCATION TO UTS.
//struct CarRentalMapView: View {
//    @StateObject var locationManager = LocationManager()
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                MapViewContainer()
//                    .onAppear {
//                        // Check the authorization status before requesting location updates
//                        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
//                            locationManager.startUpdatingLocation()
//                        } else {
//                            // Handle other cases as needed
//                        }
//                    }
//                    .onReceive(locationManager.$userLocation) { newUserLocation in
//                        // Handle user location updates here, e.g., update the map
//                        // newUserLocation contains the updated user location
//                    }
//
//                if let userLocation = locationManager.userLocation {
//                    Text("Latitude: \(userLocation.latitude), Longitude: \(userLocation.longitude)")
//                } else {
//                    Text("Waiting for location...")
//                }
//            }
//            .padding()
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//}





//// THE VERSION OF USING MAPBOX TP DETECT MY LOCATION
//// CORRECT VERSION FROM BEFORE. UN-COMMENT THE BELOW ONE.
//struct CarRentalMapView: View {
//    // Remove @StateObject for locationManager
//    // @StateObject var locationManager = LocationManager()
//
//    @ObservedObject var locationManager = LocationManager() // Use @ObservedObject
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Pass the userLocation binding to MapViewContainer
//                MapViewContainer(userLocation: $locationManager.userLocation)
//                    .onAppear {
//                        // Check the authorization status before requesting location updates
//                        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
//                            locationManager.startUpdatingLocation()
//                        } else {
//                            // Handle other cases as needed
//                        }
//                    }
//                    .onReceive(locationManager.$userLocation) { newUserLocation in
//                        // Handle user location updates here, e.g., update the map
//                        // newUserLocation contains the updated user location
//                    }
//
//                if let userLocation = locationManager.userLocation {
//                    Text("Latitude: \(userLocation.latitude), Longitude: \(userLocation.longitude)")
//                } else {
//                    Text("Waiting for location...")
//                }
//            }
//            .padding()
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//}





//// RENDERING EVENTS AS LISTS
////BEFORE CORRECT VERSION
//struct CarRentalMapView: View {
//    @ObservedObject var locationManager = LocationManager()
//    @State private var events: [EventData] = [] // Store the retrieved events
//    @State private var cancellables: Set<AnyCancellable> = [] // For managing Combine subscriptions
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                MapViewContainer(userLocation: $locationManager.userLocation)
//                    .onAppear {
//                        // Check the authorization status before requesting location updates
//                        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
//                            locationManager.startUpdatingLocation()
//                        } else {
//                            // Handle other cases as needed
//                        }
//
//                        // Fetch events near the user's location
//                        fetchEventsNearUserLocation()
//                    }
//
//                if !events.isEmpty {
//                    List(events) { event in
//                        Text("Event Name: \(event.name)")
//                        // Display other event details here
//                    }
//                } else {
//                    Text("No events found near your location.")
//                }
//            }
//            .padding()
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//
//    private func fetchEventsNearUserLocation() {
//        guard let userLocation = locationManager.userLocation else {
//            print("User location not available.")
//            return
//        }
//
//        EventAPIClient().fetchEventsNearUserLocation(userLocation: userLocation)
//            .receive(on: DispatchQueue.main) // Ensure UI updates are on the main thread
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    break // Handle the completion if needed
//                case .failure(let error):
//                    print("Error: \(error)")
//                }
//            }, receiveValue: { apiResponses in
//                // Extract the events from the array of APIResponse objects
//                let eventsFromAPIResponses = apiResponses.flatMap { $0.data }
//
//                // Append the extracted events to the events array
//                events.append(contentsOf: eventsFromAPIResponses)
//            })
//            .store(in: &cancellables)
//    }
//
//}





// RENDERING EVENTS AS ANNOTATIONS ON MAP (CONTINUE WORKING BELOW)
struct EventMapView: View {
    @ObservedObject var locationManager = LocationManager()
    @State private var events: [EventData] = [] // Store the retrieved events
    @State private var cancellables: Set<AnyCancellable> = [] // For managing Combine subscriptions
    
    // Create an instance of LoginViewModel
    let loginViewModel = LoginViewModel()
    @State private var isLoggedOut = false
    
//    let coreDataManager = CoreDataManager.shared

    var body: some View {
        NavigationView {
            TabView {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            // Perform log out action here
                            loginViewModel.logout { success in
                                if success {
                                    print("Log out successful.")
                                    isLoggedOut = true
                                } else {
                                    // Handle the case where logout failed
                                    print("Failed to log out.")
                                }
                            }
                        }) {
                            Text("Log Out")
                        }
                    }
                    
                    MapViewContainer(userLocation: $locationManager.userLocation, events: events)
                        .onAppear {
                            // Check the authorization status before requesting location updates
                            if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
                                locationManager.startUpdatingLocation()
                            } else {
                                // Handle other cases as needed
                            }
                            
                            // Fetch events near the user's location
                            fetchEventsNearUserLocation()
                        }
                    
                }
                .padding()
                .navigationTitle("")
                .navigationBarHidden(true)
                .tabItem {
                    Label("Events", systemImage: "map.fill")
                }
                
                EventsBookedView()
                    .tabItem {
                        Label("Booked", systemImage: "book.fill")
                    }

                ReviewsView()
                    .tabItem {
                        Label("Reviews", systemImage: "star.fill")
                    }
                
//                NavigationLink(destination: ReviewsView()) {
//                    Label("Reviews", systemImage: "star.fill")
//                }
//                .tabItem {
//                    Label("Reviews", systemImage: "star.fill")
//                }
            }
        }
        // Navigate to ContentView when isLoggedOut is true
        .background(
            NavigationLink("", destination: ContentView(), isActive: $isLoggedOut)
                .hidden()
        )
        .navigationBarTitle("", displayMode: .inline) // Add this line to hide the title
        .navigationBarBackButtonHidden(true) // Add this line to hide the back button
    }

    private func fetchEventsNearUserLocation() {
        guard let userLocation = locationManager.userLocation else {
            print("User location not available.")
            return
        }

        EventAPIClient().fetchEventsNearUserLocation(userLocation: userLocation)
            .receive(on: DispatchQueue.main) // Ensure UI updates are on the main thread
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break // Handle the completion if needed
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { apiResponses in
                // Extract the events from the array of APIResponse objects
                let eventsFromAPIResponses = apiResponses.flatMap { $0.data }

                // Append the extracted events to the events array
                events.append(contentsOf: eventsFromAPIResponses)
            })
            .store(in: &cancellables)
    }

}
