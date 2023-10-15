//
//  EachEventView.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 2/10/2023.
//

//import SwiftUI
//
//struct EachEventView: View {
//    @Environment(\.presentationMode) var presentationMode
//    let event: EventData
//
//    @State private var isBooked = false
//    let bookedEventsViewModel = BookedEventsViewModel() // Create an instance
//
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 16) {
//
//                    // Event Name
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text("Event Name:")
//                            .font(.body)
//                            .foregroundColor(.gray)
//
//                        Text("\(event.name)")
//                            .font(.title)
//                    }
//                    .padding()
//
//                    // Event Description
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text("Description:")
//                            .font(.headline)
//
//                        Text("\(event.description ?? "N/A")")
//                            .font(.body)
//                    }
//                    .padding()
//
//                    // Event Is Virtual
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text("Is Virtual:")
//                            .font(.headline)
//
//                        Text("\(event.is_virtual.map(String.init(describing:)) ?? "N/A")")
//                            .font(.body)
//                    }
//                    .padding()
//
//                    // Event Start Time
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text("Start Time:")
//                            .font(.headline)
//
//                        Text("\(event.start_time ?? "N/A")")
//                            .font(.body)
//                    }
//                    .padding()
//
//                    // Event End Time
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text("End Time:")
//                            .font(.headline)
//
//                        Text("\(event.end_time ?? "N/A")")
//                            .font(.body)
//                    }
//                    .padding()
//
//                    // Event Link
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text("Link:")
//                            .font(.headline)
//
//                        Text("\(event.link ?? "N/A")")
//                            .font(.body)
//                    }
//                    .padding()
//
//                    // Event Venue
//                    if let venue = event.venue {
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("Venue:")
//                                .font(.title2)
//                                .bold()
//
//                            Spacer()
//                                .frame(height: 10)
//
//                            // Venue Subtypes
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text("Subtypes:")
//                                    .font(.headline)
//
//                                if let subtypes = venue.subtypes, !subtypes.isEmpty {
//                                    let subtypesString = subtypes.joined(separator: ", ")
//                                    Text(subtypesString)
//                                        .font(.body)
//                                        .padding(.bottom, 8) // Move the bottom padding here
//                                } else {
//                                    Text("N/A")
//                                        .font(.body)
//                                        .padding(.bottom, 8) // Move the bottom padding here
//                                }
//
//                                Spacer()
//                                    .frame(height: 20)
//                            }
//
//
//                            // Venue Address
//                            Text("Address:")
//                                .font(.headline)
//
//                            Text("\(venue.full_address ?? "N/A")")
//                                .font(.body)
//
//
//                            // Add more venue details if needed
//                        }
//                        .padding()
//                    } else {
//                        Text("Venue: N/A")
//                            .font(.body)
//                            .padding()
//                    }
//
//                    // Add more sections for other event details
//
//                    // Book Button
//                    Button(action: {
//                        // Toggle the booking status
//                        isBooked.toggle()
//
//                        // Call the bookEvent function in your BookedEventsViewModel instance
//                        if isBooked {
//                            bookedEventsViewModel.bookEvent(event: event) { success, errorMessage in
//                                if success {
//                                    // Handle successful booking
//                                    print("Event booked successfully!")
//                                } else {
//                                    // Handle booking failure
//                                    print("Failed to book event. Error: \(errorMessage ?? "Unknown error")")
//                                }
//                            }
//                        } else {
//                            // Handle unbooking if needed
//                        }
//                    }) {
//                        Text(isBooked ? "Booked!" : "Book")
//                            .foregroundColor(.white)
//                            .padding()
//                            .background(isBooked ? Color.green : Color.blue)
//                            .cornerRadius(8)
//                    }
//                    .padding(.bottom, 20)
//
//                }
//                .padding([.horizontal, .bottom], 15) // Adds horizontal (left and right) and bottom padding
//                .edgesIgnoringSafeArea(.all) // Ignore safe area to fill the entire screen
////                .navigationBarTitle("", displayMode: .inline)
////                .navigationBarHidden(true)
//            }
////            // Remove title if "< Back" not showing ↓
////            .navigationBarTitle("Event Details", displayMode: .inline)
////            // Remove title if "< Back" not showing ↑
//
//            .navigationBarItems(leading: Button("< Back") {
//                // This action will pop the view off the navigation stack
//                presentationMode.wrappedValue.dismiss()
//            })
//        }
//    }
//}





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
                            .padding(.bottom, 5)

                        Text("\(event.description ?? "N/A")")
                            .font(.body)
                            .foregroundColor(.black)
                            .padding(.bottom, 15)
                    }
                    .padding([.leading, .trailing], 25) // Add padding to the left and right





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


                                // Add more venue details if needed
                            }
                        } else {
                            Text("Venue: N/A")
                                .font(.body)
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        // Add more sections for other event details
                        
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
                                .padding(.bottom, 25)
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
