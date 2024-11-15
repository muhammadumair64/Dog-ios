import SwiftUI

struct PremiumScreen: View {
    @Binding var navigationPath: NavigationPath
    var myName : String = "Umair"
    
    var body: some View {
        ZStack {
            VStack {
                Image("premium_bg")
                    .resizable()
                    .frame(height: UIScreen.main.bounds.height * 0.51)
                Spacer()
            }
            Image("backbtn")
                .resizable()
                .frame(width: 15, height: 25)
                .position(x: 30, y: 30)
                .padding(.top , 50).onTapGesture {
                    navigationPath.removeLast()
                }
            
            VStack {
                Spacer()
                VStack {
                    Text("Dog Translator")
                        .foregroundColor(.black)
                        .font(.system(size: 19))
                        .bold()
                    
                    Text("Unlimited access to all features")
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .padding(.top, 1)
                }
                
                Spacer()
                HStack {
                    itemFeatureView(icon: "translate", title: "Translate").padding(.leading, 40)
                    Spacer()
                    itemFeatureView(icon: "remove_ads", title: "Remove Ads").padding(.trailing, 30)
                }
                HStack {
                    itemFeatureView(icon: "unlock", title: "Unlock All").padding(.leading, 40)
                    Spacer()
                    itemFeatureView(icon: "support", title: "VIP Support").padding(.trailing, 30)
                }
                .padding(.top, 10)
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.90, height: 210)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 10)
            .padding(.top , 130)
            
            VStack {
                Spacer()
                Text("Get premium in 1.99$ / week. Subscription will auto-renew. Cancel anytime")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                    .multilineTextAlignment(.center)
                    .padding(.top, 1)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                Button {
                    navigationPath.append(AppDestination.homeScreen(userName: "Umair")) // Navigate to HomeScreen
                } label: {
                    myButton(title: "Start Now", btnColor: Color("primary"), bodyRatio: 0.90)
                }
                .padding(.bottom, 20)
                
                HStack {
                    Text("Privacy Policy")
                        .underline()
                        .foregroundColor(.blue)
                        .font(.system(size: 12))
                        .multilineTextAlignment(.center)
                        .padding(.top, 1)
                        .padding(.bottom, 20)
                    Spacer()
                    Text("Terms & Conditions")
                        .underline()
                        .foregroundColor(.blue)
                        .font(.system(size: 12))
                        .multilineTextAlignment(.center)
                        .padding(.top, 1)
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 90)
            }
        }
        .ignoresSafeArea()
    }
}

struct itemFeatureView: View {
    var icon: String
    var title: String
    var body: some View {
        HStack {
            Image(icon).frame(width: 20)
            Text(title)
                .font(.system(size: 15))
        }
    }
}

struct myButton: View {
    var title: String
    var btnColor: Color
    var bodyRatio: Double
    var body: some View {
        Text(title)
            .frame(width: UIScreen.main.bounds.width * bodyRatio , height: 55)
            .foregroundColor(Color.white)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [btnColor, btnColor.opacity(0.7)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(50)
            .font(.system(size: 18, weight: .semibold, design: .default))
    }
}

#Preview {
    PremiumScreen(navigationPath: .constant(NavigationPath()))
}
