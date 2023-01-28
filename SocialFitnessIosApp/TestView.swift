//
//  TestView.swift
//  SocialFitnessIosApp
//
//  Created by Eddie Gabriel on 8/30/22.
//

import Neumorphic
import SwiftUI

struct TestView : View {
    
    
    
    var body : some View {
        
        ZStack{
            
            
            Color.Neumorphic.main.edgesIgnoringSafeArea(.all)
            VStack {
                HStack{
                    
                    Button(action: {}) {
                        Text("press me").fontWeight(.bold)
                    }.softButtonStyle(Capsule(), pressedEffect: .hard)
                }.padding()
                
                
                
                HStack {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: 150, height: 150)
                    }.padding()
                }
            }
        }
    }
}
    

    


struct ContentView_Preview: PreviewProvider {
    static var previews: some View {

        TestView().previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max")).environment(\.colorScheme, .light)
    }
}
