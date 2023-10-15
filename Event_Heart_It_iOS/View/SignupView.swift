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
    @State private var isSignedUp = false // Track signup status
    
    // Create an instance of SignupViewModel
    let signupViewModel = SignupViewModel()

    var body: some View {
        VStack {
            Text("Signup")
                .font(.system(size: 50))
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.white)
                .padding(.trailing, 165)
            
            Spacer().frame(height: 50)
            
            ZStack {
                // Blue background sheet
                Color.white.opacity(0.2) // Adjust opacity to control the darkness
                    .frame(width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.height / 1.7) // Set width and height
                    .cornerRadius(10)
                
                VStack {
                    Spacer().frame(height: 10)
                    
                    TextField(" First Name", text: $firstName)
                        .padding()
                        .frame(width: 280, height: 60)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    
                    Spacer().frame(height: 30)
                    
                    TextField(" Last Name", text: $lastName)
                        .padding()
                        .frame(width: 280, height: 60)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    
                    Spacer().frame(height: 30)
                    
                    TextField(" Email", text: $email)
                        .padding()
                        .frame(width: 280, height: 60)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    
                    Spacer().frame(height: 30)
                    
                    SecureField(" Password", text: $password)
                        .padding()
                        .frame(width: 280, height: 60)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    
                    Spacer().frame(height: 30)
                    
                    Button(action: {
                        // Call your signup logic here using SignupViewModel
                        signup()
                    }) {
                        Text("Signup")
                    }
                    .fontWeight(.bold)
                    .frame(width: 102, height: 55)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.trailing, 180)
                }
                
                Text(signupError)
                    .foregroundColor(.red)
                    .padding()
            }
            
            // Use NavigationLink to navigate to EventMapView when signed up
            NavigationLink(destination: EventMapView(), isActive: $isSignedUp) {
                EmptyView()
            }
            
            Spacer().frame(height: 40)
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .background(Color(red: 0.0706, green: 0, blue: 0.4784))
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
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
                
                // Set isSignedUp to true to trigger navigation
                isSignedUp = true
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
