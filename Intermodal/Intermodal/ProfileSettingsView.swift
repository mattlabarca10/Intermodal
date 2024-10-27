import SwiftUI

struct ProfileSettingsView: View {
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            // Email Field
            VStack(alignment: .leading) {
                Text("Email")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                ZStack(alignment:.trailing){
                    TextField("Enter your email", text: $email)
                        .padding(10)
                        .background(Color(red: 56/255, green: 57/255, blue: 57/255))
                        .cornerRadius(8)
                        .foregroundColor(.white) 
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.black)
                                           .padding(.trailing, 8)
                }
                // Text color
            }
            .padding(.bottom, 20) // Spacing between fields

            // Password Field
            VStack(alignment: .leading) {
                Text("Password")
                    .foregroundColor(.white)
                ZStack(alignment:.trailing){
                    SecureField("Enter your password", text: $password)
                        .padding(10)
                        .background(Color(red: 56/255, green: 57/255, blue: 57/255))
                        .cornerRadius(8)
                        .foregroundColor(.white) // Text color
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.black)
                                           .padding(.trailing, 8)
                }
               
            }.padding(.bottom,20)
            
            Button(action:{
                print("signed out")
            }){
                Text("Sign out")
                    .foregroundColor(.white)
                    .padding(.vertical,7)
                    .bold()
                    .padding(3)
            }
            .frame(maxWidth: .infinity)
            .background(Color(.red))
            .cornerRadius(8)
            .padding(.top,20)
            
        }
        .padding(.top, 150)
        .padding(.horizontal, 20) // Add some horizontal padding to the VStack
    }
}
#Preview {
    ProfileSettingsView()
}
