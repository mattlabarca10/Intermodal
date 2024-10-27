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

<<<<<<< HEAD
struct WelcomeView : View {
    var body : some View {
        ZStack{
            
            VStack(spacing: 15) {
                Text("Intermodal")
                    .font(.system(size: 45,design: .rounded))
                    .foregroundColor(Color.black)
                Button(action: {
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding(.horizontal, 58)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .overlay(RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.blue, lineWidth: 2))
                }
                Button(action: {
                }) {
                    Text("Create Account")
                        .foregroundColor(.white)
                        .padding(.horizontal, 19)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .overlay(RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.blue, lineWidth: 2))
                }
                Button(action: {
                }) {
                    Text("Continue as Guest")
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .overlay(RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.blue, lineWidth: 2))
                }
                
                
            }
        }
        
        
        
=======
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
>>>>>>> f32ae34f14f2c29473d0744009d309038ff33f5a
    }
}




#Preview {
    WelcomeView()
}
