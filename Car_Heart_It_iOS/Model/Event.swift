//
//  Event.swift
//  Car_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 29/9/2023.
//

import Foundation

struct Event: Identifiable, Decodable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let description: String
    let start_time: String
    let end_time: String
    let is_virtual: Bool
    let thumbnail: String
    let info_links: [InfoLink] // Assuming info_links is an array
    let venue: Venue
    let tags: [String]
    let language: String
}

struct InfoLink: Decodable {
    let source: String
    let link: String
}

struct Venue: Decodable {
    let google_id: String
    let subtype: String
    let subtypes: [String]
    let full_address: String
    let latitude: Double
    let longitude: Double
    let street_number: String
    let street: String
    let city: String
    let state: String
    let country: String
    let google_mid: String
}
