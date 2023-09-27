//
//  CarRentalMapView.swift
//  Car_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 26/9/2023.
//

import SwiftUI
import MapboxMaps
import CoreLocation

// CORRECT VERSION. THE VERSION THAT IS CAPABLE OF LOCATING REAL-TIME LOCATION IF RUN ON A REAL DEVICE. SADLY SIMULATORS DOES NOT HAVE THIS CAPABILITY
struct CarRentalMapView: View {
    @StateObject var locationManager = LocationManager()

    var body: some View {
        NavigationView {
            VStack {
                MapViewContainer(userLocation: $locationManager.userLocation)
                    .onAppear {
                        // Check the authorization status before requesting location updates
                        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
                            locationManager.startUpdatingLocation()
                        } else {
                            // Handle other cases as needed
                        }
                    }
                    .onReceive(locationManager.$userLocation) { newUserLocation in
                        // Handle user location updates here, e.g., update the map
                        // newUserLocation contains the updated user location
                    }

                if let userLocation = locationManager.userLocation {
                    Text("Latitude: \(userLocation.latitude), Longitude: \(userLocation.longitude)")
                } else {
                    Text("Waiting for location...")
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}
