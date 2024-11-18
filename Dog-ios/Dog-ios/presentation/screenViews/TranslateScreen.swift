//
//  TranslateScreen.swift
//  Dog-ios
//
//  Created by Umair Rajput on 11/18/24.
//

import SwiftUI

struct TranslateScreen: View {
    @Binding var navigationPath: NavigationPath
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    TranslateScreen(navigationPath: .constant(NavigationPath()))
}
