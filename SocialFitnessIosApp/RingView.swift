//
//  RingView.swift
//  SocialFitnessIosApp
//
//  Created by Eddie Gabriel on 8/28/22.
//

import Foundation
import HealthKit
import HealthKitUI
import SwiftUI

struct RingView : UIViewRepresentable {
    
    @State var fitness : main
    @Binding var ringInfo : HKActivitySummary
    
    func makeUIView(context: Context) -> HKActivityRingView {
        
        
        let ringObject = HKActivityRingView()
        ringObject.setActivitySummary(ringInfo, animated: true)
        
       // fitness.makeQuery() { summary in
        //    ringInfo = summary
          //  ringObject.setActivitySummary(ringInfo, animated: true)
        //}
        
        
        return ringObject
        
        
        
    }
    
    func updateUIView(_ ringView: HKActivityRingView, context: Context) {
        
        ringView.setActivitySummary(ringInfo, animated: true)
        
    }
    
}




struct RingBigView : View {
    
    @State var fitness : main
    @Binding var ringInfo : HKActivitySummary
    
    var body : some View {
        VStack{
            RingView(fitness: fitness, ringInfo: $ringInfo).frame(width: 100, height: 100)
        }.onAppear {
            fitness.makeQuery() { summary in
                ringInfo = summary
                
            }
        }
    }
    
}
