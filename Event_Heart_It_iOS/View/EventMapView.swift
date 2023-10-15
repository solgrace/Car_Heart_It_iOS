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

// RENDERING EVENTS AS ANNOTATIONS ON MAP (CONTINUE WORKING BELOW)
struct EventMapView: View {
   
    
    init() {
        // Customize the UITabBar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.0706, green: 0, blue: 0.4784, alpha: 1.0)

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

            
    @ObservedObject var locationManager = LocationManager()
    @State private var events: [EventData] = [] // Store the retrieved events
    @State private var cancellables: Set<AnyCancellable> = [] // For managing Combine subscriptions
    
    
    // Create an instance of LoginViewModel
    let loginViewModel = LoginViewModel()
    @State private var isLoggedOut = false

    
    var body: some View {
        NavigationView {
            TabView {
                VStack {
                    VStack {
                        HStack {
                            Text("Event Map")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer().frame(width: 120)
                            
                            Button(action: {
                                // Perform log out action here
                                loginViewModel.logout { success in
                                    if success {
                                        print("Log out successful.")
                                        isLoggedOut = true
                                        
//                                        // TO BE COMMENTED OUT. DELETING ALL COREDATA DATA FOR PURPOSES OF TESTING THE APP FRESH WITH NO PREVIOUS DATA.
//                                        CoreDataManager.shared.deleteAllData()
                                    } else {
                                        // Handle the case where logout failed
                                        print("Failed to log out.")
                                    }
                                }
                            }) {
                                Text("Log Out")
                            }
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .frame(width: 80, height: 30)
                            .background(Color.white.opacity(0.4))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                        }
                        
                        Spacer().frame(height: 15)
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
                    
                    
//                    Spacer().frame(height: 15)  // Add top padding to TabView
                    
                }
                .background(Color(red: 0.0706, green: 0, blue: 0.4784))
                .navigationTitle("")
                .navigationBarHidden(true)
                .tabItem {
                    Label("Events", systemImage: "map.fill")
                }
                .foregroundColor(.white)
                
                
                EventsBookedView()
                    .tabItem {
                        Label("Booked", systemImage: "book.fill")
                            .foregroundColor(.white)
                    }

                
                ReviewsView()
                    .tabItem {
                        Label("Reviews", systemImage: "star.fill")
                            .foregroundColor(.white)
                    }
    
            }
            .background(Color(red: 0.0706, green: 0, blue: 0.4784))
            .accentColor(.white)
            .onAppear {
                // Set the color for unselected tab items
                UITabBar.appearance().unselectedItemTintColor = UIColor(white: 1, alpha: 0.5)
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

struct Previews_EventMapView_Previews: PreviewProvider {
    static var previews: some View {
        EventMapView()
    }
}
