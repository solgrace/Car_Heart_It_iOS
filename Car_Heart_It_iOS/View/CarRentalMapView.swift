//
//  CarRentalMapView.swift
//  Car_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 26/9/2023.
//

//import SwiftUI
//
//struct CarRentalMapView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct CarRentalMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        CarRentalMapView()
//    }
//}










import SwiftUI

struct CarRentalMapView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Car Rental App")
                    .font(.largeTitle)
                    .padding()

                MapViewContainer()
                    .frame(height: 300) // Adjust the frame size as needed

                // Other UI components
            }
            .padding()
        }
    }
}

struct CarRentalMapView_Previews: PreviewProvider {
    static var previews: some View {
        CarRentalMapView()
    }
}
