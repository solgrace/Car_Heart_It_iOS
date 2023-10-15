//
//  EventsBookedView.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 2/10/2023.
//

// USING FIREBASE:
import SwiftUI
import Firebase

struct EventsBookedView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var bookedEventsViewModel = BookedEventsViewModel(coreDataManager: CoreDataManager.shared)

    var body: some View {
        VStack {
            
            Text("Booked Events")
                .font(.system(size: 30))
                .fontWeight(.bold)
                .padding()
                .padding(.trailing, 110)
            
            Spacer().frame(height: 27)
            
            List {
                ForEach(bookedEventsViewModel.bookedEvents, id: \.id) { bookedEvent in
                    Section(header: Text("\(bookedEvent.eventName)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    ) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Link:")
                                .font(.body)
                                .foregroundColor(.gray)
                            Text(bookedEvent.eventLink)
                                .padding(.vertical, 5)
                            
                            Text("Start Time:")
                                .font(.body)
                                .foregroundColor(.gray)
                            Text(formatDate(bookedEvent.eventStartDate))
                                .padding(.vertical, 5)
                            
                            Text("End Time:")
                                .font(.body)
                                .foregroundColor(.gray)
                            Text(formatDate(bookedEvent.eventEndDate))
                                .padding(.vertical, 5)
                            
                            Text("Is Virtual:")
                                .font(.body)
                                .foregroundColor(.gray)
                            //                        Text(bookedEvent.eventIsVirtual)
                            Text(String(describing: bookedEvent.eventIsVirtual))
                                .padding(.vertical, 5)
                            
                            Text("Full Address:")
                                .font(.body)
                                .foregroundColor(.gray)
                            Text(bookedEvent.eventFullAddress)
                                .padding(.vertical, 5)
                        }
                    }
                    .padding(.vertical, 25)
                }
                .listRowSeparator(.hidden)
            }
            .onAppear {
                // Check if the user is signed in
                if let currentUser = Auth.auth().currentUser {
                    print("User is signed in. Fetching booked events...")
                    
                    // Fetch past booked events when the view appears
                    bookedEventsViewModel.getBookedEvents {
                        // This is the completion handler, and you can do something if needed
                    }
                } else {
                    print("User is not signed in")
                }
            }
            .navigationBarItems(leading: Button("Back") {
                // Dismiss this view and navigate back to the previous view
                presentationMode.wrappedValue.dismiss()
            })
            
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
    
    
    
    func formatDate(_ timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy hh:mm a"
        return formatter.string(from: date)
    }

}
