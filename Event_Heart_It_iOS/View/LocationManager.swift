//
//  LocationManager.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 27/9/2023.
//

//import Foundation
//import CoreLocation
//import Combine
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private var locationManager = CLLocationManager()
//    @Published var userLocation: CLLocationCoordinate2D?
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        print("Location Manager initialized")
//    }
//
//    func requestLocationAuthorization() {
//        let status = CLLocationManager.authorizationStatus()
//        if status == .authorizedWhenInUse || status == .authorizedAlways {
//            startUpdatingLocation()
//            print("Location authorization already granted, starting location updates")
//        } else {
//            locationManager.requestWhenInUseAuthorization()
//            print("Requesting location authorization")
//        }
//    }
//
//    func startUpdatingLocation() {
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.startUpdatingLocation()
//            print("Started updating location")
//        } else {
//            print("Location services not enabled")
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            userLocation = location.coordinate
//            print("Location updated: Latitude \(location.coordinate.latitude), Longitude \(location.coordinate.longitude)")
//        }
//    }
//}









//// CORRECT VERSION:
//import Foundation
//import CoreLocation
//import Combine
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private var locationManager = CLLocationManager()
//    @Published var userLocation: CLLocationCoordinate2D?
//
//    // Add a Combine property to monitor authorization changes
//    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
//
////    override init() {
////        super.init()
////        locationManager.delegate = self
////        locationManager.desiredAccuracy = kCLLocationAccuracyBest
////        print("Location Manager initialized")
////        requestLocationAuthorization() // Automatically request authorization when the manager is initialized
////    }
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        print("Location Manager initialized")
//        requestLocationAuthorization()
//    }
//
//    func requestLocationAuthorization() {
//        let status = CLLocationManager.authorizationStatus()
//        switch status {
//        case .authorizedWhenInUse, .authorizedAlways:
//            startUpdatingLocation()
//            print("Location authorization already granted, starting location updates")
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//            print("Requesting location authorization")
//        case .restricted, .denied:
//            print("Location access is denied by the user.")
//            // Handle the case where access is denied by showing a message to the user.
//        @unknown default:
//            print("An unknown location authorization status: \(status.rawValue)")
//        }
//    }
//
//    func startUpdatingLocation() {
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.startUpdatingLocation()
//            print("Started updating location")
//        } else {
//            print("Location services not enabled")
//            // Handle the case where location services are not enabled by showing a message to the user.
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            userLocation = location.coordinate
//            print("Location updated: Latitude \(location.coordinate.latitude), Longitude \(location.coordinate.longitude)")
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        // Handle location error
//        if let error = error as? CLError {
//            switch error.code {
//            case .locationUnknown:
//                print("Location is currently unknown.")
//            case .denied:
//                print("Location access is denied by the user.")
//            case .network:
//                print("A network error occurred. Check your internet connection.")
//            case .headingFailure:
//                print("Compass data could not be retrieved.")
//            default:
//                print("An unknown location error occurred: \(error.localizedDescription)")
//            }
//        } else {
//            print("An unknown error occurred: \(error.localizedDescription)")
//        }
//    }
//
//    // Add the locationManagerDidChangeAuthorization delegate method
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        authorizationStatus = manager.authorizationStatus
//        // You can also perform actions based on the new authorization status here
//        switch authorizationStatus {
//        case .authorizedWhenInUse, .authorizedAlways:
//            // Authorization granted, start location updates or perform other actions
//            startUpdatingLocation()
//            print("Location authorization granted")
//        case .notDetermined:
//            // Authorization not determined, you may choose to request it here
//            print("Location authorization not determined")
//        case .restricted, .denied:
//            // Authorization denied or restricted, handle accordingly
//            print("Location access is denied by the user.")
//        default:
//            print("An unknown location authorization status: \(authorizationStatus.rawValue)")
//        }
//    }
//}










import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    
    // Add a Combine property to monitor authorization changes
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        print("Location Manager initialized")
        requestLocationAuthorization()
    }

    func requestLocationAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Authorization has been granted
            authorizationStatus = status
            print("Location authorization already granted")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            print("Requesting location authorization")
        case .restricted, .denied:
            print("Location access is denied by the user.")
            // Handle the case where access is denied by showing a message to the user.
        @unknown default:
            print("An unknown location authorization status: \(status.rawValue)")
        }
    }
    
    // Add the locationManagerDidChangeAuthorization delegate method
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        // You can also perform actions based on the new authorization status here
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            // Authorization granted, start location updates or perform other actions
            startUpdatingLocation()
            print("Location authorization granted")
        case .notDetermined:
            // Authorization not determined, you may choose to request it here
            print("Location authorization not determined")
        case .restricted, .denied:
            // Authorization denied or restricted, handle accordingly
            print("Location access is denied by the user.")
        default:
            print("An unknown location authorization status: \(authorizationStatus.rawValue)")
        }
    }

    func startUpdatingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            print("Started updating location")
        } else {
            print("Location services not enabled")
            // Handle the case where location services are not enabled by showing a message to the user.
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location.coordinate
            print("Location updated: Latitude \(location.coordinate.latitude), Longitude \(location.coordinate.longitude)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle location error
        if let error = error as? CLError {
            switch error.code {
            case .locationUnknown:
                print("Location is currently unknown.")
            case .denied:
                print("Location access is denied by the user.")
            case .network:
                print("A network error occurred. Check your internet connection.")
            case .headingFailure:
                print("Compass data could not be retrieved.")
            default:
                print("An unknown location error occurred: \(error.localizedDescription)")
            }
        } else {
            print("An unknown error occurred: \(error.localizedDescription)")
        }
    }
}
