//
//  EventsBookedView.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 2/10/2023.
//



//import SwiftUI
//import CoreData
//
//struct EventsBookedView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    // Fetch Request to get the booked events
//    @FetchRequest(
//        entity: BookedEvents.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \BookedEvents.name, ascending: false)],
//        animation: .default)
//    var bookedEvents: FetchedResults<BookedEvents>
////    private var bookedEvents: FetchedResults<BookedEvents>
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(bookedEvents) { bookedEvent in
//                    // Display booked event information here
//                    VStack(alignment: .leading) {
//                        Text(bookedEvent.name ?? "Unkown Event")
//                            .font(.headline)
//                    }
//                }
//                .navigationBarTitle("Booked Events")
//            }
//            .onAppear {
//                do {
//                    let events = try viewContext.fetch(BookedEvents.fetchRequest())
//                    print("Fetched \(events.count) events.")
//                } catch {
//                    print("Fetch error: \(error)")
//                }
//            }
//        }
//    }
//}



import SwiftUI
import CoreData

struct EventsBookedView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // Fetch Request to get the booked events
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BookedEvents.name, ascending: false)],
        animation: .default)
    var bookedEvents: FetchedResults<BookedEvents>

    var body: some View {
        NavigationView {
            List {
                ForEach(bookedEvents) { bookedEvent in
                    // Display booked event information here
                    VStack(alignment: .leading) {
                        Text(bookedEvent.name ?? "Unknown Event")
                            .font(.headline)
                    }
                }
            }
        }
    }
}
