//
//  BookedEventsViewModel.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 3/10/2023.
//

//import Foundation
//import CoreData
//import Firebase
//import FirebaseDatabase
//
//class BookedEventsViewModel: ObservableObject {
//
//    // Fetch past booked events ↓:
//    @Published var bookedEvents: [BookedEvent] = [] // Move it here
//
//    private var databaseRef: DatabaseReference
//
//    init() {
//        // Set the user ID when initializing the view model
//        if let userID = Auth.auth().currentUser?.uid {
//            self.databaseRef = Database.database().reference().child("Users").child(userID).child("BookedEvents")
//        } else {
//            print("User not signed in")
//            self.databaseRef = Database.database().reference()
//        }
//    }
//    // Fetch past booked events ↑:
//
//
//
//
//
////    // Using CoreData:
////    func bookEvent(event: EventData, completion: @escaping (Bool, String?) -> Void) {
////        // Implement logic to book the event and store it in Core Data
////
////        let coreDataManager = CoreDataManager.shared
////
////        // Example using Core Data:
////        print("Attempting to book event...")
////
////        let isBookingSuccessful = coreDataManager.bookEventCoreData(event: event)
////
////        if isBookingSuccessful {
////            // Successful booking
////            print("Event booked successfully!")
////            completion(true, nil)
////        } else {
////            // Failed booking
////            let errorMessage = "Failed to book the event"
////            print("Error: \(errorMessage)")
////            completion(false, errorMessage)
////        }
////    }
//
//
//
//
//
//    // Using Firebase Realtime Database:
//    func bookEvent(event: EventData, completion: @escaping (Bool, String?) -> Void) {
//        guard let userID = Auth.auth().currentUser?.uid else {
//            completion(false, "User ID not available")
//            return
//        }
//
//        // To solve the error of: Terminating app due to uncaught exception 'InvalidPathValidation'
//        guard let sanitizedEventID = event.event_id?.replacingOccurrences(of: ".", with: "_")
//                                                  .replacingOccurrences(of: "#", with: "_")
//                                                  .replacingOccurrences(of: "$", with: "_")
//                                                  .replacingOccurrences(of: "[", with: "_")
//                                                  .replacingOccurrences(of: "]", with: "_") else {
//            completion(false, "Invalid event ID")
//            return
//        }
//
//        let databaseRef = Database.database().reference().child("Users").child(userID).child("BookedEvents")
//
//        // Create a unique key for the booked event
//        let bookedEventKey = databaseRef.childByAutoId().key ?? ""
//
//        // Create a dictionary to store booked event details
//        let bookedEventDictionary: [String: Any] = [
//            "eventID": sanitizedEventID, // Assuming there's an ID for each event
//            "eventName": event.name,
//            "eventEndDate": event.end_time, // Add the event end date
//            // Add other details you want to store
//        ]
//
//        // Set booked event details in the Realtime Database under the user's unique ID
//        databaseRef.child(bookedEventKey).setValue(bookedEventDictionary) { (error, _) in
//            if let error = error {
//                print("Error saving booked event details: \(error.localizedDescription)")
//                completion(false, "Failed to book the event")
//            } else {
//                print("Event booked successfully!")
//                completion(true, nil)
//            }
//        }
//    }
//
//
//
//
//
//    // Fetch past booked events:
//
//    func getBookedEvents(completion: @escaping ([BookedEvent]) -> Void) {
//        databaseRef.observeSingleEvent(of: .value) { snapshot in
//            var bookedEvents: [BookedEvent] = []
//
//            for child in snapshot.children {
//                if let snapshot = child as? DataSnapshot,
//                   let eventDict = snapshot.value as? [String: Any],
//                   let eventID = eventDict["eventID"] as? String,
//                   let eventName = eventDict["eventName"] as? String,
//                   let eventEndDate = eventDict["eventEndDate"] as? String { // Adjust the type if necessary
//                    let bookedEvent = BookedEvent(eventID: eventID, eventName: eventName, eventEndDate: TimeInterval(eventEndDate) ?? 0)
//                    bookedEvents.append(bookedEvent)
//                }
//            }
//
//            print("Fetched \(bookedEvents.count) booked events")
//
//            // Update the @Published property
//            DispatchQueue.main.async {
//                self.bookedEvents = bookedEvents
//            }
//
//            completion(bookedEvents)
//        }
//    }
//
//}





import Foundation
import CoreData
import Firebase
import FirebaseDatabase

class BookedEventsViewModel: ObservableObject {
    
    // New property for CoreData management
    private var coreDataManager = CoreDataManager.shared

    @Published var bookedEvents: [BookedEventStruct] = [] // Move it here
    
    private var databaseRef: DatabaseReference

    // Updated initializer to accept CoreDataManager
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager

        // Set the user ID when initializing the view model
        if let userID = Auth.auth().currentUser?.uid {
            self.databaseRef = Database.database().reference().child("Users").child(userID).child("BookedEvents")
        } else {
            print("User not signed in")
            self.databaseRef = Database.database().reference()
        }
    }
    

    
    
        
    // Using CoreData:
    func bookEvent(event: EventData, completion: @escaping (Bool, String?) -> Void) {
        // Implement logic to book the event and store it in Core Data

        // Example using Core Data:
        print("Attempting to book event...")

        let isBookingSuccessful = coreDataManager.bookEventCoreData(event: event)

        if isBookingSuccessful {
            // Successful booking
            print("Event booked successfully!")
            
            // Also, update the Firebase Realtime Database
            updateFirebaseDatabase(event: event, completion: completion)
        } else {
            // Failed booking
            let errorMessage = "Failed to book the event"
            print("Error: \(errorMessage)")
            completion(false, errorMessage)
        }
    }

    // Function to update Firebase Realtime Database
    private func updateFirebaseDatabase(event: EventData, completion: @escaping (Bool, String?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false, "User ID not available")
            return
        }

        guard let sanitizedEventID = event.event_id?.replacingOccurrences(of: ".", with: "_")
                                                  .replacingOccurrences(of: "#", with: "_")
                                                  .replacingOccurrences(of: "$", with: "_")
                                                  .replacingOccurrences(of: "[", with: "_")
                                                  .replacingOccurrences(of: "]", with: "_") else {
            completion(false, "Invalid event ID")
            return
        }

        let databaseRef = Database.database().reference().child("Users").child(userID).child("BookedEvents")

        let bookedEventKey = databaseRef.childByAutoId().key ?? ""

        let bookedEventDictionary: [String: Any] = [
            "eventID": sanitizedEventID,
            "eventName": event.name,
            "eventEndDate": event.end_time,
            // Add other details you want to store
        ]

        // Set booked event details in the Realtime Database under the user's unique ID
        databaseRef.child(bookedEventKey).setValue(bookedEventDictionary) { (error, _) in
            if let error = error {
                print("Error saving booked event details: \(error.localizedDescription)")
                completion(false, "Failed to book the event")
            } else {
                print("Event booked successfully in Firebase!")
                completion(true, nil)
            }
        }
    }

    
    
    
    
    // Fetch past booked events from COREDATA:
    func getBookedEvents(completion: @escaping () -> Void) {
        self.bookedEvents = coreDataManager.fetchBookedEvents()
        completion()
    }
    
}
