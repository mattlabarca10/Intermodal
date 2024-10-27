//
//  ProfileRoutesView.swift
//  Intermodal
//
//  Created by Labarca, Matthew (206834437) on 10/26/24.
//
import SwiftUI
import Foundation
struct ProfileRoutesView: View{
    var body:some View{
        VStack{
            VStack{
                HStack{
                    HStack{
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.green)
                        Text("You saved 21.5lbs of CO₂ through 5 trips")
                            .foregroundColor(.white)
                            .bold()
                        Image(systemName: "multiply")
                            .padding(3)
                            .font(.system(size: 14))
                            .background(Color(.red))
                            .foregroundColor(.white)
                            .bold()
                            .cornerRadius(20)
                    }
                    .padding(.vertical,10)
                    
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(Color(red:57/225,green:57/225,blue:57/225))
                .cornerRadius(10)
                HStack{
                    HStack{
                        Image(systemName: "leaf")
                        VStack{
                            HStack{
                                Spacer()
                                Text("July 24, 2024")
                                    .padding(5)
                                    .padding(.trailing,10)
                                    .foregroundColor(.white)
                                    .bold()
                            }
                            Divider()
                                .background(Color(.black))
                            HStack{
                                VStack{
                                    Text("Starting:")
                                    Text("Ending:")
                                    Text("Stops:")
                                }
                            }
                        }
                    }
                }
                .background(Color(red:57/225,green:57/225,blue:57/225))
                .cornerRadius(10)
            }
        }.padding(.top,150)
            .padding(.horizontal,20)
    }
}

#Preview {
    ProfileRoutesView()
}
