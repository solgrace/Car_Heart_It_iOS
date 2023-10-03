//
//  BookedEventsViewModel.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 3/10/2023.
//

import Foundation
import CoreData

class BookedEventsViewModel {
    func bookEvent(event: EventData, completion: @escaping (Bool, String?) -> Void) {
        // Implement logic to book the event and store it in Core Data

        let coreDataManager = CoreDataManager.shared

        // Example using Core Data:
        print("Attempting to book event...")

        let isBookingSuccessful = coreDataManager.bookEventCoreData(event: event)

        if isBookingSuccessful {
            // Successful booking
            print("Event booked successfully!")
            completion(true, nil)
        } else {
            // Failed booking
            let errorMessage = "Failed to book the event"
            print("Error: \(errorMessage)")
            completion(false, errorMessage)
        }
    }
}
