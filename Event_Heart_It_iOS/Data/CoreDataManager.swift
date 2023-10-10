//
//  CoreDataManager.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 23/9/2023.
//

//import Foundation
//import CoreData
//
//class CoreDataManager {
//    static let shared = CoreDataManager()
//
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "EventHeartIt_CoreDataDB")
//        container.loadPersistentStores(completionHandler: { (_, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    // MARK: - User Authentication
//
//    func authenticateUser(email: String, password: String) -> Bool {
//        // Implement user authentication logic using Core Data
//        let fetchRequest = NSFetchRequest<CoreDataUser>(entityName: "CoreDataUser")
//        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
//
//        do {
//            let matchingUsers = try persistentContainer.viewContext.fetch(fetchRequest)
//            return !matchingUsers.isEmpty
//        } catch {
//            print("Error fetching user: \(error)")
//            return false
//        }
//    }
//
//    func registerUser(firstName: String, lastName: String, email: String, password: String) -> Bool {
//        // Implement user registration logic using Core Data
//        let fetchRequest = NSFetchRequest<CoreDataUser>(entityName: "CoreDataUser")
//        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
//
//        do {
//            let matchingUsers = try persistentContainer.viewContext.fetch(fetchRequest)
//            if !matchingUsers.isEmpty {
//                // User with this email already exists, registration failed
//                return false
//            } else {
//                // Create a new User object and set its properties
//                let newUser = CoreDataUser(context: persistentContainer.viewContext)
//                newUser.firstName = firstName
//                newUser.lastName = lastName
//                newUser.email = email
//                newUser.password = password
//
//                // Save the changes to CoreData
//                try persistentContainer.viewContext.save()
//
//                return true // Registration successful
//            }
//        } catch {
//            print("Error fetching user: \(error)")
//            return false
//        }
//    }
//
//    // Implement other CRUD methods for user data
//
//
//
//    // Check if a user with the provided email already exists
//    func userExists(email: String) -> Bool {
////        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
//        let fetchRequest = NSFetchRequest<CoreDataUser>(entityName: "CoreDataUser")
//        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
//
//        do {
//            let existingUsers = try persistentContainer.viewContext.fetch(fetchRequest)
//            return !existingUsers.isEmpty
//        } catch {
//            print("Error checking if user exists: \(error)")
//            return false
//        }
//    }
//
//
//
//    func fetchUser(email: String) -> CoreDataUser? {
////        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
//        let fetchRequest = NSFetchRequest<CoreDataUser>(entityName: "CoreDataUser")
//        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
//
//        do {
//            let existingUsers = try persistentContainer.viewContext.fetch(fetchRequest)
//            return existingUsers.first
//        } catch {
//            print("Error fetching user: \(error)")
//            return nil
//        }
//    }
//
//
//
//
//
//
//
//
//    // For Booking Events:
//
//    func bookEventCoreData(event: EventData) -> Bool {
//        let context = persistentContainer.viewContext
//
//        // Example assuming you have a "BookedEvents" entity in your Core Data model
////        let fetchRequest: NSFetchRequest<BookedEvents> = BookedEvents.fetchRequest()
//        let fetchRequest = NSFetchRequest<BookedEvents>(entityName: "BookedEvents")
//
//        // Add a predicate to check if the same event is already booked
//        fetchRequest.predicate = NSPredicate(format: "name == %@", event.name)
//
//        do {
//            // Attempt to fetch existing booked events based on the predicate
//            let existingBookedEvents = try context.fetch(fetchRequest)
//
//            if existingBookedEvents.isEmpty {
//                // Create a new BookedEvent object if none exists
//                let bookedEvent = BookedEvents(context: context)
//
//                // Set properties for the booked event
//                bookedEvent.name = event.name
//
//                // Add more lines to set other properties accordingly
//
//                // Save the changes to CoreData
//                try context.save()
//
//                // Print success message
//                print("Successfully saved booked event.")
//
//                // Additional print statements for debugging
//                print("Booked Event Details:")
//                print("- Name: \(bookedEvent.name ?? "Unknown Event")")
//                // Print other properties as needed
//
//                return true
//            } else {
//                // Handle the case where the same event is already booked
//                print("The same event is already booked.")
//                // Additional print statements for debugging
//                print("Existing Booked Event Details:")
//                for (index, existingEvent) in existingBookedEvents.enumerated() {
//                    print("\(index + 1). Name: \(existingEvent.name ?? "Unknown Event")")
//                    // Print other properties as needed
//                }
//
//                return false
//            }
//        } catch {
//            // Print error if fetch or save fails
//            print("Error: \(error.localizedDescription)")
//            return false
//        }
//    }
//
//}





