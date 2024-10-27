//
//  WelcomeView.swift
//  Intermodal
//
//  Created by Matthew LaBarca on 10/26/24.
//
import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Intermodal")
                    .font(.system(size: 45, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()

                Spacer()
                
                NavigationLink(destination: LoginView()) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding(.horizontal, 170)
                        .padding(.vertical, 10)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .overlay(RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.green, lineWidth: 2))
                }

                NavigationLink(destination: LoginView()) {
                    Text("Create Account")
                        .foregroundColor(.white)
                        .padding(.horizontal, 131)
                        .padding(.vertical, 10)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .overlay(RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.green, lineWidth: 2))
                }

                NavigationLink(destination: FormView()) {
                    Text("Continue as Guest")
                        .foregroundColor(.white)
                        .padding(.horizontal, 122)
                        .padding(.vertical, 10)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .overlay(RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.green, lineWidth: 2))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Full-space frame on VStack
            .background(Color(red: 38/255, green: 38/255, blue: 38/255))
        }
    }
}




#Preview {
    WelcomeView()
}
