//
//  MainView.swift
//  Dog-ios
//
//  Created by Mac Mini on 15/11/2024.
//

import SwiftUI

struct MainView: View {
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ContentView(navigationPath: $navigationPath)
                .withNavigationHandler(path: $navigationPath)
        }
    }
}

#Preview {
    MainView()
}
