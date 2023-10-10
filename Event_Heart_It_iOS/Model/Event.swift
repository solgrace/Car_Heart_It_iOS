//
//  Event.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 29/9/2023.
//

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
    var id: UUID
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

    // Add CodingKeys enum to customize the decoding keys
    private enum CodingKeys: String, CodingKey {
        case id
        case event_id = "event_id"
        case name
        case link
        case description
        case start_time
        case end_time
        case is_virtual
        case thumbnail
        case info_links
        case venue
        case tags
        case language
    }

    // If you want to provide a default value for id
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = UUID()  // Generate random id

        // Decode other properties
        event_id = try container.decodeIfPresent(String.self, forKey: .event_id)
        name = try container.decode(String.self, forKey: .name)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        start_time = try container.decodeIfPresent(String.self, forKey: .start_time)
        end_time = try container.decodeIfPresent(String.self, forKey: .end_time)
        is_virtual = try container.decodeIfPresent(Bool.self, forKey: .is_virtual)
        thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
        info_links = try container.decodeIfPresent([InfoLinkData].self, forKey: .info_links)
        venue = try container.decodeIfPresent(VenueData.self, forKey: .venue)
        tags = try container.decodeIfPresent([String].self, forKey: .tags)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        
        // Use some fixed data or logic to generate a consistent UUID. This UUID will remain the same everytime the app re-runs.
        // IS THE BELOW EVEN NEEDED?
        let fixedDataForUUID = "\(name)\(event_id ?? "")" 
        id = UUID(uuidString: fixedDataForUUID) ?? UUID()
    }
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