import CoreData
import Firebase // For identifying current user's ID

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EventHeartIt_CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // Save the Core Data context
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Context saved successfully")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Check if the event is already booked
    func isEventBooked(eventID: String) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<BookedEvent> = BookedEvent.fetchRequest()

        // Add a predicate to check if an event with the given eventID is booked
        fetchRequest.predicate = NSPredicate(format: "eventID == %@", eventID)

        do {
            print("Attempting to check if event is booked...")
            
            let result = try context.fetch(fetchRequest)
            
            if !result.isEmpty {
                print("Event with ID \(eventID) is booked.")
                return true  // If result is not empty, the event is booked
            } else {
                print("Event with ID \(eventID) is not booked.")
                return false
            }
        } catch {
            print("Failed to check if event is booked: \(error.localizedDescription)")
            return false
        }
    }

    // Function to store booked event in CoreData
    func bookEventCoreData(event: EventData) -> Bool {
        let context = persistentContainer.viewContext

        guard let entity = NSEntityDescription.entity(forEntityName: "BookedEvent", in: context) else {
            print("Failed to get entity description")
            return false
        }

//        let bookedEvent = NSManagedObject(entity: entity, insertInto: context)
        let bookedEvent = NSManagedObject(entity: entity, insertInto: context) as! BookedEvent

        // Set properties of the BookedEvent entity
        bookedEvent.setValue(event.event_id, forKey: "eventID")
        bookedEvent.setValue(event.name, forKey: "eventName")
        bookedEvent.setValue(event.link, forKey:"eventLink")
        bookedEvent.setValue(event.start_time, forKey: "eventStartDate")
        bookedEvent.setValue(event.end_time, forKey: "eventEndDate")
        bookedEvent.setValue(event.is_virtual, forKey:"eventIsVirtual")
        bookedEvent.setValue(event.venue?.full_address, forKey:"eventFullAddress")
        bookedEvent.setValue(event.venue?.city, forKey:"eventCity")
        bookedEvent.setValue(event.venue?.state, forKey:"eventState")
        bookedEvent.setValue(event.venue?.country, forKey:"eventCountry")
        bookedEvent.userID = Auth.auth().currentUser?.uid // Set the userID
        // Add other properties as needed
        
        // Debug statements to see what was saved
        print("Event ID: \(event.event_id)")
        print("Event Name: \(event.name)")
        print("Event Link: \(event.link)")
        print("Event Start Time: \(event.start_time)")
        print("Event End Time: \(event.end_time)")
        print("Event is Virtual: \(event.is_virtual)")
        print("Event Full Address: \(event.venue?.full_address ?? "N/A")")
        print("Event City: \(event.venue?.city ?? "N/A")")
        print("Event State: \(event.venue?.state ?? "N/A")")
        print("Event Country: \(event.venue?.country ?? "N/A")")
        print("User ID: \(bookedEvent.userID ?? "N/A")")

        saveContext() // Save the context after making changes
        print("Event booked in CoreData successfully")

        return true
    }

    // Function to fetch past booked events from CoreData
    func fetchBookedEvents() -> [BookedEventStruct] {
        let context = persistentContainer.viewContext
        var currentUserID: String?
        let fetchRequest: NSFetchRequest<BookedEvent> = BookedEvent.fetchRequest()
        
        // Filter by userID
        if let userID = Auth.auth().currentUser?.uid {
            currentUserID = userID
            let predicate = NSPredicate(format: "userID == %@", currentUserID!)
            print("Predicate set with userID: \(currentUserID ?? "N/A")")
            
            // Set the predicate to the fetch request
            fetchRequest.predicate = predicate
        } else {
            print("Error: Could not retrieve userID.")
        }
        
        do {
            let result = try context.fetch(fetchRequest)
            
            // Debug statements to see what's fetched
            print("Fetching booked events for user ID: \(currentUserID ?? "N/A")")
            print("Fetched \(result.count) raw BookedEvent entities from CoreData")

            // Convert instances of BookedEvent to BookedEventStruct
            let events = result.map { bookedEvent -> BookedEventStruct in
                print("Processing BookedEvent entity:")
                print("Event ID: \(bookedEvent.eventID ?? "N/A")")
                print("Event Name: \(bookedEvent.eventName ?? "N/A")")
                
                return BookedEventStruct(
                    eventID: bookedEvent.eventID ?? "",
                    eventName: bookedEvent.eventName ?? "",
                    eventLink: bookedEvent.eventLink ?? "",
                    eventStartDate: TimeInterval(bookedEvent.eventStartDate ?? "") ?? 0,
                    eventEndDate: TimeInterval(bookedEvent.eventEndDate ?? "") ?? 0,
                    eventIsVirtual: bookedEvent.eventIsVirtual ?? false,
                    eventFullAddress: bookedEvent.eventFullAddress ?? "",
                    eventCity: bookedEvent.eventCity ?? "",
                    eventState: bookedEvent.eventState ?? "",
                    eventCountry: bookedEvent.eventCountry ?? ""
                )
            }

            print("Fetched \(events.count) booked events from CoreData")
            return events
        } catch {
            print("Failed to fetch booked events: \(error.localizedDescription)")
            return []
        }
    }
