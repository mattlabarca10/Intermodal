import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordHidden = true
    @State private var loginError: String? // To display error messages
    @State private var isLoggedIn = false // State variable for login status

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image("LoginTrain")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom, -40)
               
                Text("Login")
                    .font(.system(size: 40, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.bottom,30)

                // Conditional NavigationLink based on login state
                NavigationLink(destination: FormView(), isActive: $isLoggedIn) {
                    EmptyView()
                }

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
                    signIn()
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

                // Display login error, if any
                if let error = loginError {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }

                Spacer()

                // Register Navigation Link
                HStack(spacing: -10) {
                    Text("Need An Account?")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                    NavigationLink(destination: RegisterView()) {
                        Text("Register")
                            .font(.system(size: 15))
                            .foregroundColor(.green)
                            .bold()
                    }
                    .padding()
                }
                .multilineTextAlignment(.center)
            }
            .padding()
            .background(Color(red: 38/255, green: 38/255, blue: 38/255))
        }
    }

    // Firebase Authentication Login Function
    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                loginError = "Login failed: \(error.localizedDescription)"
                print("Login error: \(error.localizedDescription)")
                isLoggedIn = false // Ensure we stay on the login page
            } else if authResult != nil {
                print("Login successful for user: \(authResult?.user.email ?? "")")
                loginError = nil // Clear any previous errors
                isLoggedIn = true // Navigate to FormView
            }
        }
    }
}

#Preview {
    LoginView()
}
