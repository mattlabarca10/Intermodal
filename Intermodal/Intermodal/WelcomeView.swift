//
//  WelcomeView.swift
//  Intermodal
//
//  Created by Matthew LaBarca on 10/26/24.
//
import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

struct WelcomeView: View {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some View {
        NavigationStack {
            VStack {
                Image("LoginTrain")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom, -40)
                Text("Intermodal")
                    .font(.system(size: 45, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top,-25)

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

                NavigationLink(destination: RegisterView()) {
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
