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

    // Dictionary to store reviewText for each event
    @State private var reviewTexts: [UUID: String] = [:]

    // Helper function to get a Binding for reviewText based on the event
    private func getBinding(for event: BookedEventStruct) -> Binding<String> {
        return Binding(
            get: { self.reviewTexts[event.id] ?? "" },
            set: { self.reviewTexts[event.id] = $0 }
        )
    }

    var body: some View {
        VStack {
            
            Text("Leave a Review")
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
                            
                            TextField("Leave a review...", text: getBinding(for: bookedEvent))
                                .padding(.vertical, 10)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                        
                            Button("Submit Review") {
                                // Use the bookedEvent directly without setting selectedEvent
                                reviewsViewModel.submitReview(bookedEvent: bookedEvent, reviewText: reviewTexts[bookedEvent.id] ?? "") {
                                    // Handle the completion within this block
                                    // For example, you can update UI, show an alert, etc.
                                    print("Review submitted successfully!")
                                    
                                    // Reload reviews for the current event after submitting
                                    reviewsViewModel.fetchUniqueReviewsForEventFromCoreData(eventID: bookedEvent.eventID) { uniqueReviews in
                                        // Handle the fetched unique reviews
                                        DispatchQueue.main.async {
                                            reviewsViewModel.displayedReviews = uniqueReviews
                                            print("Displayed Reviews after fetching unique reviews:", reviewsViewModel.displayedReviews)
                                            
                                            // Fetch all reviews after submitting
                                            reviewsViewModel.fetchAllReviewsFromCoreData { allReviews in
                                                // Handle the fetched all reviews
                                                DispatchQueue.main.async {
                                                    print("All Reviews after fetching all reviews:", allReviews)
                                                    reviewsViewModel.displayedReviews = allReviews
                                                    // You can perform additional logic here if needed
                                                }
                                            }
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
    }

    func formatDate(_ timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy hh:mm a"
        return formatter.string(from: date)
    }

}
