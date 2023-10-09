//
//  ReviewsViewModel.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 8/10/2023.
//

import Foundation
import CoreData
import Firebase

class ReviewsViewModel: ObservableObject {
        
    @Published var displayedReviews: [Review] = []
    
    let persistentContainer: NSPersistentContainer

    internal init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    
    // Function to fetch the user's name from Firebase
    func fetchUserNameFromFirebase(userID: String, completion: @escaping ((String, String)?) -> Void) {
        var currentUser: (firstName: String, lastName: String)?

        let ref = Database.database().reference().child("Users").child(userID)
        
        print("Fetching user data from Firebase for userID: \(userID)")

        ref.observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any],
               let firstName = userData["firstName"] as? String,
               let lastName = userData["lastName"] as? String {
                   currentUser = (firstName, lastName)
                   print("User data fetched successfully. First Name: \(firstName), Last Name: \(lastName)")
                   completion(currentUser)
            } else {
                print("Failed to fetch user data from Firebase. Snapshot value: \(snapshot.value ?? "nil")")
                completion(nil) // Handle the case where data is not available
            }
        }
    }
    
    
//    func submitReview(bookedEvent: BookedEventStruct, reviewText: String, completion: @escaping () -> Void) {
//        print("submitReview pressed.")
//
//        // Check if the user is currently authenticated
//        if let currentUser = Auth.auth().currentUser {
//            // Fetch the user's name from Firebase using the authenticated user's ID
//            fetchUserNameFromFirebase(userID: currentUser.uid) { result in
//                if let userName = result {
//                    print("User name fetched from Firebase: \(userName.0), \(userName.1)")
//
//                    // Use the provided reviewText
//                    guard !reviewText.isEmpty else {
//                        // Handle the case where the review text is empty
//                        print("Review text is empty.")
//                        return
//                    }
//
//                    print("Review text is not empty:", reviewText)
//
//                    // Call your functions to save the review to CoreData and Firebase
//                    self.saveReviewToCoreData(bookedEvent: bookedEvent, reviewerFirstName: userName.0, reviewerLastName: userName.1, reviewText: reviewText)
//                    print("Review saved to CoreData.")
//
//                    self.saveReviewToFirebase(eventID: bookedEvent.eventID, reviewerFirstName: userName.0, reviewerLastName: userName.1, reviewText: reviewText)
//                    print("Review saved to Firebase.")
//
//                    // Call the completion handler after saving the review
//                    completion()
//                } else {
//                    print("Failed to fetch user data from Firebase.")
//                }
//            }
//        } else {
//            print("User is not authenticated.")
//            // Handle the case where the user is not authenticated, perhaps show a login screen
//        }
//    }
    
    
    func submitReview(bookedEvent: BookedEventStruct, reviewText: String, completion: @escaping () -> Void) {
        print("submitReview pressed.")

        // Check if the user is currently authenticated
        if let currentUser = Auth.auth().currentUser {
            // Fetch the user's name from Firebase using the authenticated user's ID
            fetchUserNameFromFirebase(userID: currentUser.uid) { result in
                if let userName = result {
                    print("User name fetched from Firebase: \(userName.0), \(userName.1)")

                    // Use the provided reviewText
                    guard !reviewText.isEmpty else {
                        // Handle the case where the review text is empty
                        print("Review text is empty.")
                        return
                    }

                    print("Review text is not empty:", reviewText)

                    // Call your functions to save the review to CoreData and Firebase
                    self.saveReviewToCoreData(bookedEvent: bookedEvent, reviewerFirstName: userName.0, reviewerLastName: userName.1, reviewText: reviewText)
                    print("Review saved to CoreData.")

                    self.saveReviewToFirebase(eventID: bookedEvent.eventID, reviewerFirstName: userName.0, reviewerLastName: userName.1, reviewText: reviewText)
                    print("Review saved to Firebase.")

                    
//                    // Fetch all reviews after submitting
//                    self.fetchAllReviewsFromCoreData { reviews in
//                        // Update the displayedReviews array with all reviews
//
////                        print("BEFORE: FETCHING THE displayedReviews array with all reviews: \(self.displayedReviews)")
//                        self.displayedReviews = reviews
//                        completion() // Call the completion handler after updating the reviews
////                        print("AFTER: FETCHING THE displayedReviews array with all reviews: \(self.displayedReviews)")
//
//                    }
                    
                    
                    // Fetch all reviews after submitting
                    self.fetchAllReviewsFromCoreData { allReviews in
                        // Handle the fetched all reviews
                        DispatchQueue.main.async {
                            print("All Reviews after fetching all reviews:", allReviews)
                            self.displayedReviews = allReviews
                            completion()
                        }
                    }
                    
                } else {
                    print("Failed to fetch user data from Firebase.")
                }
            }
        } else {
            print("User is not authenticated.")
            // Handle the case where the user is not authenticated, perhaps show a login screen
        }
    }

        
    // Function to save a review to CoreData
    func saveReviewToCoreData(bookedEvent: BookedEventStruct, reviewerFirstName: String, reviewerLastName: String, reviewText: String) {
        let context = persistentContainer.viewContext
        let reviewEntity = NSEntityDescription.entity(forEntityName: "Review", in: context)

        guard let entity = reviewEntity else {
            print("Failed to create Review entity")
            return
        }

        let review = NSManagedObject(entity: entity, insertInto: context)

        // Set values for the Review entity
        review.setValue(bookedEvent.eventID, forKey: "eventID")
        review.setValue(reviewerFirstName, forKey: "reviewerFirstName")
        review.setValue(reviewerLastName, forKey: "reviewerLastName")
        review.setValue(reviewText, forKey: "reviewText")

        do {
            try context.save()
            print("Review saved to CoreData")
        } catch {
            print("Failed to save review to CoreData: \(error.localizedDescription)")
        }
    }
    
    
    // Function to save a review to Firebase
    func saveReviewToFirebase(eventID: String, reviewerFirstName: String, reviewerLastName: String, reviewText: String) {
        let databaseReference = Database.database().reference()

        // Create a unique review ID
        let reviewID = databaseReference.child("Reviews").child(eventID).childByAutoId().key

        // Unwrap optional values before setting in the dictionary
        let firstName = reviewerFirstName ?? ""
        let lastName = reviewerLastName ?? ""
        let reviewData: [String: Any] = [
            "reviewerName": "\(firstName) \(lastName)",
            "reviewText": reviewText
        ]

        // Save the review to Firebase
        databaseReference.child("Reviews").child(eventID).child(reviewID!).setValue(reviewData) { error, _ in
            if let error = error {
                print("Failed to save review to Firebase: \(error.localizedDescription)")
            } else {
                print("Review saved to Firebase")
            }
        }
    }
    
    
