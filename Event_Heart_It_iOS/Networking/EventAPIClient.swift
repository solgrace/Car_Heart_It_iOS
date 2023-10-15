//
//  EventAPIClient.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 29/9/2023.
//

import Foundation
import Combine
import CoreLocation // Import CoreLocation for CLLocationCoordinate2D

//struct EventAPIClient {
class EventAPIClient: ObservableObject {
    let apiKey = "0fef909f6dmsh217ab188023f96dp1df767jsn404d5fc9c363" // Replace with your actual API key
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
