//
//  SignupViewModel.swift
//  Car_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 23/9/2023.
//

import Foundation
import CoreData

class SignupViewModel {
    func signup(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        // Check if a user with the provided email already exists
        let coreDataManager = CoreDataManager.shared
        let userAlreadyExists = coreDataManager.userExists(email: email)
        
        if userAlreadyExists {
            // User already exists, registration failed
            completion(false, "User with this email already exists")
        } else {
            // Create a new user and save to CoreData
            let isRegistered = coreDataManager.registerUser(firstName: firstName, lastName: lastName, email: email, password: password)
            
            if isRegistered {
                // Successful registration in CoreData
                print("User successfully registered in CoreData: \(email)")
                                
                completion(true, nil)
            } else {
                // Registration failed
                print("Registration failed for user in CoreData: \(email)")
                completion(false, "Registration failed")
            }
        }
        
        // You can include additional validation and error handling here
    }
}
