//
//  HomeScreen.swift
//  Dog-ios
//
//  Created by Mac Mini on 15/11/2024.
//

import SwiftUI
import Lottie
import Foundation

struct HomeScreen: View {
    var userName: String

    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    
    @StateObject var viewModel = HomeViewModel()
    
    
    var body: some View {
                   ZStack(alignment: .top){
                       VStack{
                           HStack{
                               Image(
                                   ImageResource.menu
                               ).frame(width: 20,height: 20)
                                   .onTapGesture {
                                      withAnimation { presentSideMenu.toggle() }
                                                    }
                                                
                               Text("Dog Translator")
                                   .font(.system(size: 20))
                                   .padding(.leading,40)
                                   .bold()
                               
                           }
                               .frame(maxWidth: .infinity,alignment: .leading)
                               .padding(.horizontal,20)
                       
                           VStack(alignment: .leading) {
                               
                                   Text("Dog Translator")
                                       .foregroundColor(.white)
                                       .font(.system(size: 18))
                                       .bold()
                                       .padding(.bottom,5)
                                   
                                   
                                   Text("Unlock Secret language of dog")
                                       .foregroundColor(.white)
                                       .font(.system(size: 14))
                                       .multilineTextAlignment(.center)
                                       .padding(.bottom,10)
                               
                               Text("Translate Now")
                                   .frame(width: 130,height: 40)
                                   .foregroundColor(Color(.primary))
                                   .background(Color.white)
                                   .cornerRadius(15)
                                   .font(.system(size: 14))
                                   .bold()
                                   .multilineTextAlignment(.center)
                               
                                   
                           }.padding(.horizontal,30)
                           .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: 145,alignment: .leading)
                                       .clipped()
                                       .background(
                                           Image(ImageResource.homeCard)
                                                   .resizable()
                                                   .scaledToFill() )
                                       .cornerRadius(20)
                                       .padding(.horizontal,15)
                                       .padding(.top,20)
                           LazyVGrid(columns: viewModel.columns) {
                               ForEach(viewModel.items, id: \.2) { item in
                                              GridItemView(color: item.0, image: item.1, title: item.2, arrow: item.3, textColor: item.4)
                                          }
                                      } .padding()
                           
                           
                       
                       }.ignoresSafeArea()
                           .frame(
                               maxWidth: .infinity,
                               maxHeight: .infinity,
                               alignment: .top
                           )
                           .padding(
                               .vertical,
                               20
                           )
                           .opacity(presentSideMenu ? 0.5 : 1)
                        
                       // Main Card Lottie
                       HStack{
                           LottieView(animation: .named("main_screen_lottie"))
                               .playing()
                               .looping()
                               .frame(width: 160)
                           
                       }.frame(maxWidth: .infinity,maxHeight:200,alignment: .trailing)
                           .padding(.top,30)
                           .padding(.horizontal,15)
                           .opacity(presentSideMenu ? 0.5 : 1)
                       
                       if presentSideMenu {
                           
                           SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)
                          
                       }
                   }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: .infinity,
                           alignment: .top)
                    .gesture(
                      DragGesture()
                          .onEnded { gesture in
                              if gesture.translation.width < -50 {
                                  withAnimation {
                                      presentSideMenu = false // Close menu on swipe
                                  }
                              }
                          }
                    )
                  .animation(.easeInOut, value: presentSideMenu)
    }
}

#Preview {
    HomeScreen(userName: "Umair")
}



struct GridItemView: View {
    var color: Color
    var image: ImageResource
    var title: String
    var arrow: ImageResource
    var textColor:Color

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
                    .frame(height: 115)
                VStack() {
                    HStack{
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:50, height: 50)
                            .padding(.leading,5)
                        Spacer()
                        Image(arrow)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20,alignment:.top)
                            .padding(.bottom, 25)
                    }.padding(.horizontal,10)
                        .padding(.top,10)
                       
                  
                    Text(title)
                        .padding(.top,10)
                        .font(.headline)
                        .foregroundColor(textColor)
                    Spacer()

                }
                
            }
        }.frame(height: 115)
        .padding(3)
    }
}

