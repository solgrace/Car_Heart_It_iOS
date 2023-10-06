//
//  SignupView.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 23/9/2023.
//

import SwiftUI

struct SignupView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var signupError = ""
    
    // Create an instance of SignupViewModel
    let signupViewModel = SignupViewModel()

    var body: some View {
        VStack {
            Text("Signup")
                .font(.largeTitle)
                .padding()

            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Last Name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                // Call your signup logic here using SignupViewModel
                signup()
            }) {
                Text("Signup")
            }
            .padding()

            Text(signupError)
                .foregroundColor(.red)
                .padding()
        }
        .padding()
    }
    
//    // Function to call the signup logic from SignupViewModel (using CoreData)
//    private func signup() {
//        signupViewModel.signup(firstName: firstName, lastName: lastName, email: email, password: password) { success, errorMessage in
//            if success {
//                // Signup was successful
//                print("Signup successful from SignupView")
//                // You can navigate to another view or perform any other action here
//            } else {
//                // Signup failed, display an error message
//                signupError = errorMessage ?? "Signup failed"
//            }
//        }
//    }
    
    
    
    
    
    // Function to call the signup logic from SignupViewModel (using Firebase)
    private func signup() {
        signupViewModel.signup(firstName: firstName, lastName: lastName, email: email, password: password) { success, errorMessage in
            if success {
                // Signup was successful
                print("Signup successful from SignupView")
                // You can navigate to another view or perform any other action here
            } else {
                // Signup failed, display an error message
                signupError = errorMessage ?? "Signup failed"
            }
        }
    }

}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
