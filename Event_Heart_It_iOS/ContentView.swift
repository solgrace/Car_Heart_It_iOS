//
//  ContentView.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 22/9/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .center) {
                    Text("Event Heart It ˙ᵕ˙")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)

                    Text("locate events near you!")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .italic()
                        .padding()
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .background(Color(red: 0.0706, green: 0, blue: 0.4784))
                
                
                VStack(alignment: .center, spacing: 0) {
                    Spacer().frame(height: 60)
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Log In")
                            .padding()
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .frame(width: UIScreen.main.bounds.width * 0.6, height: 65)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                    .padding()
                    
                    NavigationLink(destination: SignupView()) {
                        Text("Sign Up")
                            .padding()
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .frame(width: UIScreen.main.bounds.width * 0.6, height: 65)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                    .padding()
                    
                    Spacer().frame(height: 190)
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
        }
        .navigationBarTitle("", displayMode: .inline) // Just added this to test if "<" will be removed
        .navigationBarBackButtonHidden(true) // Add this line to hide the back button
    }
}

struct Previews_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
