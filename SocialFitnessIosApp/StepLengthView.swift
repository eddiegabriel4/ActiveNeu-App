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
    @Binding var metric : Bool
    
    

    
    var body: some View {
       
        ZStack{
            

            
            
            HStack(alignment: .bottom) {
                
                VStack (alignment: .leading){
                    Text("Stride Length").font(.system(size: 11, design: .rounded)).bold()
                    Text(Image(systemName: "ruler")).font(.system(size: 19))
                    
                }
                
                if metric == false {
                    
                    Text("\(steplength)").font(.system(size: 21, design: .rounded)).bold()
                    + Text(" in.").font(.system(size: 13, design: .rounded)).bold()
                }
                else {
                    Text("\(self.InchMetric(input: steplength))").font(.system(size: 21, design: .rounded)).bold() + Text(" cm.").font(.system(size: 13, design: .rounded)).bold()
                }
                
            }
            VStack (alignment: .leading) {
                Text(Image(systemName: "arrow.right")).font(.system(size: 19)).bold()
                if metric {
                    Text("\(self.MPHMetric(input: walkingSpeed))").font(.system(size: 21, design: .rounded)).bold() + Text(" kph").font(.system(size: 13, design: .rounded)).bold()
                }
                else{
                    Text("\(walkingSpeed)").font(.system(size: 21, design: .rounded)).bold() + Text(" mph").font(.system(size: 13, design: .rounded)).bold()
                }
                
            }.offset(x: 132, y: -100).onAppear() {
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
                self.database.child("TotalRankings").child(loginCreds.UID).child("speed").setValue((summary as NSString).doubleValue)
                
                if self.loginCreds.groupID != 0 {
                    self.database.child("Groups").child(String(self.loginCreds.groupID)).child("members").child(self.loginCreds.UID).child("speed").setValue((summary as NSString).doubleValue)
                }
                
                DispatchQueue.main.async {
                    walkingInfo.speed = summary
                }
                }
            
        }

    }
    
    func InchMetric(input: String) -> String {
        let inch = Double(input)
        let cm = inch! * 2.54
        let value2 = Double(round(cm * 10) / 10)
        return trailingZeroes(input: value2)
        
    }
    
    func MPHMetric(input: String) -> String {
        let mph = Double(input)
        let kmh = mph! * 1.6
        
        let value2 = Double(round(kmh * 10) / 10)
        return trailingZeroes(input: value2)
        
    }

    
    
    
}



