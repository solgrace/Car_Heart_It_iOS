//
//  Event.swift
//  Car_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 29/9/2023.
//

//import Foundation
//
//struct APIResponse: Decodable, Identifiable {
//    let id: String = "" // Set id to an empty string by default. This was added to conform to Identifiable.
//
//    let status: String
//    let request_id: String
//    let parameters: APIParameters
//    let data: [EventData]
//}
//
//struct APIParameters: Decodable, Identifiable {
//    let id: String = "" // Set id to an empty string by default. This was added to conform to Identifiable.
//
//    let query: String
//    let start: Int
//}
//
//struct EventData: Decodable, Identifiable {
//    let id: String = "" // Set id to an empty string by default. This was added to conform to Identifiable.
//
//    let event_id: String
//    let name: String
//    let link: String
//    let description: String
//    let start_time: String
//    let end_time: String
//    let is_virtual: Bool
//    let thumbnail: String
//    let info_links: [InfoLinkData]
//    let venue: VenueData
//    let tags: [String]
//    let language: String
//}
//
//struct InfoLinkData: Decodable, Identifiable {
//    let id: String = "" // Set id to an empty string by default. This was added to conform to Identifiable.
//
//    let source: String
//    let link: String
//}
//
//struct VenueData: Decodable, Identifiable {
//    let id: String = "" // Set id to an empty string by default. This was added to conform to Identifiable.
//
//    let google_id: String
//    let subtype: String
//    let subtypes: [String]
//    let full_address: String
//    let latitude: Double
//    let longitude: Double
//    let street_number: String
//    let street: String
//    let city: String
//    let state: String
//    let country: String
//    let google_mid: String
//}





import Foundation

struct APIResponse: Decodable, Identifiable {
    let id: String = "" // Set id to an empty string by default. This was added to conform to Identifiable.
    
    let status: String
    let request_id: String
    let parameters: APIParameters
    let data: [EventData]
}

struct APIParameters: Decodable, Identifiable {
    let id: String = "" // Set id to an empty string by default. This was added to conform to Identifiable.
    
    let query: String
}

struct EventData: Decodable, Identifiable {
    let id: String = "" // Set id to an empty string by default. This was added to conform to Identifiable.
    
    let event_id: String?
    let name: String
    let link: String?
    let description: String?
    let start_time: String?
    let end_time: String?
    let is_virtual: Bool?
    let thumbnail: String?
    let info_links: [InfoLinkData]?
    let venue: VenueData?
    let tags: [String]?
    let language: String?
}

struct InfoLinkData: Decodable, Identifiable {
    let id: String = "" // Set id to an empty string by default. This was added to conform to Identifiable.
    
    let source: String?
    let link: String?
}

struct VenueData: Decodable, Identifiable {
    let id: String = "" // Set id to an empty string by default. This was added to conform to Identifiable.
    
    let google_id: String?
    let subtype: String?
    let subtypes: [String]?
    let full_address: String?
    let latitude: Double?
    let longitude: Double?
    let street_number: String?
    let street: String?
    let city: String?
    let state: String?
    let country: String?
    let google_mid: String?
}
