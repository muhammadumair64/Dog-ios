import SwiftUI

struct NavigationHandler: ViewModifier {
    @Binding var path: NavigationPath
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: AppDestination.self) { destination in
                switch destination {
                case .premiumScreen:
                    PremiumScreen(navigationPath: $path).navigationBarBackButtonHidden()
                case .homeScreen(let userName):
                    HomeScreen(userName: userName,navigationPath: $path).navigationBarBackButtonHidden()
                case .translatorScreen:
                    TranslateScreen(navigationPath: $path).navigationBarBackButtonHidden()  
                }
            }
    }
}

extension View {
    func withNavigationHandler(path: Binding<NavigationPath>) -> some View {
        self.modifier(NavigationHandler(path: path))
    }
}

enum AppDestination: Hashable {
    case premiumScreen
    case homeScreen(userName: String)
    case translatorScreen
}
