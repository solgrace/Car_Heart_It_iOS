//
//  MapViewContainer.swift
//  Car_Heart_It_iOS
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





// THE VERSION OF USING MAPBOX TP DETECT MY LOCATION
import SwiftUI
import MapboxMaps

struct MapViewContainer: UIViewRepresentable {
    let accessToken = "sk.eyJ1IjoiZ3JhY2Vzb2wiLCJhIjoiY2xteng2eWF0MW5zdjJqbnRrN3dlNXVkaiJ9.xYpQiPGGe01KVlnx9Qf0_w"
    @Binding var userLocation: CLLocationCoordinate2D?

    func makeUIView(context: Context) -> MapView {
        let resourceOptions = ResourceOptions(accessToken: accessToken)
        let mapInitOptions = MapInitOptions(resourceOptions: resourceOptions)
        let mapView = MapView(frame: UIScreen.main.bounds, mapInitOptions: mapInitOptions)

        // Enable user location tracking
        mapView.location.options.puckType = .puck2D()

        return mapView
    }

    func updateUIView(_ uiView: MapView, context: Context) {
        // Check if we have the user's location available
        if let userLocation = userLocation {
            // Use the user's location as the center coordinate for the map
            let cameraOptions = CameraOptions(center: userLocation, zoom: 15)
            uiView.camera.ease(to: cameraOptions, duration: 1.0) { _ in
                // Completion handler, if needed
            }
        }
    }
}
