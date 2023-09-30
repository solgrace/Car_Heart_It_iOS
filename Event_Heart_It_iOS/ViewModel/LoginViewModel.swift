//
//  LoginViewModel.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 23/9/2023.
//

import Foundation
import CoreData

class LoginViewModel {
    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        // Implement login logic
        // Check user credentials and authenticate
        
        // Example using Core Data:
        let coreDataManager = CoreDataManager.shared
        let isAuthenticated = coreDataManager.authenticateUser(email: email, password: password)
        
        if isAuthenticated {
            // Successful login
            completion(true, nil)
        } else {
            // Failed login
            completion(false, "Invalid email or password")
        }

    }
}
