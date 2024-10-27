import SwiftUI

struct RegisterView: View {
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    func createAccount(){
        
    }
    var body: some View {
        NavigationStack{
            ZStack {
                // Set the background color for the ZStack
                Color(red: 38/255, green: 38/255, blue: 38/255)
                    .ignoresSafeArea() // This will ensure the color covers the entire screen
                
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
                    VStack {
                        Text("")
                        Button(action: {
                            print("Clicked")
                        }) {
                            Text("Create account")
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .bold()
                        }
                        .background(Color.green)
                        .cornerRadius(10)

                        // Already have an account message
                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(.white)
                            NavigationLink(destination:FormView()){
                                Text("Login")
                                    .foregroundColor(.green)
                                    .bold()
                            }
                            
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 20)
                }
            }
        }
    
        }
    }

#Preview {
    RegisterView()
}
