//
//  BookedEvent.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 7/10/2023.
//

import Foundation

struct BookedEventStruct: Identifiable, Equatable {
    let id = UUID()  // Add a property that uniquely identifies the instance
    let eventID: String
    let eventName: String
    let eventLink: String
    let eventStartDate: TimeInterval
    let eventEndDate: TimeInterval
    let eventIsVirtual: Bool
    let eventFullAddress: String
    let eventCity: String
    let eventState: String
    let eventCountry: String

    init(eventID: String, eventName: String, eventLink: String, eventStartDate: TimeInterval, eventEndDate: TimeInterval, eventIsVirtual: Bool, eventFullAddress: String, eventCity: String, eventState: String, eventCountry: String) {
        self.eventID = eventID
        self.eventName = eventName
        self.eventLink = eventLink
        self.eventStartDate = eventStartDate
        self.eventEndDate = eventEndDate
        self.eventIsVirtual = eventIsVirtual
        self.eventFullAddress = eventFullAddress
        self.eventCity = eventCity
        self.eventState = eventState
        self.eventCountry = eventCountry
    }

    static func == (lhs: BookedEventStruct, rhs: BookedEventStruct) -> Bool {
        return lhs.eventID == rhs.eventID
            && lhs.eventName == rhs.eventName
            && lhs.eventLink == rhs.eventLink
            && lhs.eventStartDate == rhs.eventStartDate
            && lhs.eventEndDate == rhs.eventEndDate
            && lhs.eventIsVirtual == rhs.eventIsVirtual
            && lhs.eventFullAddress == rhs.eventFullAddress
            && lhs.eventCity == rhs.eventCity
            && lhs.eventState == rhs.eventState
            && lhs.eventCountry == rhs.eventCountry
    }
}
