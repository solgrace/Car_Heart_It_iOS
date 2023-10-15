//
//  CoreDataManager.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 23/9/2023.
//

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
    func isEventBooked(eventID: String, userID: String) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<BookedEvent> = BookedEvent.fetchRequest()
        
        // Add a predicate to check if an event with the given eventID is booked for the specific user
        fetchRequest.predicate = NSPredicate(format: "eventID == %@ AND userID == %@", eventID, userID)

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
    func bookEventCoreData(event: EventData, userID: String) -> Bool {
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
        bookedEvent.userID = userID // Set the userID

        
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
            bookedEvent.eventEndDate = "\(firebaseEvent.eventEndDate)"
            bookedEvent.eventIsVirtual = firebaseEvent.eventIsVirtual
            bookedEvent.eventFullAddress = firebaseEvent.eventFullAddress
            bookedEvent.eventCity = firebaseEvent.eventCity
            bookedEvent.eventState = firebaseEvent.eventState
            bookedEvent.eventCountry = firebaseEvent.eventCountry

            // Save the context after making changes
            saveContext()
        }

        // Call the completion handler once all events are saved
        completion()
    }

}
