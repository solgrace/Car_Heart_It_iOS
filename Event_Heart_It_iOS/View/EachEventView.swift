//
//  EachEventView.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 2/10/2023.
//

import SwiftUI

struct EachEventView: View {
    let event: EventData

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Add spacing at the top
                Spacer()
                    .frame(height: 40)
                
                // Event Name
                VStack(alignment: .leading, spacing: 4) {
                    Text("Event Name:")
                        .font(.body)
                        .foregroundColor(.gray)

                    Text("\(event.name)")
                        .font(.title)
                }
                .padding()

                // Event Description
                VStack(alignment: .leading, spacing: 4) {
                    Text("Description:")
                        .font(.headline)
                    
                    Text("\(event.description ?? "N/A")")
                        .font(.body)
                }
                .padding()
                                                
                // Event Is Virtual
                VStack(alignment: .leading, spacing: 4) {
                    Text("Is Virtual:")
                        .font(.headline)
                    
                    Text("\(event.is_virtual.map(String.init(describing:)) ?? "N/A")")
                        .font(.body)
                }
                .padding()
                
                // Event Start Time
                VStack(alignment: .leading, spacing: 4) {
                    Text("Start Time:")
                        .font(.headline)
                    
                    Text("\(event.start_time ?? "N/A")")
                        .font(.body)
                }
                .padding()
                
                // Event End Time
                VStack(alignment: .leading, spacing: 4) {
                    Text("End Time:")
                        .font(.headline)
                    
                    Text("\(event.end_time ?? "N/A")")
                        .font(.body)
                }
                .padding()
                                
                // Event Link
                VStack(alignment: .leading, spacing: 4) {
                    Text("Link:")
                        .font(.headline)
                    
                    Text("\(event.link ?? "N/A")")
                        .font(.body)
                }
                .padding()

                // Event Venue
                if let venue = event.venue {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Venue:")
                            .font(.title2)

                        // Venue Subtypes
                        if let subtypes = venue.subtypes, !subtypes.isEmpty {
                            let subtypesString = subtypes.joined(separator: ", ")
                            Text("Subtypes: \(subtypesString)")
                                .font(.headline)
                        } else {
                            Text("Subtypes: N/A")
                                .font(.body)
                        }
                        
                        // Venue Address
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Address:")
                                .font(.headline)
                            
                            Text("\(venue.full_address ?? "N/A")")
                                .font(.body)
                        }
                        .padding()

                        // Add more venue details if needed
                    }
                    .padding()
                } else {
                    Text("Venue: N/A")
                        .font(.body)
                        .padding()
                }

                // Add more sections for other event details

            }
            .padding()
        }
        .navigationBarTitle("Event Details", displayMode: .inline)
    }
}
