//
//  ReviewsView.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 2/10/2023.
//

import SwiftUI

struct ReviewsView: View {

    @Environment(\.presentationMode) var presentationMode
    @StateObject private var bookedEventsViewModel = BookedEventsViewModel(coreDataManager: CoreDataManager.shared)
    @StateObject private var reviewsViewModel = ReviewsViewModel(persistentContainer: CoreDataManager.shared.persistentContainer)
    @State private var reviewText: String = ""
    @State private var selectedEvent: BookedEventStruct?
    
//    @State private var selectedEvent: BookedEvent?
//    @State private var selectedEvent: BookedEventStruct? // Adjust the type

    var body: some View {
        List {
            ForEach(bookedEventsViewModel.bookedEvents, id: \.id) { bookedEvent in
                Section(header: Text("\(bookedEvent.eventName)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                ) {
                    VStack(alignment: .leading, spacing: 10) {
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

                        Text("Full Address:")
                            .font(.body)
                            .foregroundColor(.gray)
                        Text(bookedEvent.eventFullAddress)
                            .padding(.vertical, 5)
                        
                        TextField("Leave a review...", text: $reviewText)
                            .padding(.vertical, 10)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Button("Submit Review") {
                            // Use the bookedEvent directly without setting selectedEvent
                            reviewsViewModel.submitReview(bookedEvent: bookedEvent, reviewText: reviewText) {
                                // Reload reviews for the current event after submitting
                                reviewsViewModel.fetchUniqueReviewsForEventFromCoreData(eventID: bookedEvent.eventID) { reviews in
                                    // Handle the fetched reviews
                                    DispatchQueue.main.async {
                                        reviewsViewModel.displayedReviews = reviews
                                    }
                                }
                            }
                        }

                        // Display reviews for the current event
                        ForEach(reviewsViewModel.displayedReviews.filter { $0.eventID == bookedEvent.eventID }, id: \.id) { review in
                            Text("\((review.reviewerFirstName ?? "") + (review.reviewerLastName ?? "")): \(review.reviewText ?? "")")
                                .padding(.vertical, 5)
                        }
                    }
                }
                .padding(.vertical, 18)
            }
            .listRowSeparator(.hidden)
        }
        .onAppear {
            // Fetch past booked events when the view appears
            bookedEventsViewModel.getBookedEvents {
                // This is the completion handler, and you can do something if needed
            }

            // Fetch all reviews when the view appears
            reviewsViewModel.fetchAllReviewsFromCoreData { reviews in
                // Handle the fetched reviews
                DispatchQueue.main.async {
                    reviewsViewModel.displayedReviews = reviews
                }
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
