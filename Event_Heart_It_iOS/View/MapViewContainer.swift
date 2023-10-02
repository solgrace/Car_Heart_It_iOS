//
//  MapViewContainer.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 26/9/2023.
//

//// CORRECT VERSION. THE VERSION THAT IS CAPABLE OF LOCATING REAL-TIME LOCATION IF RUN ON A REAL DEVICE. SADLY SIMULATORS DOES NOT HAVE THIS CAPABILITY
//import SwiftUI
//import MapboxMaps
//
//struct MapViewContainer: UIViewRepresentable {
//    let accessToken = "sk.eyJ1IjoiZ3JhY2Vzb2wiLCJhIjoiY2xteng2eWF0MW5zdjJqbnRrN3dlNXVkaiJ9.xYpQiPGGe01KVlnx9Qf0_w"
//    @Binding var userLocation: CLLocationCoordinate2D?
//
//    func makeUIView(context: Context) -> MapView {
//        let resourceOptions = ResourceOptions(accessToken: accessToken)
//        let mapInitOptions = MapInitOptions(resourceOptions: resourceOptions)
//        let mapView = MapView(frame: UIScreen.main.bounds, mapInitOptions: mapInitOptions)
//
//        // Enable user location tracking
//        mapView.location.options.puckType = .puck2D()
//
//        return mapView
//    }
//
//    func updateUIView(_ uiView: MapView, context: Context) {
//        // Update the map view's center coordinate when userLocation changes
//        if let userLocation = userLocation {
//            let cameraOptions = CameraOptions(center: userLocation, zoom: 15)
//            uiView.camera.ease(to: cameraOptions, duration: 1.0) { _ in
//                // Completion handler, if needed
//            }
//        }
//    }
//}





//// THE VERSION OF MANUALLY SETTING INITIAL LOCATION TO UTS.
//import SwiftUI
//import MapboxMaps
//
//struct MapViewContainer: UIViewRepresentable {
//    let accessToken = "sk.eyJ1IjoiZ3JhY2Vzb2wiLCJhIjoiY2xteng2eWF0MW5zdjJqbnRrN3dlNXVkaiJ9.xYpQiPGGe01KVlnx9Qf0_w"
//    let startingPoint: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -33.8833, longitude: 151.2000)
//
//    func makeUIView(context: Context) -> MapView {
//        let resourceOptions = ResourceOptions(accessToken: accessToken)
//        let mapInitOptions = MapInitOptions(resourceOptions: resourceOptions)
//        let mapView = MapView(frame: UIScreen.main.bounds, mapInitOptions: mapInitOptions)
//
//        // Enable user location tracking
//        mapView.location.options.puckType = .puck2D()
//
//        print("! Starting Point: \(startingPoint.latitude), \(startingPoint.longitude)") // Add this line to print the startingPoint
//
//        return mapView
//    }
//
//    func updateUIView(_ uiView: MapView, context: Context) {
//        // Update the map view's center coordinate to the starting point
//        let cameraOptions = CameraOptions(center: startingPoint, zoom: 15)
//        uiView.camera.ease(to: cameraOptions, duration: 1.0) { _ in
//            // Completion handler, if needed
//        }
//    }
//}





//// THE VERSION OF USING MAPBOX TP DETECT MY LOCATION
////BELOW CORRECT VERSION
//import SwiftUI
//import MapboxMaps
//
//struct MapViewContainer: UIViewRepresentable {
//    let accessToken = "sk.eyJ1IjoiZ3JhY2Vzb2wiLCJhIjoiY2xteng2eWF0MW5zdjJqbnRrN3dlNXVkaiJ9.xYpQiPGGe01KVlnx9Qf0_w"
//    @Binding var userLocation: CLLocationCoordinate2D?
//
//    func makeUIView(context: Context) -> MapView {
//        let resourceOptions = ResourceOptions(accessToken: accessToken)
//        let mapInitOptions = MapInitOptions(resourceOptions: resourceOptions)
//        let mapView = MapView(frame: UIScreen.main.bounds, mapInitOptions: mapInitOptions)
//
//        // Enable user location tracking
//        mapView.location.options.puckType = .puck2D()
//
//        return mapView
//    }
//
//    func updateUIView(_ uiView: MapView, context: Context) {
//        // Check if we have the user's location available
//        if let userLocation = userLocation {
//            // Use the user's location as the center coordinate for the map
//            let cameraOptions = CameraOptions(center: userLocation, zoom: 15)
//            uiView.camera.ease(to: cameraOptions, duration: 1.0) { _ in
//                // Completion handler, if needed
//            }
//        }
//    }
//}





