//
//  Persistence.swift
//  Car_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 22/9/2023.
//



//import CoreData
//
//struct PersistenceController {
//    static let shared = PersistenceController()
//
//    static var preview: PersistenceController = {
//        let result = PersistenceController(inMemory: true)
//        let viewContext = result.container.viewContext
//        for _ in 0..<10 {
////            let newItem = Item(context: viewContext)
////            newItem.timestamp = Date()
//            let newCoreDataUser = CoreDataUser(context: viewContext) // Use the correct entity name
//            newCoreDataUser.email = "" // set it to a placeholder value
//        }
//        do {
//            try viewContext.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//        return result
//    }()
//
//    let container: NSPersistentContainer
//
//    init(inMemory: Bool = false) {
//        container = NSPersistentContainer(name: "EventHeartIt_CoreData")
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//        }
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        container.viewContext.automaticallyMergesChangesFromParent = true
//    }
//}



import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newBookedEvent = BookedEvents(context: viewContext)
            newBookedEvent.name = "Sample Event" // set it to a placeholder value
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "EventHeartIt_CoreData")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // Additional functions for saving, deleting, and fetching data...

    func saveBookedEvent(name: String) {
        let context = container.viewContext
        let bookedEvent = BookedEvents(context: context)
        bookedEvent.name = name

        do {
            try context.save()
        } catch {
            print("Error saving booked event: \(error)")
        }
    }

    func fetchBookedEvents() -> [BookedEvents] {
        let context = container.viewContext
        do {
            let fetchRequest: NSFetchRequest<BookedEvents> = BookedEvents.fetchRequest()
            let bookedEvents = try context.fetch(fetchRequest)
            return bookedEvents
        } catch {
            print("Error fetching booked events: \(error)")
        }
        return []
    }
}