//    func fetchBookedEvents() -> [BookedEventStruct] {
//        let context = persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookedEvent")
//
//        do {
//            let result = try context.fetch(fetchRequest)
//
//            // Convert instances of BookedEvent to BookedEventStruct
//            let events = (result as? [BookedEvent] ?? []).map { bookedEvent in
//                BookedEventStruct(
//                    eventID: bookedEvent.eventID ?? "",
//                    eventName: bookedEvent.eventName ?? "",
//                    eventLink: bookedEvent.eventLink ?? "",
//                    eventStartDate: TimeInterval(bookedEvent.eventStartDate ?? "") ?? 0,
//                    eventEndDate: TimeInterval(bookedEvent.eventEndDate ?? "") ?? 0,
//                    eventIsVirtual: bookedEvent.eventIsVirtual ?? "",
//                    eventFullAddress: bookedEvent.eventFullAddress ?? "",
//                    eventCity: bookedEvent.eventCity ?? "",
//                    eventState: bookedEvent.eventState ?? "",
//                    eventCountry: bookedEvent.eventCountry ?? ""
//                )
//            }
//
//            print("Fetched \(events.count) booked events from CoreData")
//            return events
//        } catch {
//            print("Failed to fetch booked events: \(error.localizedDescription)")
//            return []
//        }
//    }
    
    
    
    
    
    // When a user logs into a new device, fetch their booked events from Firebase and store them in the local CoreData:
    
    // Function to sync booked events between Firebase and CoreData
    func syncBookedEvents(bookedEvents: [BookedEventStruct], completion: @escaping () -> Void) {
        let context = persistentContainer.viewContext

        // Loop through the booked events from Firebase and save them to CoreData
        for firebaseEvent in bookedEvents {
            let entity = NSEntityDescription.entity(forEntityName: "BookedEvent", in: context)

            // Create a new BookedEvent managed object
            let bookedEvent = NSManagedObject(entity: entity!, insertInto: context) as! BookedEvent

            // Set properties of the BookedEvent entity
            bookedEvent.eventID = firebaseEvent.eventID
            bookedEvent.eventName = firebaseEvent.eventName
            bookedEvent.eventLink = firebaseEvent.eventLink
            bookedEvent.eventStartDate = "\(firebaseEvent.eventStartDate)"
            bookedEvent.eventEndDate = "\(firebaseEvent.eventEndDate)" // Assuming eventEndDate is stored as String in CoreData
            bookedEvent.eventIsVirtual = firebaseEvent.eventIsVirtual
            bookedEvent.eventFullAddress = firebaseEvent.eventFullAddress
            bookedEvent.eventCity = firebaseEvent.eventCity
            bookedEvent.eventState = firebaseEvent.eventState
            bookedEvent.eventCountry = firebaseEvent.eventCountry
            // Add other properties as needed

            // Save the context after making changes
            saveContext()
        }

        // Call the completion handler once all events are saved
        completion()
    }
    
    
    
    
    
    // Clears bookedEvents data after user logs out:

    // Function to clear booked events data from CoreData
//    func clearBookedEventsFromCoreData(completion: @escaping () -> Void) {
//        let context = persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookedEvent")
//
//        do {
//            let result = try context.fetch(fetchRequest)
//
//            for case let bookedEvent as NSManagedObject in result {
//                context.delete(bookedEvent)
//            }
//
//            // Save the context after making changes
//            saveContext()
//            print("Booked events cleared from CoreData successfully")
//
//            // Call the completion handler once events are cleared
//            completion()
//        } catch {
//            print("Failed to clear booked events from CoreData: \(error.localizedDescription)")
//        }
//    }
    
//    func clearBookedEventsFromCoreData() {
//        let context = persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookedEvent")
//
//        do {
//            let result = try context.fetch(fetchRequest)
//
//            for case let bookedEvent as NSManagedObject in result {
//                context.delete(bookedEvent)
//            }
//
//            // Save the context after making changes
//            saveContext()
//            print("Booked events cleared from CoreData successfully")
//        } catch {
//            print("Failed to clear booked events from CoreData: \(error.localizedDescription)")
//        }
//    }

}
