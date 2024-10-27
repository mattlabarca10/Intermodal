//
//  WelcomeView.swift
//  Intermodal
//
//  Created by Matthew LaBarca on 10/26/24.
//
import SwiftUI


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
        
        
        
    }
    
}

    #Preview {
    WelcomeView()
}
