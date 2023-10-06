//
//  CoreDataManager.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 23/9/2023.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EventHeartIt_CoreDataDB")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - User Authentication

    func authenticateUser(email: String, password: String) -> Bool {
        // Implement user authentication logic using Core Data
        let fetchRequest = NSFetchRequest<CoreDataUser>(entityName: "CoreDataUser")
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)

        do {
            let matchingUsers = try persistentContainer.viewContext.fetch(fetchRequest)
            return !matchingUsers.isEmpty
        } catch {
            print("Error fetching user: \(error)")
            return false
        }
    }

    func registerUser(firstName: String, lastName: String, email: String, password: String) -> Bool {
        // Implement user registration logic using Core Data
        let fetchRequest = NSFetchRequest<CoreDataUser>(entityName: "CoreDataUser")
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            let matchingUsers = try persistentContainer.viewContext.fetch(fetchRequest)
            if !matchingUsers.isEmpty {
                // User with this email already exists, registration failed
                return false
            } else {
                // Create a new User object and set its properties
                let newUser = CoreDataUser(context: persistentContainer.viewContext)
                newUser.firstName = firstName
                newUser.lastName = lastName
                newUser.email = email
                newUser.password = password

                // Save the changes to CoreData
                try persistentContainer.viewContext.save()

                return true // Registration successful
            }
        } catch {
            print("Error fetching user: \(error)")
            return false
        }
    }

    // Implement other CRUD methods for user data



    // Check if a user with the provided email already exists
    func userExists(email: String) -> Bool {
//        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let fetchRequest = NSFetchRequest<CoreDataUser>(entityName: "CoreDataUser")
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            let existingUsers = try persistentContainer.viewContext.fetch(fetchRequest)
            return !existingUsers.isEmpty
        } catch {
            print("Error checking if user exists: \(error)")
            return false
        }
    }



    func fetchUser(email: String) -> CoreDataUser? {
//        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let fetchRequest = NSFetchRequest<CoreDataUser>(entityName: "CoreDataUser")
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            let existingUsers = try persistentContainer.viewContext.fetch(fetchRequest)
            return existingUsers.first
        } catch {
            print("Error fetching user: \(error)")
            return nil
        }
    }








    // For Booking Events:

    func bookEventCoreData(event: EventData) -> Bool {
        let context = persistentContainer.viewContext

        // Example assuming you have a "BookedEvents" entity in your Core Data model
//        let fetchRequest: NSFetchRequest<BookedEvents> = BookedEvents.fetchRequest()
        let fetchRequest = NSFetchRequest<BookedEvents>(entityName: "BookedEvents")

        // Add a predicate to check if the same event is already booked
        fetchRequest.predicate = NSPredicate(format: "name == %@", event.name)

        do {
            // Attempt to fetch existing booked events based on the predicate
            let existingBookedEvents = try context.fetch(fetchRequest)

            if existingBookedEvents.isEmpty {
                // Create a new BookedEvent object if none exists
                let bookedEvent = BookedEvents(context: context)

                // Set properties for the booked event
                bookedEvent.name = event.name

                // Add more lines to set other properties accordingly

                // Save the changes to CoreData
                try context.save()

                // Print success message
                print("Successfully saved booked event.")

                // Additional print statements for debugging
                print("Booked Event Details:")
                print("- Name: \(bookedEvent.name ?? "Unknown Event")")
                // Print other properties as needed

                return true
            } else {
                // Handle the case where the same event is already booked
                print("The same event is already booked.")
                // Additional print statements for debugging
                print("Existing Booked Event Details:")
                for (index, existingEvent) in existingBookedEvents.enumerated() {
                    print("\(index + 1). Name: \(existingEvent.name ?? "Unknown Event")")
                    // Print other properties as needed
                }

                return false
            }
        } catch {
            // Print error if fetch or save fails
            print("Error: \(error.localizedDescription)")
            return false
        }
    }

}
