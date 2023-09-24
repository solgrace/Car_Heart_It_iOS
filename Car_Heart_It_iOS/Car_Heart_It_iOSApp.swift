//
//  Car_Heart_It_iOSApp.swift
//  Car_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 22/9/2023.
//

import SwiftUI

//// FOR DEBUGGING PURPOSES (TO BE DELETED) ↓
//import CoreData
//// FOR DEBUGGING PURPOSES (TO BE DELETED) ↑



@main
struct Car_Heart_It_iOSApp: App {
    let persistenceController = PersistenceController.shared
    
//    // FOR DEBUGGING PURPOSES (TO BE DELETED) ↓
//    init() {
//        // Call the function to fetch and print users when the app starts
//        fetchAndPrintUsers()
//    }
//    // FOR DEBUGGING PURPOSES (TO BE DELETED) ↑

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    
    
//    // FOR DEBUGGING PURPOSES (TO BE DELETED) ↓
//    private func fetchAndPrintUsers() {
//        let fetchRequest: NSFetchRequest<CoreDataUser> = CoreDataUser.fetchRequest()
//
//        do {
//            let users = try persistenceController.container.viewContext.fetch(fetchRequest)
//
//            if users.isEmpty {
//                print("No users found.")
//            } else {
//                for user in users {
//                    print("User: \(user)")
//                }
//            }
//        } catch let error as NSError {
//            print("Error fetching users: \(error), \(error.userInfo)")
//        }
//    }
//    // FOR DEBUGGING PURPOSES (TO BE DELETED) ↑
    
    
    
}
