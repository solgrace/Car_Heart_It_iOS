//
//  EventsBookedView.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 2/10/2023.
//



//// USING COREDATA:
//import SwiftUI
//import CoreData
//
//struct EventsBookedView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    // Create a static variable for the fetch request
//    static var getBookedEventsFetchRequest: NSFetchRequest<BookedEvents> {
//        let request: NSFetchRequest<BookedEvents> = BookedEvents.fetchRequest()
//        request.sortDescriptors = []
//        return request
//    }
//
//    // Use the static fetch request in the @FetchRequest property wrapper
//    @FetchRequest(fetchRequest: getBookedEventsFetchRequest)
//    var bookedEvents: FetchedResults<BookedEvents>
//
//    var body: some View {
//        List {
//            ForEach(bookedEvents) { bookedEvent in
//                // Display booked event information here
//                VStack(alignment: .leading) {
//                    Text(bookedEvent.name ?? "Unknown Event")
//                        .font(.headline)
//                }
//            }
//        }
//        .navigationBarTitle("Booked Events")
//        .navigationBarTitle("", displayMode: .inline)
//        .navigationBarBackButtonHidden(true)
//        .navigationBarHidden(true)
//    }
//}





//// USING FIREBASE:
//import SwiftUI
//
//struct EventsBookedView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @StateObject private var bookedEventsViewModel = BookedEventsViewModel(coreDataManager: CoreDataManager.shared)
//
//    var body: some View {
//        List {
//            ForEach(bookedEventsViewModel.bookedEvents, id: \.id) { bookedEvent in
//                Section() {
//                    Text("Event Name:")
//                        .font(.body)
//                        .foregroundColor(.gray)
//                    Text(bookedEvent.eventName)
//                        .font(.title)
//                        .padding(.vertical, 10)
//
//                    Text("Link:")
//                        .font(.body)
//                        .foregroundColor(.gray)
//                    Text(bookedEvent.eventLink)
//                        .font(.body)
//                        .padding(.vertical, 10)
//
//                    Text("Start Time:")
//                        .font(.body)
//                        .foregroundColor(.gray)
//                    Text(bookedEvent.eventStartDate)
//                        .font(.body)
//                        .padding(.vertical, 10)
//
//                    Text("End Time:")
//                        .font(.body)
//                        .foregroundColor(.gray)
//                    Text(bookedEvent.eventEndDate)
//                        .font(.body)
//                        .padding(.vertical, 10)
//
//                    Text("Is Virtual:")
//                        .font(.body)
//                        .foregroundColor(.gray)
//                    Text(bookedEvent.eventIsVirtual)
//                        .font(.body)
//                        .padding(.vertical, 10)
//
//                    Text("Full Address:")
//                        .font(.body)
//                        .foregroundColor(.gray)
//                    Text(bookedEvent.eventFullAddress)
//                        .font(.body)
//                        .padding(.vertical, 10)
//
//                    Text("City, State, Country:")
//                        .font(.body)
//                        .foregroundColor(.gray)
//                    Text(bookedEvent.eventCity, bookedEvent.eventState, bookedEvent.eventCountry)
//                        .font(.body)
//                        .padding(.vertical, 10)
//                    // Add other event details if needed
//                }
//            }
//            .listRowSeparator(.hidden)
//        }
//        .onAppear {
//            // Fetch past booked events when the view appears
//            bookedEventsViewModel.getBookedEvents {
//                // This is the completion handler, and you can do something if needed
//            }
//        }
//        .navigationBarItems(leading: Button("Back") {
//            // Dismiss this view and navigate back to the previous view
//            presentationMode.wrappedValue.dismiss()
//        })
//
//        .navigationBarTitle("", displayMode: .inline)
//        .navigationBarBackButtonHidden(true)
//        .navigationBarHidden(true)
//    }
//}





// USING FIREBASE:
import SwiftUI
import Firebase

struct EventsBookedView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var bookedEventsViewModel = BookedEventsViewModel(coreDataManager: CoreDataManager.shared)

    var body: some View {
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

//                        Text("City, State, Country:")
//                            .font(.body)
//                            .foregroundColor(.gray)
//                        Text("\(bookedEvent.eventCity), \(bookedEvent.eventState), \(bookedEvent.eventCountry)")
//                            .padding(.vertical, 5)
                    }
                }
                .padding(.vertical, 18)
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
    
    
    
    
    
    func formatDate(_ timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy hh:mm a"
        return formatter.string(from: date)
    }

}