//    // Function to fetch reviews from CoreData
//    func fetchReviewsFromCoreData(for eventID: String, completion: @escaping ([Review]) -> Void) {
//        let context = persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<Review> = Review.fetchRequest()
//
//        // Set a predicate to filter reviews for the specific eventID
//        fetchRequest.predicate = NSPredicate(format: "eventID == %@", eventID)
//
//        do {
//            // Fetch reviews from CoreData
//            let reviews = try context.fetch(fetchRequest)
//            displayedReviews = reviews // Assign the fetched reviews
//            completion(reviews)
//        } catch {
//            print("Failed to fetch reviews from CoreData: \(error.localizedDescription)")
//            completion([])
//        }
//    }
    
    
    // Function to fetch all reviews from CoreData
    func fetchAllReviewsFromCoreData(completion: @escaping ([Review]) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Review> = Review.fetchRequest()

        do {
            // Fetch all reviews from CoreData
            let reviews = try context.fetch(fetchRequest)
            completion(reviews)
        } catch {
            print("Failed to fetch all reviews from CoreData: \(error.localizedDescription)")
            completion([])
        }
    }

    
    // Function to fetch unique reviews for a specific event from CoreData
    func fetchUniqueReviewsForEventFromCoreData(eventID: String, completion: @escaping ([Review]) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Review> = Review.fetchRequest()

        // Set a predicate to filter reviews for the specific eventID
        fetchRequest.predicate = NSPredicate(format: "eventID == %@", eventID)

        do {
            // Fetch reviews for the specific event from CoreData
            let reviews = try context.fetch(fetchRequest)
            print("Fetched \(reviews.count) reviews for eventID: \(eventID)")

            DispatchQueue.main.async {
                completion(reviews)
            }
        } catch {
            print("Failed to fetch reviews for the specific event from CoreData: \(error.localizedDescription)")
            DispatchQueue.main.async {
                completion([])
            }
        }
    }

    
    
    
    
