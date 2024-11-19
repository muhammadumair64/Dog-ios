//
//  TranslateScreen.swift
//  Dog-ios
//
//  Created by Umair Rajput on 11/18/24.
//

import SwiftUI

struct TranslateScreen: View {
    @Environment(\.dismiss) var dismiss
    @Binding var navigationPath: NavigationPath
    @State private var isSwapped = false // State to track swapping
    
    var body: some View {
        ZStack {
            // Header
            VStack {
                HStack {
                    Image(ImageResource.backbtn)
                        .resizable()
                        .frame(width: 15, height: 20)
                        .onTapGesture {
                            dismiss() // Dismiss the screen
                        }
                    Text("Dog Translator")
                        .font(.system(size: 20))
                        .padding(.leading, 40)
                        .bold()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal,30)
                
                // Animation HStack
                HStack {
                    // Left VStack
                    VStack {
                        Image(ImageResource.humanFace)
                            .resizable()
                            .frame(width: 45, height: 45)
                    }
                    .frame(width: 150, height: 70)
                    .background(Color(hex: "#D5F7FF"))
                    .cornerRadius(40)
                    .offset(x: isSwapped ? 215 : 0) // Moves to the right
                    .animation(.easeInOut, value: isSwapped)

                    // Center Image
                    Image(ImageResource.convertIc)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.horizontal,15)
                        .onTapGesture {
                            withAnimation {
                                isSwapped.toggle() // Swap the VStacks on tap
                            }
                        }

                    // Right VStack
                    VStack {
                        Image(ImageResource.dogFace)
                            .resizable()
                            .frame(width: 45, height: 45)
                    }
                    .frame(width: 145, height: 70)
                    .background(Color(hex: "#FFF6D5"))
                    .cornerRadius(40)
                    .offset(x: isSwapped ? -215 : 0) // Moves to the left
                    .animation(.easeInOut, value: isSwapped)
                }.padding(.top,50)
                    .padding(.horizontal, 20)
                Spacer()
                
                //Text
                Text("Tap the record button to Start Recording....\nPress the arrow to switch from do g to human translator and vice versa")
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal,20)
                    .foregroundColor(.black)
                Spacer()
                
                Image(ImageResource.mic)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .onTapGesture {
                    }
                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.vertical, 20)

        }
    }
}


#Preview {
    TranslateScreen(navigationPath: .constant(NavigationPath()))
}
