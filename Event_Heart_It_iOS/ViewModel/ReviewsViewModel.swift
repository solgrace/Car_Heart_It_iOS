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

}
