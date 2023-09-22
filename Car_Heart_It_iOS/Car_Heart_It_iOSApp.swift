//
//  Car_Heart_It_iOSApp.swift
//  Car_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 22/9/2023.
//

import SwiftUI

@main
struct Car_Heart_It_iOSApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
