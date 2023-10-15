//
//  SignupViewModel.swift
//  Car_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 23/9/2023.
//

import Foundation
import CoreData
import Firebase
import FirebaseDatabase

class SignupViewModel {
    
    
//    // Using CoreData:
//    func signup(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
//        // Check if a user with the provided email already exists
//        let coreDataManager = CoreDataManager.shared
//        let userAlreadyExists = coreDataManager.userExists(email: email)
//
//        if userAlreadyExists {
//            // User already exists, registration failed
//            completion(false, "User with this email already exists")
//        } else {
//            // Create a new user and save to CoreData
//            let isRegistered = coreDataManager.registerUser(firstName: firstName, lastName: lastName, email: email, password: password)
//
//            if isRegistered {
//                // Successful registration in CoreData
//                print("User successfully registered in CoreData: \(email)")
//
//                completion(true, nil)
//            } else {
//                // Registration failed
//                print("Registration failed for user in CoreData: \(email)")
//                completion(false, "Registration failed")
//            }
//        }
//
//        // You can include additional validation and error handling here
//    }
    
    
    // Using Firebase Authentication:
    func signup(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                completion(false, "Error creating user")
                return
            }

            if let user = authResult?.user {
                let userID = user.uid

                // Now you can store additional user details in the Realtime Database
                let databaseRef = Database.database().reference()
                let userDictionary: [String: Any] = [
                    "uid": userID,
                    "firstName": firstName,
                    "lastName": lastName,
                    "email": email,
                    "password": password
                    // Add any other user details you want to store
                ]

                databaseRef.child("Users").child(userID).setValue(userDictionary) { (error, _) in
                    if let error = error {
                        print("Error saving user details: \(error.localizedDescription)")
                        completion(false, "Error saving user details")
                    } else {
                        print("User details saved successfully")
                        completion(true, nil)
                    }
                }
            } else {
                completion(false, "Error creating user")
            }
        }
    }

}
