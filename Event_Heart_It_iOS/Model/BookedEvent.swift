//
//  BookedEvent.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 7/10/2023.
//

import Foundation

struct BookedEvent: Identifiable, Equatable {
    let id = UUID()  // Add a property that uniquely identifies the instance
    let eventID: String
    let eventName: String
    let eventEndDate: TimeInterval

    init(eventID: String, eventName: String, eventEndDate: TimeInterval) {
        self.eventID = eventID
        self.eventName = eventName
        self.eventEndDate = eventEndDate
    }

    static func == (lhs: BookedEvent, rhs: BookedEvent) -> Bool {
        return lhs.eventID == rhs.eventID
            && lhs.eventName == rhs.eventName
            && lhs.eventEndDate == rhs.eventEndDate
    }
}