//// THE VERSION OF USING MAPBOX TO DETECT MY LOCATION
//// RENDERING EVENTS AS ANNOTATIONS ON MAP (CONTINUE WORKING BELOW)
//import SwiftUI
//import MapboxMaps
//
//struct MapViewContainer: UIViewRepresentable {
//    let accessToken = "sk.eyJ1IjoiZ3JhY2Vzb2wiLCJhIjoiY2xteng2eWF0MW5zdjJqbnRrN3dlNXVkaiJ9.xYpQiPGGe01KVlnx9Qf0_w"
//    @Binding var userLocation: CLLocationCoordinate2D?
//
//    // Add a new property to store events
//    var events: [EventData]
//
//    func makeUIView(context: Context) -> MapView {
//        let resourceOptions = ResourceOptions(accessToken: accessToken)
//        let mapInitOptions = MapInitOptions(resourceOptions: resourceOptions)
//        let mapView = MapView(frame: UIScreen.main.bounds, mapInitOptions: mapInitOptions)
//
//        // Enable user location tracking
//        mapView.location.options.puckType = .puck2D()
//
//        return mapView
//    }
//
//    private func createSampleView(withText text: String) -> UIView {
//        let label = UILabel()
//        label.text = text
//        label.font = .systemFont(ofSize: 14)
//        label.numberOfLines = 0
//        label.textColor = .black
//        label.backgroundColor = .white
//        label.textAlignment = .center
//        return label
//    }
//
//    private func addViewAnnotation(at coordinate: CLLocationCoordinate2D) {
//        let options = ViewAnnotationOptions(
//            geometry: Point(coordinate),
//            width: 100,
//            height: 40,
//            allowOverlap: false,
//            anchor: .center
//        )
//        let sampleView = createSampleView(withText: "Hello world!")
//        try? mapView.viewAnnotations.add(sampleView, options: options)
//    }
//
//    func updateUIView(_ uiView: MapView, context: Context) {
//        // Check if we have the user's location available
//        if let userLocation = userLocation {
//            // Use the user's location as the center coordinate for the map
//            let cameraOptions = CameraOptions(center: userLocation, zoom: 15)
//            uiView.camera.ease(to: cameraOptions, duration: 1.0) { _ in
//                // Completion handler, if needed
//            }
//
//            // Use the passed events to add view annotations
//            for event in events {
//                // Check if venue data is available
//                if let venue = event.venue {
//                    // Check if venue has latitude and longitude
//                    if let latitude = venue.latitude, let longitude = venue.longitude {
//                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//                        addViewAnnotation(at: coordinate)
//                    } else {
//                        print("Venue data is missing latitude or longitude.")
//                    }
//                } else {
//                    print("Event is missing venue data.")
//                }
//            }
//        }
//    }
//
//}





