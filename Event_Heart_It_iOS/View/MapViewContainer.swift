//
//  MapViewContainer.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 26/9/2023.
//

// THE VERSION OF USING MAPBOX TO DETECT MY LOCATION
// RENDERING EVENTS AS ANNOTATIONS ON MAP
import SwiftUI
import MapboxMaps

struct MapViewContainer: UIViewRepresentable {
    let accessToken = "sk.eyJ1IjoiZ3JhY2Vzb2wiLCJhIjoiY2xteng2eWF0MW5zdjJqbnRrN3dlNXVkaiJ9.xYpQiPGGe01KVlnx9Qf0_w"
    @Binding var userLocation: CLLocationCoordinate2D?

    // Add a new property to store events
    var events: [EventData]

    // Use @StateObject for managing the MapViewContainer's state
    @StateObject private var mapViewContainerState = MapViewContainerState()

    func makeUIView(context: Context) -> MapView {
        let resourceOptions = ResourceOptions(accessToken: accessToken)
        let mapInitOptions = MapInitOptions(resourceOptions: resourceOptions)

        // Use UIScreen.main.bounds to get the screen size
        let mapView = MapView(frame: UIScreen.main.bounds, mapInitOptions: mapInitOptions)

        // Enable user location tracking
        mapView.location.options.puckType = .puck2D()

        // Pass the mapView to the state object for further use
        mapViewContainerState.mapView = mapView

        return mapView
    }

    func updateUIView(_ uiView: MapView, context: Context) {
        uiView.frame = UIScreen.main.bounds
        mapViewContainerState.updateMapView(userLocation: userLocation, events: events)
    }

}



struct EventAnnotationView: View {
    let event: EventData
    @State private var isPresentingEachEventView = false

    var body: some View {
        VStack {
            VStack {
                Text(event.name)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer().frame(height: 18)

                Button(action: {
                    print("Button tapped. Presenting EachEventView.")
                    isPresentingEachEventView = true
                }) {
                    Text("Attend")
                }
                .font(.body)
                .fontWeight(.bold)
                .frame(width: 82, height: 42)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .fullScreenCover(isPresented: $isPresentingEachEventView) {
                    EachEventView(event: event)
                        .onAppear {
                            print("EachEventView appeared.")
                        }
                        .onDisappear {
                            print("EachEventView disappeared.")
                        }
                }
            }
            .padding(5)
            .frame(width: 150, height: 150)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 5)

            Image("RedPin")
                .resizable()
                .frame(width: 65, height: 65)
                .offset(x: 0, y: 0)
        }
    }
}



// Use @StateObject for managing the state of MapViewContainer
class MapViewContainerState: ObservableObject {
    var mapView: MapView?

    func updateMapView(userLocation: CLLocationCoordinate2D?, events: [EventData]) {
        guard let mapView = mapView else {
            print("MapView is nil.")
            return
        }

        // Clear existing annotations
        mapView.viewAnnotations.removeAll()

        // Your logic to update the MapView with user location and events
        if let userLocation = userLocation {
            let cameraOptions = CameraOptions(center: userLocation, zoom: 15)
            mapView.camera.ease(to: cameraOptions, duration: 1.0) { _ in
                // Completion handler, if needed
            }

            // Use the passed events to add view annotations
            for event in events {
                if let venue = event.venue {
                    if let latitude = venue.latitude, let longitude = venue.longitude {
                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        print("!! Event Name !!: \(event.name), Latitude: \(latitude), Longitude: \(longitude)")
                        addViewAnnotation(at: coordinate, event: event)
                    } else {
                        print("Event \(event.name) is missing venue data or latitude/longitude.")
                    }
                } else {
                    print("Event \(event.name) is missing venue data.")
                }
            }
        }
    }
    
    private func addViewAnnotation(at coordinate: CLLocationCoordinate2D, event: EventData) {
        guard let mapView = mapView else {
            print("MapView is nil.")
            return
        }

        // Create a custom annotation view with event name and Attend button
        let annotationView = EventAnnotationView(event: event)

        // Wrap the SwiftUI view in a UIHostingController to get the underlying UIView
        let hostingController = UIHostingController(rootView: annotationView)
        hostingController.view.backgroundColor = .clear  // Set background color to clear if needed

        // Extract the UIView from the UIHostingController
        guard let uiView = hostingController.view else {
            print("Failed to get the UIView from UIHostingController.")
            return
        }

        // Options for the view annotation
        let options = ViewAnnotationOptions(
            geometry: Point(coordinate),
            width: 150, // Set to a non-zero value
            height: 150, // Set to a non-zero value
            anchor: .bottom
        )

        do {
            // Add the view annotation to the map
            try mapView.viewAnnotations.add(uiView, options: options)
        } catch {
            print("Error adding view annotation: \(error)")
        }
    }

}
