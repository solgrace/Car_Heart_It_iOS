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





// USING FIREBASE:
import SwiftUI

struct EventsBookedView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var bookedEventsViewModel = BookedEventsViewModel(coreDataManager: CoreDataManager.shared)

    var body: some View {
        List(bookedEventsViewModel.bookedEvents, id: \.id) { bookedEvent in
            VStack(alignment: .leading) {
                Text(bookedEvent.eventName)
                    .font(.headline)
                // Add other event details if needed
            }
        }
        .onAppear {
            // Fetch past booked events when the view appears
            bookedEventsViewModel.getBookedEvents {
                // This is the completion handler, and you can do something if needed
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
