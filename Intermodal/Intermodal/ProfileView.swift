import SwiftUI
struct ProfileView: View {
    @State private var selectedSubView: Int? = 0 // Change to Int?
    var body: some View {
        NavigationStack {
            ZStack {
                // Set the background color
                Color(red: 38/255, green: 38/255, blue: 38/255)
                    .ignoresSafeArea() // This ensures the color covers the entire screen
                
                VStack {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .foregroundColor(.white)
                        .padding(.top, 50)
                    HStack {
                        NavigationLink(value: 0) {
                            Image(systemName: "tram")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 34)
                                .foregroundColor(selectedSubView == 0 ? Color.green : Color.white)
                                .padding(20)
                                .padding(.bottom,-15)
                                .onTapGesture {
                                    withAnimation {
                                        selectedSubView = 0
                                    }
                                }
                        }
                        NavigationLink(value: 1) {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40)
                                .foregroundColor(selectedSubView == 1 ? Color.green : Color.white)
                                .padding(20)
                                .padding(.bottom,-15)
                                .onTapGesture {
                                    withAnimation {
                                        selectedSubView = 1
                                    }
                                }
                        }
                    }
                    // Moving Line
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 70, height: 4)
                        .cornerRadius(2)
                        .animation(.easeInOut, value: selectedSubView)
                        .offset(x: selectedSubView == 0 ? -44 : 42)
                    
                    if selectedSubView == 0 {
                                            
                                           ProfileRoutesView()
                                               .transition(.opacity)
                                       } else if selectedSubView == 1 {
                                           ProfileSettingsView()
                                               .transition(.opacity)
                                           Spacer()
                                       }
                    }
               
                }
            }
        }
    }
#Preview {
    ProfileView()
}
