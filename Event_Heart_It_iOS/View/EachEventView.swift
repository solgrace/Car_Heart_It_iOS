//
//  EachEventView.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 2/10/2023.
//

import SwiftUI

struct EachEventView: View {
    @Environment(\.presentationMode) var presentationMode
    let event: EventData
    
    // Updated initialization to use CoreDataManager
    let bookedEventsViewModel = BookedEventsViewModel(coreDataManager: CoreDataManager.shared)
    
    @State private var isBooked: Bool

    init(event: EventData) {
        self.event = event
        // Initialize isBooked based on the event's booking status
        self._isBooked = State(initialValue: bookedEventsViewModel.isEventBooked(event: event))
    }
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // Event Name
                    VStack {
                        Spacer().frame(height: 20)
                        
                        Text("\(event.name)")
                            .font(.title)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(red: 0.0706, green: 0, blue: 0.4784))
                        
                        Spacer().frame(height: 20)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(red: 0.0706, green: 0, blue: 0.4784))


                    Spacer().frame(height: 50)


                    // Event Description
                    VStack(alignment: .leading) {
                        Text("Description:")
                            .font(.headline)
                            .foregroundColor(.gray)

                        Text("\(event.description ?? "N/A")")
                            .font(.body)
                            .foregroundColor(.black)
                            .padding(.bottom, 15)
                    }
                    .padding([.leading, .trailing], 20) // Add padding to the left and right

                    
                    // Event Is Virtual
                    VStack(alignment: .leading) {
                        Text("Is Virtual:")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("\(event.is_virtual.map(String.init(describing:)) ?? "N/A")")
                            .font(.body)
                            .foregroundColor(.black)
                            .padding(.bottom, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding([.leading, .trailing], 25)


                    VStack(alignment: .leading) {
                        Text("Start Time:")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("\(event.start_time ?? "N/A")")
                            .font(.body)
                            .foregroundColor(.black)
                            .padding(.bottom, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding([.leading, .trailing], 25)

                    
                    VStack(alignment: .leading) {
                        Text("End Time:")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("\(event.end_time ?? "N/A")")
                            .font(.body)
                            .foregroundColor(.black)
                            .padding(.bottom, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding([.leading, .trailing], 25)


                    VStack(alignment: .leading) {
                        // Event Link
                        Text("Link:")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("\(event.link ?? "N/A")")
                            .font(.body)
                            .foregroundColor(.black)
                            .padding(.bottom, 45)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding([.leading, .trailing], 25)


                    VStack {
                        // Event Venue
                        if let venue = event.venue {
                            VStack {
                                Text("Venue:")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Spacer()
                                    .frame(height: 20)

                                // Venue Subtypes
                                VStack {
                                    Text("Subtypes:")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    if let subtypes = venue.subtypes, !subtypes.isEmpty {
                                        let subtypesString = subtypes.joined(separator: ", ")
                                        Text(subtypesString)
                                            .font(.body)
                                            .foregroundColor(.black)
                                            .padding(.bottom, 15) // Move the bottom padding here
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    } else {
                                        Text("N/A")
                                            .font(.body)
                                            .foregroundColor(.black)
                                            .padding(.bottom, 15) // Move the bottom padding here
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }

                                // Venue Address
                                Text("Address:")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text("\(venue.full_address ?? "N/A")")
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                            }
                        } else {
                            Text("Venue: N/A")
                                .font(.body)
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Spacer().frame(height: 25)

                        // Book Button
                        Button(action: {
                            bookedEventsViewModel.bookEvent(event: event) { success, errorMessage in
                                if success {
                                    // Handle successful booking
                                    print("Event booked successfully!")

                                    // Toggle the booking status
                                    isBooked.toggle()
                                } else {
                                    // Handle booking failure
                                    print("Failed to book event. Error: \(errorMessage ?? "Unknown error")")
                                }
                            }
                        }) {
                            Text(isBooked ? "This Event Has Already Been Booked." : "Book")
                                .foregroundColor(.white)
                                .padding(.top, 20)     // Top padding
                                .padding(.bottom, 20)  // Bottom padding
                                .padding(.leading, 35) // Left padding
                                .padding(.trailing, 35)// Right padding
                                .background(isBooked ? Color.gray : Color.blue) // Use different colors for booked and not booked states
                                .cornerRadius(8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                    }
                    .padding([.leading, .trailing], 25)
                    .edgesIgnoringSafeArea(.all) // Ignore safe area to fill the entire screen
                }
            }


//            .navigationBarItems(leading: Button("< Back") {
//                // This action will pop the view off the navigation stack
//                presentationMode.wrappedValue.dismiss()
//            })
            
            
            .navigationBarItems(leading: Button {
                // This action will pop the view off the navigation stack
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("< Back")
                    .foregroundColor(.black) // Set the text color to black
            })


        }
        .navigationBarHidden(true) // Hide the navigation bar
    }

}
