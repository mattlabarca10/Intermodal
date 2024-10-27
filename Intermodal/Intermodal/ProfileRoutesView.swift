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
        ScrollView{
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
                                .padding(.top,5)
                                .font(.system(size: 16))
                            
                                .foregroundColor(Color(red:38/225,green:38/225,blue:38/225))
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
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .scaledToFit()
                                .padding(.leading, 20)
                                .padding(.vertical,20)
                            Text("You have gained 2.1 points!")
                                .foregroundColor(.white)
                                .bold()
                            
                            Spacer()
                            Image(systemName: "multiply")
                                .padding(.trailing,15)
                                .font(.system(size: 16))
                            
                                .foregroundColor(Color(red:38/225,green:38/225,blue:38/225))
                                .bold()
                                .cornerRadius(20)
                        }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .background(Color(red:57/225,green:57/225,blue:57/225))
                            .cornerRadius(10)
                        
                    }
                    
                    HStack{
                        VStack{
                            
                            VStack{
                                HStack{
                                    
                                    
                                    Text("July 24, 2024")
                                        .padding(.top,07)
                                        .padding(.trailing,0)
                                        .foregroundColor(.white)
                                        .bold()
                                    Spacer()
                                    Image(systemName: "multiply")
                                        .padding(.top,5)
                                        .font(.system(size: 16))
                                    
                                        .foregroundColor(Color(red:38/225,green:38/225,blue:38/225))
                                        .bold()
                                        .cornerRadius(20)
                                }
                                Divider()
                                    .background(Color(.black))
                                HStack{
                                    Image(systemName: "train.side.front.car")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width:50)
                                        .foregroundColor(.white)
                                        .padding(.bottom,30)
                                    VStack(alignment:.leading){
                                        Text("Starting:Hickville high school")
                                            .foregroundColor(.white)
                                            .bold()
                                        Text("Ending:Rutgers University")
                                            .foregroundColor(.white)
                                            .bold()
                                        Text("Stops:5")
                                            .foregroundColor(.white)
                                            .bold()
                                    }
                                    .padding(.vertical,10)
                                    .padding(.trailing,20)
                                }
                            }
                        }.padding(3)
                            .padding(.horizontal,10)
                    }
                    .background(Color(red:57/225,green:57/225,blue:57/225))
                    .cornerRadius(10)
                }
                HStack{
                    VStack{
                        
                        VStack{
                            HStack{
                                
                                
                                Text("July 10, 2024")
                                    .padding(.top,07)
                                    .padding(.trailing,0)
                                    .foregroundColor(.white)
                                    .bold()
                                Spacer()
                                Image(systemName: "multiply")
                                    .padding(.top,5)
                                    .font(.system(size: 16))
                                
                                    .foregroundColor(Color(red:38/225,green:38/225,blue:38/225))
                                    .bold()
                                    .cornerRadius(20)
                            }
                            Divider()
                                .background(Color(.black))
                            HStack{
                                Image(systemName: "train.side.front.car")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:50)
                                    .foregroundColor(.white)
                                    .padding(.bottom,30)
                                VStack(alignment:.leading){
                                    Text("Starting: Rutgers University")
                                        .foregroundColor(.white)
                                        .bold()
                                    Text("Ending: New York, NY")
                                        .foregroundColor(.white)
                                        .bold()
                                    Text("Stops: 5")
                                        .foregroundColor(.white)
                                        .bold()
                                }
                                .padding(.vertical,10)
                                .padding(.trailing,20)
                            }
                        }
                    }.padding(3)
                        .padding(.horizontal,10)
                }
                .background(Color(red:57/225,green:57/225,blue:57/225))
                .cornerRadius(10)
                HStack{
                    VStack{
                        
                        VStack{
                            HStack{
                                
                                
                                Text("July 7, 2024")
                                    .padding(.top,07)
                                    .padding(.trailing,0)
                                    .foregroundColor(.white)
                                    .bold()
                                Spacer()
                                Image(systemName: "multiply")
                                    .padding(.top,5)
                                    .font(.system(size: 16))
                                
                                    .foregroundColor(Color(red:38/225,green:38/225,blue:38/225))
                                    .bold()
                                    .cornerRadius(20)
                            }
                            Divider()
                                .background(Color(.black))
                            HStack{
                                Image(systemName: "train.side.front.car")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:50)
                                    .foregroundColor(.white)
                                    .padding(.bottom,30)
                                
                                VStack(alignment:.leading){
                                    Text("Starting: Rutgers University")
                                        .foregroundColor(.white)
                                        .bold()
                                    Text("Ending: Edison, NJ")
                                        .foregroundColor(.white)
                                        .bold()
                                    Text("Stops: 1")
                                        .foregroundColor(.white)
                                        .bold()
                                }
                                .padding(.vertical,10)
                                .padding(.trailing,20)
                            }
                        }
                    }.padding(3)
                        .padding(.horizontal,10)
                }
                .background(Color(red:57/225,green:57/225,blue:57/225))
                .cornerRadius(10)
                HStack{
                    VStack{
                        
                        VStack{
                            HStack{
                                
                                
                                Text("July 4, 2024")
                                    .padding(.top,07)
                                    .padding(.trailing,0)
                                    .foregroundColor(.white)
                                    .bold()
                                Spacer()
                                Image(systemName: "multiply")
                                    .padding(.top,5)
                                    .font(.system(size: 16))
                                
                                    .foregroundColor(Color(red:38/225,green:38/225,blue:38/225))
                                    .bold()
                                    .cornerRadius(20)
                            }
                            Divider()
                                .background(Color(.black))
                            HStack{
                                Image(systemName: "train.side.front.car")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:50)
                                    .foregroundColor(.white)
                                    .padding(.bottom,30)
                                VStack(alignment:.leading){
                                    Text("Starting: Boston, MA")
                                        .foregroundColor(.white)
                                        .bold()
                                    Text("Ending:Rutgers University")
                                        .foregroundColor(.white)
                                        .bold()
                                    Text("Stops:3")
                                        .foregroundColor(.white)
                                        .bold()
                                }
                                .padding(.vertical,10)
                                .padding(.trailing,20)
                            }
                        }
                    }.padding(3)
                        .padding(.horizontal,10)
                }
                .background(Color(red:57/225,green:57/225,blue:57/225))
                .cornerRadius(10)
            }
            
                .padding(.horizontal,20)
        }
    }
        }
        
#Preview {
    ProfileRoutesView()
}