//    // Function to fetch reviews for a specific event
//    func fetchReviewsForEvent(eventID: String) {
//        // Fetch initially from CoreData for fast local access
//        let localReviews = fetchReviewsFromCoreData(for: eventID)
//        displayLocally(localReviews)
//
//        // Periodically (e.g., in the background or on app launch), check for updates from Firebase
//        fetchReviewsFromFirebase(eventID: eventID) { firebaseReviews in
//            // Update the local CoreData storage with data from Firebase
//            self.updateReviewsInCoreData(for: eventID, with: firebaseReviews)
//
//            // Display the updated data in your UI
//            self.displayLocally(firebaseReviews)
//        }
//    }
//
//
//    // Function to display reviews locally
//    func displayLocally(_ reviews: [Review]) {
//        // Update the @Published property to trigger a refresh in your SwiftUI view
//        DispatchQueue.main.async {
//            self.displayedReviews = reviews
//        }
//    }
//
//
//    // Function to fetch reviews from CoreData for a specific event
//    private func fetchReviewsFromCoreData(for eventID: String) -> [Review] {
//        let context = persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<Review> = Review.fetchRequest()
//
//        // Set a predicate to filter reviews for the specific eventID
//        fetchRequest.predicate = NSPredicate(format: "eventID == %@", eventID)
//
//        do {
//            // Fetch reviews from CoreData
//            let reviews = try context.fetch(fetchRequest)
//            return reviews
//        } catch {
//            print("Failed to fetch reviews from CoreData: \(error.localizedDescription)")
//            return []
//        }
//    }
//
//
//    // Function to update reviews in CoreData for a specific event
//    private func updateReviewsInCoreData(for eventID: String, with reviews: [Review]) {
//        let context = persistentContainer.viewContext
//
//        // Remove existing reviews for the eventID
//        let existingReviews = fetchReviewsFromCoreData(for: eventID)
//        for existingReview in existingReviews {
//            context.delete(existingReview)
//        }
//
//        // Save the context to persist the deletions
//        do {
//            try context.save()
//        } catch {
//            print("Failed to save context after deleting existing reviews: \(error.localizedDescription)")
//        }
//
//        // Insert new reviews for the eventID
//        for review in reviews {
//            // Create a new review entity and set its properties
//            let newReview = Review(context: context)
//            newReview.eventID = eventID
//            newReview.reviewerFirstName = review.reviewerFirstName
//            newReview.reviewerLastName = review.reviewerLastName
//            newReview.reviewText = review.reviewText
//        }
//
//        // Save the context to persist the new reviews
//        do {
//            try context.save()
//        } catch {
//            print("Failed to save context after inserting new reviews: \(error.localizedDescription)")
//        }
//    }
//
//
//    // Function to fetch reviews from Firebase for a specific event
//    private func fetchReviewsFromFirebase(eventID: String, completion: @escaping ([Review]) -> Void) {
//        let databaseReference = Database.database().reference()
//
//        // Fetch reviews from Firebase for the specified event
//        databaseReference.child("Reviews").child(eventID).observeSingleEvent(of: .value) { (snapshot, error) in
//            if let error = error {
//                // Handle the error appropriately
//                print("Error fetching reviews from Firebase: \(error.localizedDescription)")
//                completion([])
//                return
//            }
//
//            // Parse the snapshot to get reviews
//            guard let reviewsSnapshot = snapshot.value as? [String: [String: Any]] else {
//                // If the snapshot doesn't contain the expected data structure
//                print("Invalid snapshot format for reviews")
//                completion([])
//                return
//            }
//
//            // Create an array to store the parsed reviews
//            var reviews: [Review] = []
//
//            for (reviewID, reviewData) in reviewsSnapshot {
//                // Assuming your Review model has attributes like "reviewerName" and "reviewText"
//                guard let reviewerName = reviewData["reviewerName"] as? String,
//                    let reviewText = reviewData["reviewText"] as? String else {
//                        // If the data is not in the expected format
//                        print("Invalid data format for review with ID: \(reviewID)")
//                        continue
//                }
//
//                // Create a Review object and add it to the array
//                let review = Review(
//                    reviewID: reviewID, // You may need to modify your Review model to include an ID or omit this field
//                    eventID: eventID,
//                    reviewerName: reviewerName,
//                    reviewText: reviewText
//                )
//
//                reviews.append(review)
//            }
//
//            // Call the completion handler with the fetched reviews
//            completion(reviews)
//        }
//    }

}
