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
//    @ObservedObject private var reviewsViewModel: ReviewsViewModel
//    @StateObject private var reviewsViewModel: ReviewsViewModel
    @StateObject private var reviewsViewModel = ReviewsViewModel(persistentContainer: CoreDataManager.shared.persistentContainer)
    @State private var reviewText: String = ""
    @State private var eventReviews: [Review] = []
    
//    init(reviewsViewModel: ReviewsViewModel) {
//        _reviewsViewModel = ObservedObject(wrappedValue: reviewsViewModel)
//    }

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

//                        Text("Is Virtual:")
//                            .font(.body)
//                            .foregroundColor(.gray)
//                        Text(String(describing: bookedEvent.eventIsVirtual))
//                            .padding(.vertical, 5)

                        Text("Full Address:")
                            .font(.body)
                            .foregroundColor(.gray)
                        Text(bookedEvent.eventFullAddress)
                            .padding(.vertical, 5)
                        
                        TextField("Leave a review...", text: $reviewText)
                            .padding(.vertical, 10)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button("Submit Review") {
                            reviewsViewModel.submitReview(bookedEvent: bookedEvent, reviewText: reviewText)
                        }
                        
                        // Display reviews for the current event
                        ForEach(reviewsViewModel.displayedReviews, id: \.id) { review in
                            Text("\((review.reviewerFirstName ?? "") + (review.reviewerLastName ?? "")): \(review.reviewText ?? "")")
                                .padding(.vertical, 5)
                        }
//                        ForEach(reviewsViewModel.displayedReviews, id: \.id) { review in
//                            Text("\(review.reviewerFirstName) \(review.reviewerLastName): \(review.reviewText)")
//                                .padding(.vertical, 5)
//                        }
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
            
            
//            reviewsViewModel.fetchUserNameFromCoreData()
            
            
            // Fetch reviews for the selected event
            reviewsViewModel.fetchReviewsFromCoreData(for: bookedEventsViewModel.bookedEvents.first?.eventID ?? "") { reviews in
                // Handle the fetched reviews
                // This closure is the completion handler
            }
            
            
//            // Fetch reviews for the selected event
//            fetchReviewsForEvent(eventID: bookedEventsViewModel.bookedEvents.first?.eventID ?? "")
        }
        .navigationBarItems(leading: Button("Back") {
            // Dismiss this view and navigate back to the previous view
            presentationMode.wrappedValue.dismiss()
        })

        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    
    
    
    
//    // Function to fetch reviews for the selected event
//    func fetchReviewsForEvent(eventID: String) {
//        reviewsViewModel.fetchReviewsFromCoreData(for: eventID) { reviews in
//            eventReviews = reviews
//        }
//    }

    
//    // Function to fetch reviews for the selected event
//    func fetchReviewsForEvent(eventID: String) {
//        reviewsViewModel.fetchReviewsForEvent(eventID: eventID) { reviews in
//            eventReviews = reviews
//        }
//    }

    
    func formatDate(_ timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy hh:mm a"
        return formatter.string(from: date)
    }

}
