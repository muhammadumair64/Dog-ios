//
//  HomeViewModel.swift
//  Dog-ios
//
//  Created by Umair Rajput on 11/18/24.
//

import Foundation
import SwiftUI


final class HomeViewModel:ObservableObject {
    @Environment(\.dismiss)  var dismiss
    
    let columns:  [GridItem] = [GridItem(.flexible()),
                                GridItem(.flexible())]
    let items = [
        (Color(hex: "#EFCFFF"), ImageResource.dog, "Sounds",ImageResource.purpleArrow,Color(hex: "#AD00FF")),
        (Color(hex: "#D8FFC5"), ImageResource.dogTraining, "Whistle", ImageResource.greenArrow,Color(hex: "#00AC4D")),
        (Color(hex: "#FFDEDE") ,ImageResource.musicNote, "Songs", ImageResource.redArrow,Color(hex: "#FF0000")),
        (Color(hex: "#FFFFCB") ,ImageResource.dogTrainingWhistle, "Training", ImageResource.yellowArrow,Color(hex: "#B5BB00"))
    ]
    
    
}
