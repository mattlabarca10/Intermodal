//
//  LoginView.swift
//  Intermodal
//
//  Created by Neel Bathija on 10/26/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordHidden = true
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image("LoginTrain")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom, -40)
                
                
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.bottom, 40)
                
                // Email TextField
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                
                // Password SecureField with Toggle
                ZStack(alignment: .trailing) {
                    if isPasswordHidden {
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    } else {
                        TextField("Password", text: $password)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        isPasswordHidden.toggle()
                    }) {
                        Image(systemName: isPasswordHidden ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                            .padding(.trailing, 20)
                    }
                }
                .padding(.horizontal, 20)
                
                // Login Button
                Button(action: {
                    // Perform login action here
                    print("Login button tapped with email: \(email) and password: \(password)")
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                Spacer()
                HStack(spacing: -10){
                    Text("Need An Account?")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                    NavigationLink(destination: WelcomeView())/*CHANGE VIEW */ {
                        Text("Register")
                            .font(.system(size: 15))
                            .foregroundColor(.green)
                            .multilineTextAlignment(.center)
                            .bold()
                    }
                    .padding()
                    .multilineTextAlignment(.center)
                }
             .multilineTextAlignment(.center)
                
            }
            .padding()
            .background(Color(red: 20/255,green : 20/255,blue:20/255))
        }
    }
}

   #Preview {
       LoginView()
   }
