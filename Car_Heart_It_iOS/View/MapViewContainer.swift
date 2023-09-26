//
//  MapViewContainer.swift
//  Car_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 26/9/2023.
//

import MapboxMaps
import SwiftUI

// Create a UIViewRepresentable struct
struct MapViewContainer: UIViewRepresentable {
    // Mapbox access token
    let accessToken = "sk.eyJ1IjoiZ3JhY2Vzb2wiLCJhIjoiY2xteng2eWF0MW5zdjJqbnRrN3dlNXVkaiJ9.xYpQiPGGe01KVlnx9Qf0_w"

    func makeUIView(context: Context) -> MapView {
        // Create resource options with your access token
        let resourceOptions = ResourceOptions(accessToken: accessToken)

        // Create map init options with the resource options
        let mapInitOptions = MapInitOptions(resourceOptions: resourceOptions)

        // Specify the frame for the mapView
        let mapView = MapView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), mapInitOptions: mapInitOptions)

        return mapView
    }

    func updateUIView(_ uiView: MapView, context: Context) {
        // Update the UIView if needed
    }
}
