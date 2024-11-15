//
//  HomeScreen.swift
//  Dog-ios
//
//  Created by Mac Mini on 15/11/2024.
//

import SwiftUI

struct HomeScreen: View {
    var userName: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Welcome, \(userName)!")
                .font(.largeTitle)
                .padding()
                .onTapGesture {
                                dismiss() // Dismisses the current screen (pops the navigation stack)
                            }
                        
            
            // Additional content for HomeScreen
        }
    }
}

#Preview {
    HomeScreen(userName: "Umair")
}
