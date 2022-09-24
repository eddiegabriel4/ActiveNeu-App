//
//  StepLengthView.swift
//  SocialFitnessIosApp
//
//  Created by Eddie Gabriel on 9/19/22.
//

import Foundation
import SwiftUI
import HealthKit
import Neumorphic
import FirebaseDatabase

struct StepLengthView : View {
    
    @State var steplength : String = ""
    @State var walkingSpeed : String = ""
    @State var fitness : main
    @EnvironmentObject var walkingInfo : walking
    @EnvironmentObject var dimensions : dimensions
    private let database = Database.database().reference()
    @EnvironmentObject var loginCreds : creds

    
    var body: some View {
       
        ZStack{
            

            
            
            HStack(alignment: .bottom) {
                
                VStack (alignment: .leading){
                    Text("Stride Length").font(.system(size: 11, design: .rounded)).bold()
                    Text(Image(systemName: "ruler")).font(.system(size: 19))
                    
                }
                
                Text("\(steplength)").font(.system(size: 21, design: .rounded)).bold()
                + Text(" in.").font(.system(size: 13, design: .rounded)).bold()
                
            }
            VStack (alignment: .leading) {
                Text(Image(systemName: "arrow.right")).font(.system(size: 19)).bold()
                Text("\(walkingSpeed)").font(.system(size: 21, design: .rounded)).bold() + Text(" mph").font(.system(size: 13, design: .rounded)).bold()
                
            }.offset(x: 137, y: -100).onAppear() {
                walkingInfo.getWalkingRate()
            }
            
        }.onAppear() {
            fitness.RecieveStepLength { summary in
                steplength = summary
                DispatchQueue.main.async {
                    walkingInfo.length = summary
                }
                }
            fitness.RecieveWalkingSpeed { summary in
                walkingSpeed = summary
                self.database.child(loginCreds.UID).child("speed").setValue((summary as NSString).doubleValue)
                
                DispatchQueue.main.async {
                    walkingInfo.speed = summary
                }
                }
            
        }

    }

    
}


struct ContentView_Previe: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.colorScheme, .light).previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
    }
}
