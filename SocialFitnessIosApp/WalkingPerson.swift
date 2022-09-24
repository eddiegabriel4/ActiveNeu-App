//
//  WalkingPerson.swift
//  SocialFitnessIosApp
//
//  Created by Eddie Gabriel on 9/8/22.
//

import Foundation
import Lottie
import SwiftUI
import Neumorphic



struct LotteView4 : UIViewRepresentable {
    
    @EnvironmentObject var walkingInfo : walking
    
    
    func makeUIView(context: Context) -> UIView {
    
        
        let view = UIView()
        let animationView = AnimationView()
        animationView.animation = Animation.named("Walking2")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        animationView.animationSpeed = walkingInfo.WalkingRate
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.backgroundBehavior = .pauseAndRestore
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([animationView.widthAnchor.constraint(equalTo: view.widthAnchor), animationView.heightAnchor.constraint(equalTo: view.heightAnchor)])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
        let subViews = uiView.subviews
            
        for each in subViews {
            if each is AnimationView {
                let actual = each as! AnimationView
                actual.animationSpeed = walkingInfo.getWalkingRate()
            }
        }
            
    }
}


struct WalkingPerson : View {
    
    @EnvironmentObject var walkingInfo : walking
    
    var body : some View {
        VStack{
            LotteView4().frame(width: 220, height: 220).offset(y: 30)
        }
    }
    
}


class walking : ObservableObject {
    
    @Published var WalkingRate : Double
    @Published var speed : String
    @Published var length : String
    
    init() {
        self.WalkingRate = 1.0
        self.speed = "0.0"
        self.length = "0.0"
    }
    
    func getWalkingRate() -> Double {   // use this to calculate personal walking rate
        
        var speed = Double(speed)
        var length = Double(length)
        
        if Double(speed!) != 0.0 {
            speed = speed! * 1.467
            speed = speed! * 12
            var rate = speed! / length!
            rate = rate * 60
            rate = rate / 94
            return Double(round(rate * 10) / 10)
        }
        else {
            return 1.0
        }
        
    }
    
}
