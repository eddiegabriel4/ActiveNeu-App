//
//  BottomPopUp.swift
//  SocialFitnessIosApp
//
//  Created by Eddie Gabriel on 9/21/22.
//

import SwiftUI
import Neumorphic
import Foundation


struct PopUp : View {
    
    var body : some View {
        
        VStack {
            Text(Image(systemName: "info")).font(.system(size: 30, design: .rounded)).foregroundColor(.blue).bold()
            Text("Actual step rate shown").font(.system(size: 20, design: .rounded))
            Text("based on today's data").font(.system(size: 20, design: .rounded))
            
            
        }.padding().background(Color.Neumorphic.main).cornerRadius(15)
         
    }
}
