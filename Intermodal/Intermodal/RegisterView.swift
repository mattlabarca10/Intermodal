
//  RegisterView.swift
//  Intermodal
//
//  Created by Abhiram Thotkura on 10/27/24.
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegisterView: View {
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    // Reference to Firestore
    private let db = Firestore.firestore()
    
    func createAccount() {
        Auth.auth().createUser(withEmail: emailText, password: passwordText) { authResult, error in
            if let error = error {
                showError = true
                errorMessage = error.localizedDescription
                return
            }
            
            if let authResult = authResult {
                // Create user document in Firestore
                let userId = authResult.user.uid
                let userEmail = authResult.user.email ?? ""
                var points = 0
                // Create user data dictionary
                let userData: [String: Any] = [
                    "userId": userId,
                    "email": userEmail,
                    "points": points
                ]
                
                // Add user to Firestore
                db.collection("users").document(userId).setData(userData) { error in
                    if let error = error {
                        showError = true
                        errorMessage = "Error saving user data: \(error.localizedDescription)"
                        return
                    }
                    
                    print("User created successfully and data saved to Firestore")
                    // Here you can handle successful registration (e.g., navigate to home screen)
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 38/255, green: 38/255, blue: 38/255)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Sign up now")
                        .font(.system(size: 50, design: .rounded))
                        .foregroundColor(.white)
                        .bold()
                    
                    Text("Create a free account today")
                        .font(.system(size: 20))
                        .foregroundColor(.green)
                        .bold()
                    
                    // Email Input
                    VStack {
                        Text("Email")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("Enter your email", text: $emailText)
                            .padding(10)
                            .background(Color(red: 56/255, green: 57/255, blue: 57/255))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)

                    // Password Input
                    VStack {
                        Text("Password")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        SecureField("Enter your password", text: $passwordText)
                            .padding(10)
                            .background(Color(red: 56/255, green: 57/255, blue: 57/255))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)

                    // Create Account Button
                    Button(action: {
                        createAccount()
                    }) {
                        Text("Create account")
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .bold()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 20)

                    // Already have an account message
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.white)
                        NavigationLink(destination: FormView()) {
                            Text("Login")
                                .foregroundColor(.green)
                                .bold()
                        }
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
}

#Preview {
    RegisterView()
}
