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
    
    
    
    
    
    // Using Firebase Authentication:
    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                completion(false, "Invalid credentials")
                return
            }

            if let user = authResult?.user {
                let userID = user.uid
                completion(true, userID)
            } else {
                completion(false, "Invalid credentials")
            }
        }
    }
    
}
