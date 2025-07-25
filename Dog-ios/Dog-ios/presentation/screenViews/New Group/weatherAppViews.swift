//
//  weatherAppViews.swift
//  Dog-ios
//
//  Created by Mac Mini on 10/06/2025.
//

import SwiftUI

struct weatherAppViews: View {
    @State private var selectedHour: Double = 8
    
    @State private var acSpeed: Int = 24
    var body: some View {
        
        VStack {
            Text("Select Hours")
                .font(.system(size: 20))
                .padding()
            
            
          CircularTemperatureSeekBar()
//            ArcTimerView()
//                      .padding()
//                      .background(Color.black.edgesIgnoringSafeArea(.all))
            
        
//            VStack {
//                ArcHourPickerView(selectedHour: $selectedHour)
//                    .frame(height: 200)
//                    .clipped() // This will clip the bottom half
//            }
//            .frame(height: 100) 

            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .padding()
    }
}

#Preview {
    weatherAppViews()
}
