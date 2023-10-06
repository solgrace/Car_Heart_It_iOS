//
//  LoginView.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 23/9/2023.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loginError = ""
    @State private var isLogged = false // Track login status
    
    // Create an instance of LoginViewModel
    let loginViewModel = LoginViewModel()
    
    var body: some View {
        NavigationView { // Wrap your view in a NavigationView
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .padding()
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    // Call your login logic here using LoginViewModel
                    login()
                }) {
                    Text("Login")
                }
                .padding()
                
                Text(loginError)
                    .foregroundColor(.red)
                    .padding()
                
                // Use NavigationLink to navigate to EventMapView when logged in
                NavigationLink(destination: EventMapView(), isActive: $isLogged) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
    
//    // Function to call the signup logic from SignupViewModel (using CoreData)
//    private func login() {
//        loginViewModel.login(email: email, password: password) { success, errorMessage in
//            if success {
//                // Login was successful
//                print("Login successful from LoginView")
//
//                // Set isLogged to true to trigger navigation
//                isLogged = true
//
//                // You can navigate to another view or perform any other action here
//            } else {
//                // Login failed, display an error message
//                loginError = errorMessage ?? "Login failed"
//            }
//        }
//    }
    
    
    
    
    
    // Function to call the signup logic from SignupViewModel (using Firebase)
    private func login() {
        loginViewModel.login(email: email, password: password) { success, errorMessage in
            if success {
                // Login was successful
                print("Login successful from LoginView")
                
                // Set isLogged to true to trigger navigation
                isLogged = true
                
                // You can navigate to another view or perform any other action here
            } else {
                // Login failed, display an error message
                loginError = errorMessage ?? "Login failed"
            }
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
