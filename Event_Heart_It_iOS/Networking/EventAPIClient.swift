//
//  EventAPIClient.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 29/9/2023.
//

//import Foundation
//import Combine
//import CoreLocation // Import CoreLocation for CLLocationCoordinate2D
//
////struct EventAPIClient {
//class EventAPIClient: ObservableObject {
//    let apiKey = "57648fae17msh82df1c2df365440p1f4e05jsn4cc715197ee2" // Replace with your actual API key
//    let baseURL = "https://real-time-events-search.p.rapidapi.com"
//
//    @Published var events: [APIResponse] = []
//
//    @Published var infoLinkData: [InfoLinkData] = []
//
//    @Published var venueData: [VenueData] = []
//
//    func fetchEventsNearUserLocation(userLocation: CLLocationCoordinate2D) -> AnyPublisher<[APIResponse], Error> {
//        let endpoint = "/search-events"
//        let query = "events in sydney" // Modify the query as needed
//        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let urlString = "\(baseURL)\(endpoint)?query=\(encodedQuery)&latitude=\(userLocation.latitude)&longitude=\(userLocation.longitude)"
////        let urlString = "\(baseURL)\(endpoint)?query=\(query)&latitude=\(userLocation.latitude)&longitude=\(userLocation.longitude)"
//
//        print("!!! URL !!!: \(urlString)")
//
//        guard let url = URL(string: urlString) else {
//            print("Bad URL: \(urlString)")
//            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue(apiKey, forHTTPHeaderField: "X-RapidAPI-Key")
//        request.setValue("real-time-events-search.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
//
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .map(\.data)
//            .decode(type: APIResponse.self, decoder: JSONDecoder())
//            .handleEvents(receiveOutput: { apiResponse in
//                print("Received API response: \(apiResponse)")
//            }, receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print("Error: \(error)")
//                }
//            })
//            .map { apiResponse in
//                print("Received API response: \(apiResponse)")
//                // Map the apiResponse data to an array of APIResponse
//                return [APIResponse(
//                    status: apiResponse.status,
//                    request_id: apiResponse.request_id,
////                    parameters: apiResponse.parameters,
//                    parameters: APIParameters( // Create an APIParameters instance with "start" key
//                        query: apiResponse.parameters.query,
//                        start: apiResponse.parameters.start
//                    ),
//                    data: apiResponse.data.map { eventData in
//                        // Map eventData to EventData
//                        return EventData(
//                            event_id: eventData.event_id,
//                            name: eventData.name,
//                            link: eventData.link,
//                            description: eventData.description,
//                            start_time: eventData.start_time,
//                            end_time: eventData.end_time,
//                            is_virtual: eventData.is_virtual,
//                            thumbnail: eventData.thumbnail,
//                            info_links: eventData.info_links.map {
////                                InfoLinkData(id: "", source: $0.source, link: $0.link)
//                                InfoLinkData(source: $0.source, link: $0.link)
//                            },
//                            venue: VenueData(
//                                google_id: eventData.venue.google_id,
//                                subtype: eventData.venue.subtype,
//                                subtypes: eventData.venue.subtypes,
//                                full_address: eventData.venue.full_address,
//                                latitude: eventData.venue.latitude,
//                                longitude: eventData.venue.longitude,
//                                street_number: eventData.venue.street_number,
//                                street: eventData.venue.street,
//                                city: eventData.venue.city,
//                                state: eventData.venue.state,
//                                country: eventData.venue.country,
//                                google_mid: eventData.venue.google_mid
//                            ),
//                            tags: eventData.tags,
//                            language: eventData.language
//                        )
//                    }
//                )]
//            }
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
//}





import Foundation
import Combine
import CoreLocation // Import CoreLocation for CLLocationCoordinate2D

//struct EventAPIClient {
class EventAPIClient: ObservableObject {
    let apiKey = "11ceceee39msh55ec5840d38f5d3p1e0f4ajsndbe7bbf86192" // Replace with your actual API key
    let baseURL = "https://real-time-events-search.p.rapidapi.com"

    @Published var events: [APIResponse] = []
    
    @Published var infoLinkData: [InfoLinkData] = []
    
    @Published var venueData: [VenueData] = []
            
    func fetchEventsNearUserLocation(userLocation: CLLocationCoordinate2D) -> AnyPublisher<[APIResponse], Error> {
        let endpoint = "/search-events"
        let query = "events in sydney" // Modify the query as needed
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)\(endpoint)?query=\(encodedQuery)&latitude=\(userLocation.latitude)&longitude=\(userLocation.longitude)"
        
        print("!!! URL !!!: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue("real-time-events-search.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: APIResponse.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { apiResponse in
                print("Received API response: \(apiResponse)")
            }, receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            })
            .map { apiResponse in
                print("Received API response: \(apiResponse)")
                return [apiResponse]
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
