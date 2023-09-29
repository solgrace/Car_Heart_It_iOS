//
//  CarRentalMapView.swift
//  Car_Heart_It_iOS
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





// RENDERING EVENTS AS ANNOTATIONS ON MAP
struct CarRentalMapView: View {
    @ObservedObject var locationManager = LocationManager()
    @State private var events: [EventData] = [] // Store the retrieved events
    @State private var cancellables: Set<AnyCancellable> = [] // For managing Combine subscriptions

    var body: some View {
        NavigationView {
            VStack {
                MapViewContainer(userLocation: $locationManager.userLocation, annotations: createAnnotationsFromEvents(events: events))
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

                if !events.isEmpty {
                    List(events) { event in
                        Text("Event Name: \(event.name)")
                        // Display other event details here
                    }
                } else {
                    Text("No events found near your location.")
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
        
    private func createAnnotationsFromEvents(events: [EventData]) -> some View {
        return ZStack {
            ForEach(events, id: \.id) { event in
                if let latitude = event.venue?.latitude,
                   let longitude = event.venue?.longitude {
                    MapViewAnnotation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: event.name)
                        .offset(x: 0, y: -15) // Adjust the offset as needed
                }
            }
        }
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