//// THE VERSION OF USING MAPBOX TO DETECT MY LOCATION
//// RENDERING EVENTS AS ANNOTATIONS ON MAP (CONTINUE WORKING BELOW)
//import SwiftUI
//import MapboxMaps
//
//struct MapViewContainer: UIViewRepresentable {
//    let accessToken = "sk.eyJ1IjoiZ3JhY2Vzb2wiLCJhIjoiY2xteng2eWF0MW5zdjJqbnRrN3dlNXVkaiJ9.xYpQiPGGe01KVlnx9Qf0_w"
//    @Binding var userLocation: CLLocationCoordinate2D?
//
//    // Add a new property to store events
//    var events: [EventData]
//
//    // Use @StateObject for managing the MapViewContainer's state
//    @StateObject private var mapViewContainerState = MapViewContainerState()
//
//    func makeUIView(context: Context) -> MapView {
//        let resourceOptions = ResourceOptions(accessToken: accessToken)
//        let mapInitOptions = MapInitOptions(resourceOptions: resourceOptions)
//
//        // Use UIScreen.main.bounds to get the screen size
//        let mapView = MapView(frame: UIScreen.main.bounds, mapInitOptions: mapInitOptions)
//
//        // Enable user location tracking
//        mapView.location.options.puckType = .puck2D()
//
//        // Pass the mapView to the state object for further use
//        mapViewContainerState.mapView = mapView
//
//        return mapView
//    }
//
//    func updateUIView(_ uiView: MapView, context: Context) {
//        uiView.frame = UIScreen.main.bounds
//        mapViewContainerState.updateMapView(userLocation: userLocation, events: events)
//    }
//
//}
//
//
//
//// Use @StateObject for managing the state of MapViewContainer
//class MapViewContainerState: ObservableObject {
//    var mapView: MapView?
//
//    func updateMapView(userLocation: CLLocationCoordinate2D?, events: [EventData]) {
//        guard let mapView = mapView else {
//            print("MapView is nil.")
//            return
//        }
//
//        // Clear existing annotations
//        mapView.viewAnnotations.removeAll()
//
//        // Your logic to update the MapView with user location and events
//        if let userLocation = userLocation {
//            let cameraOptions = CameraOptions(center: userLocation, zoom: 15)
//            mapView.camera.ease(to: cameraOptions, duration: 1.0) { _ in
//                // Completion handler, if needed
//            }
//
//            // Use the passed events to add view annotations
//            for event in events {
//                if let venue = event.venue {
//                    if let latitude = venue.latitude, let longitude = venue.longitude {
//                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//                        print("!! Event Name !!: \(event.name), Latitude: \(latitude), Longitude: \(longitude)")
//                        addViewAnnotation(at: coordinate)
//                    } else {
//                        print("Event \(event.name) is missing venue data or latitude/longitude.")
//                    }
//                } else {
//                    print("Event \(event.name) is missing venue data.")
//                }
//            }
//        }
//    }
//
//    private func addViewAnnotation(at coordinate: CLLocationCoordinate2D) {
//        guard let mapView = mapView else {
//            print("MapView is nil.")
//            return
//        }
//
//        let options = ViewAnnotationOptions(
//            geometry: Point(coordinate),
//            width: 100,
//            height: 40,
//            allowOverlap: false,
//            anchor: .center
//        )
//        let sampleView = createSampleView(withText: "Hello world!")
//        try? mapView.viewAnnotations.add(sampleView, options: options)
//    }
//
//    private func createSampleView(withText text: String) -> UIView {
//        let label = UILabel()
//        label.text = text
//        label.font = .systemFont(ofSize: 14)
//        label.numberOfLines = 0
//        label.textColor = .black
//        label.backgroundColor = .white
//        label.textAlignment = .center
//        return label
//    }
//}





// THE VERSION OF USING MAPBOX TO DETECT MY LOCATION
// RENDERING EVENTS AS ANNOTATIONS ON MAP (CONTINUE WORKING BELOW)
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

    var body: some View {
        VStack {
            VStack {
                Text(event.name)
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.bottom, 5)

                Button("Attend") {
                    // Handle the "Attend" button tap
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding(25) // Increase size of the box
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 5)

            Image("RedPin")
                .resizable()
                .frame(width: 50, height: 50)
                .offset(x: 0, y: 0) // Adjust the offset to move the red-pin image outside the box
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
            width: 100, // Set to a non-zero value
            height: 100, // Set to a non-zero value
            anchor: .bottom
        )

        do {
            // Add the view annotation to the map
            try mapView.viewAnnotations.add(uiView, options: options)
        } catch {
            print("Error adding view annotation: \(error)")
        }
    }

//    private func createSampleView(withText text: String) -> UIView {
//        let label = UILabel()
//        label.text = text
//        label.font = .systemFont(ofSize: 14)
//        label.numberOfLines = 0
//        label.textColor = .black
//        label.backgroundColor = .white
//        label.textAlignment = .center
//        return label
//    }
}