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
                    .font(.system(size: 70))
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(.white)
                    .padding(.trailing, 140)
                
                Spacer().frame(height: 50)
                
                ZStack {
                    // Blue background sheet
                    Color.white.opacity(0.2) // Adjust opacity to control the darkness
                        .frame(width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.height / 2.4) // Set width and height
                        .cornerRadius(10)
                    
                    VStack {
                        TextField("      Email", text: $email)
                            .fontWeight(.bold)
                            .frame(width: 280, height: 60)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                        
                        Spacer().frame(height: 30)
                        
                        SecureField("      Password", text: $password)
                            .fontWeight(.bold)
                            .frame(width: 280, height: 60)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                        
                        Spacer().frame(height: 30)
                        
                        Button(action: {
                            // Call your login logic here using LoginViewModel
                            login()
                        }) {
                            Text("Login")
                        }
                        .fontWeight(.bold)
                        .frame(width: 102, height: 55)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.trailing, 180)
                    }
                
                    
                    
                Spacer().frame(height: 10)

                Text(loginError)
                    .foregroundColor(.red)
                    .padding()
                }
                

                
                
                
                // Use NavigationLink to navigate to EventMapView when logged in
                NavigationLink(destination: EventMapView(), isActive: $isLogged) {
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .background(Color(red: 0.0706, green: 0, blue: 0.4784))
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
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
