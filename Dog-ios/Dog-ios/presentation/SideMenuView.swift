

import SwiftUI

enum SideMenuRowType: Int, CaseIterable{
    case premium = 0
    case support
    case share
    case rateus
    
    var title: String{
        switch self {
        case .premium:
            return "Premium"
        case .support:
            return "VIP Support"
        case .share:
            return "Share"
        case .rateus:
            return "Rate Us"
        }
    }
    
    var iconName: String{
        switch self {
        case .premium:
            return "premium"
        case .support:
            return "support"
        case .share:
            return "share"
        case .rateus:
            return "rate_us"
        }
    }
}

struct SideMenuView: View {
    
    @Binding var selectedSideMenuTab: Int
    @Binding var presentSideMenu: Bool
    
    var body: some View {
        HStack {
            
            ZStack{
                Rectangle()
                    .fill(.white)
                    .frame(width: 270)
                    .shadow(color: .purple.opacity(0.1), radius: 5, x: 0, y: 3)
                
                VStack(alignment: .leading, spacing: 0) {
                    ProfileImageView()
                        .padding(.bottom, 30)
                    
                    ForEach(SideMenuRowType.allCases, id: \.self){ row in
                        RowView(isSelected: selectedSideMenuTab == row.rawValue, imageName: row.iconName, title: row.title) {
                            selectedSideMenuTab = row.rawValue
                            presentSideMenu.toggle()
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 100)
                .frame(width: 270)
                .background(
                    Color.white
                )
            }
            
            
            Spacer()
        }
        .background(.clear)
    }
    
    func ProfileImageView() -> some View{
        VStack(alignment: .center){
//            HStack{
//                Spacer()
//                Image("profile-image")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 100, height: 100)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 50)
//                            .stroke(.purple.opacity(0.5), lineWidth: 10)
//                    )
//                    .cornerRadius(50)
//                Spacer()
//            }
            
            Text("Dog Translator")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(.primary))
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .center)
        }
    }
    
    func RowView(isSelected: Bool, imageName: String, title: String, hideDivider: Bool = false, action: @escaping (()->())) -> some View{
        Button{
            action()
        } label: {
            VStack(alignment: .leading){
                HStack(spacing: 15){

                    ZStack{
                        Image(imageName)
                            .frame(width: 26, height: 26)
                    }
                    .frame(width: 30, height: 30)
                    Text(title)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.black)
                        .bold()
                    
                    Spacer()
                }
            }.padding(.leading,20)
        }
        .frame(height: 50)
    
    }
}


#Preview {
    SideMenuView(selectedSideMenuTab: .constant(0), presentSideMenu: .constant(false))
}




