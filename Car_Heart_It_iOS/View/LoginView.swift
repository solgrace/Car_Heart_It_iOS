//
//  LoginView.swift
//  Car_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 23/9/2023.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loginError = ""
    
    // Create an instance of SignupViewModel
    let loginViewModel = LoginViewModel()
    
    var body: some View {
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
        }
        .padding()
    }
    
    // Function to call the signup logic from SignupViewModel
    private func login() {
        loginViewModel.login(email: email, password: password) { success, errorMessage in
            if success {
                // Login was successful
                print("Login successful from LoginView")
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
