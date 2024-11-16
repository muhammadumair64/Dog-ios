//
//  HomeScreen.swift
//  Dog-ios
//
//  Created by Mac Mini on 15/11/2024.
//

import SwiftUI
import Lottie

struct HomeScreen: View {
    var userName: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
                   ZStack(alignment: .top){
                       VStack{
                           HStack{
                               Image(
                                   ImageResource.menu
                               ).frame(width: 20,height: 20)
                               
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
                       // Main Card Lottie
                       HStack{
                           LottieView(animation: .named("main_screen_lottie"))
                               .playing()
                               .looping()
                               .frame(width: 160)
                           
                       }.frame(maxWidth: .infinity,maxHeight:200,alignment: .trailing)
                           .padding(.top,30)
                           .padding(.horizontal,15)
                   }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: .infinity,alignment: .top)
    }
}

#Preview {
    HomeScreen(userName: "Umair")
}
