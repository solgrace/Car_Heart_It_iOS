//
//  MapViewAnnotation.swift
//  Car_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 29/9/2023.
//

import SwiftUI
import MapboxMaps

struct MapViewAnnotation: View {
    var coordinate: CLLocationCoordinate2D
    var title: String

    var body: some View {
        ZStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(.red)
            Text(title)
                .foregroundColor(.white)
                .font(.caption)
        }
        .frame(width: 30, height: 30)
    }
}
