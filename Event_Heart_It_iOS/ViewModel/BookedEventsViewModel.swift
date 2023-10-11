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
    private var userID: String // Add this property to store the userID
//
//    // Updated initializer to accept CoreDataManager
//    init(coreDataManager: CoreDataManager) {
//        self.coreDataManager = coreDataManager
//
//        // Set the user ID when initializing the view model
//        if let userID = Auth.auth().currentUser?.uid {
//            self.databaseRef = Database.database().reference().child("Users").child(userID).child("BookedEvents")
//        } else {
//            print("User not signed in")
//            self.databaseRef = Database.database().reference()
//        }
//    }
    
    // Updated initializer to accept CoreDataManager
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager

        // Set the user ID when initializing the view model
        if let userID = Auth.auth().currentUser?.uid {
            self.userID = userID
            self.databaseRef = Database.database().reference().child("Users").child(userID).child("BookedEvents")
        } else {
            print("User not signed in")
            self.userID = ""
            self.databaseRef = Database.database().reference()
        }
    }
    

    
    
        
    // Using CoreData:
    func bookEvent(event: EventData, completion: @escaping (Bool, String?) -> Void) {
        // Implement logic to book the event and store it in Core Data
        
//        // Check if the event is already booked
//        if let eventIDString = event.event_id, let eventID = UUID(uuidString: eventIDString), coreDataManager.isEventBooked(eventID: eventID) {
//            // Event is already booked
//            let errorMessage = "Event is already booked."
//            print("Error: \(errorMessage)")
//            completion(false, errorMessage)
//            return
//        }
        
        // Check if the event is already booked
        if let eventIDString = event.event_id {
            print("Checking if event with ID \(eventIDString) is already booked...")
            
            if coreDataManager.isEventBooked(eventID: eventIDString, userID: userID) {
                // Event is already booked
                let errorMessage = "Event is already booked."
                print("Error: \(errorMessage)")
                completion(false, errorMessage)
                return
            } else {
                print("Event with ID \(eventIDString) is not booked. Proceeding to book...")
            }
        } 

        // Example using Core Data:
        print("Attempting to book event...")

        let isBookingSuccessful = coreDataManager.bookEventCoreData(event: event, userID: userID)

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
    
    
    
    // To check if event has already been booked before:
    func isEventBooked(event: EventData) -> Bool {
        let eventIDString = event.event_id ?? ""
        return coreDataManager.isEventBooked(eventID: eventIDString, userID: userID)
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
            "eventLink": event.link,
            "eventStartDate": event.start_time,
            "eventEndDate": event.end_time,
            "eventIsVirtual": event.is_virtual,
            "eventFullAddress": event.venue?.full_address,
            "eventCity": event.venue?.city,
            "eventState": event.venue?.state,
            "eventCountry": event.venue?.country
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
    
    
    
    
    
    // When a user logs into a new device, fetch their booked events from Firebase and store them in the local CoreData:
        
    func syncBookedEventsFromFirebase(completion: @escaping (Bool, String?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false, "User ID not available")
            return
        }

        // Reference to the Firebase database
        let databaseRef = Database.database().reference().child("Users").child(userID).child("BookedEvents")

        // Fetch booked events from Firebase
        databaseRef.observeSingleEvent(of: .value, with: { snapshot in
//            if let error = error {
//                completion(false, "Failed to fetch booked events from Firebase")
//                return
//            }

            guard let eventsData = snapshot.value as? [String: [String: Any]] else {
                print("Failed to fetch booked events from Firebase")
                completion(false, "Failed to fetch booked events from Firebase")
                return
            }
            
            // Convert Firebase data to BookedEventStruct
            let firebaseEvents = eventsData.compactMap { (key, value) -> BookedEventStruct? in
                guard
                    let eventID = value["eventID"] as? String,
                    let eventName = value["eventName"] as? String,
                    let eventLink = value["eventLink"] as? String,
                    let eventStartDate = value["eventStartDate"] as? TimeInterval,
                    let eventEndDate = value["eventEndDate"] as? TimeInterval,
                    let eventIsVirtual = value["eventIsVirtual"] as? Bool,
                    let eventFullAddress = value["eventFullAddress"] as? String,
                    let eventCity = value["eventCity"] as? String,
                    let eventState = value["eventState"] as? String,
                    let eventCountry = value["eventCountry"] as? String
                else {
                    return nil
                }

                return BookedEventStruct(eventID: eventID, eventName: eventName, eventLink: eventLink, eventStartDate: eventStartDate, eventEndDate: eventEndDate, eventIsVirtual: eventIsVirtual, eventFullAddress: eventFullAddress, eventCity: eventCity, eventState: eventState, eventCountry: eventCountry)
            }

            // Update the local array and CoreData
            self.bookedEvents = firebaseEvents
            self.coreDataManager.syncBookedEvents(bookedEvents: firebaseEvents) {
                // Handle completion logic if needed
                
                // Empty closure
            }

            completion(true, nil)
            
        }) { error in
            print("Error fetching data: \(error.localizedDescription)")
            completion(false, "Failed to fetch booked events from Firebase")
        }
    }
    
    
    
    
    
    // Clears bookedEvents data after user logs out:

    // Function to clear booked events data
//    func clearBookedEvents() {
//        // Check if the user is signed in
//        if let currentUser = Auth.auth().currentUser {
//            print("User is signed in. UserID: \(currentUser.uid)")
//
//            self.bookedEvents = []  // Clear the array
//            print("After clearing self.bookedEvents: \(self.bookedEvents)")
//
//            // Clear the data in CoreData
//            coreDataManager.clearBookedEventsFromCoreData {
//                // This closure will be executed after events are cleared
//                print("Events cleared from CoreData successfully")
//            }
//        } else {
//            print("User not signed in")
//        }
//    }
    
//    func clearBookedEvents() {
//        self.bookedEvents = []  // Clear the array
//        print("After clearing self.bookedEvents: \(self.bookedEvents)")
//
//        // Clear the data in CoreData
//        coreDataManager.clearBookedEventsFromCoreData {
//            // This closure will be executed after events are cleared
//            print("Events cleared from CoreData successfully")
//        }
//    }
    
//    func clearBookedEvents() {
//        self.bookedEvents = []  // Clear the array
//
//        print("After clearing self.bookedEvents: \(self.bookedEvents)")
//
//        // Clear the data in CoreData
//        coreDataManager.clearBookedEventsFromCoreData()
//
//        print("coreDataManager.clearBookedEventsFromCoreData() called!")
//    }

}
