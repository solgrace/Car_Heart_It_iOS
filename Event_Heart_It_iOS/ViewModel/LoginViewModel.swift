//
//  LoginViewModel.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 23/9/2023.
//

import Foundation
import CoreData
import Firebase
import FirebaseDatabase

class LoginViewModel {
    
//    // Using CoreData Version:
//    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
//        // Implement login logic
//        // Check user credentials and authenticate
//
//        // Example using Core Data:
//        let coreDataManager = CoreDataManager.shared
//        let isAuthenticated = coreDataManager.authenticateUser(email: email, password: password)
//
//        if isAuthenticated {
//            // Successful login
//            completion(true, nil)
//        } else {
//            // Failed login
//            completion(false, "Invalid email or password")
//        }
//    }
    
    
    
    
    
    // Using Firebase Realtime Database:
    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let databaseRef = Database.database().reference()

        databaseRef.child("Users").observeSingleEvent(of: .value) { snapshot in
            guard let users = snapshot.value as? [String: [String: String]] else {
                completion(false, "Invalid credentials")
                return
            }

            for (_, user) in users {
                if user["email"] == email && user["password"] == password {
                    completion(true, nil)
                    return
                }
            }

            // No matching user found
            completion(false, "Invalid credentials")
        }
    }
    
}
