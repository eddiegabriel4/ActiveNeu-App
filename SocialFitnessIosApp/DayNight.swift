//
//  DayNight.swift
//  SocialFitnessIosApp
//
//  Created by Eddie Gabriel on 9/4/22.
//

import Foundation
import Lottie
import SwiftUI
import Neumorphic




struct LotteView3 : UIViewRepresentable {
    
    @EnvironmentObject var frame : offsetKeeper
    @ObservedObject var hour : time = time()
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView()
        let animationView = AnimationView()
        animationView.animation = Animation.named("dayNight")
        animationView.contentMode = .scaleAspectFit
        animationView.currentFrame = AnimationFrameTime(hour.hourr)
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
                
                if frame.offset >= 0 {
                    
                    let frame = hour.hourr + by3(input: frame.offset)
                    if frame > 120 {
                        let frame3 = frame - 120
                        actual.currentFrame = AnimationFrameTime(frame3)
                        return
                    }
                    if frame < 0{
                        let frame2 = 120 + frame
                        actual.currentFrame = AnimationFrameTime(frame2)
                        
                    }
                    else {
                        actual.currentFrame = AnimationFrameTime(frame)
                    }
                }
                if frame.offset < 0{
                    
                    let frame = hour.hourr + by3(input: frame.offset)
                    if frame > 120 {
                        let frame3 = frame - 120
                        actual.currentFrame = AnimationFrameTime(frame3)
                    }
                    if frame < 0{
                        let frame2 = 120 + frame
                        if frame2 < 0 {
                            actual.currentFrame = AnimationFrameTime(120 + frame2)
                        }
                        else {
                            actual.currentFrame = AnimationFrameTime(frame2)
                        }
                        
                    }
                    else {
                        actual.currentFrame = AnimationFrameTime(frame)
                        
                        
                    }
                }
            }
        }
            
        }
}


struct DayNightTransition : View {
    
    @EnvironmentObject var frame : offsetKeeper
    
    var body : some View {
        VStack{
            LotteView3().frame(width: 130, height: 130).offset(x: -90)
        }
    }
    
}


func by3(input: CGFloat) -> Int {
    let mid = ceil(input / 4.09)
    return Int(mid)
}



class time : ObservableObject {
    
    @Published var hourr : Int = 0
    
    var hourDict = [0 : 45, 24 : 45, 1 : 50, 2 : 55, 3: 60, 4: 65, 5 : 70, 6 : 75, 7: 80, 8 : 85, 9: 90, 10: 95,
                    11 : 100, 12 : 105, 13 : 110, 14 : 115, 15 : 120, 16 : 5, 17 : 10, 18 : 15, 19 : 20,
                    20: 25, 21 : 30, 22 : 35, 23 : 45]
    
    
    init() {
        
        self.hourr = hourDict[Calendar.current.component(.hour, from: Date())]!
            
    }
    
}


class currentFrame  {
    
    @State var nowFrame : Int
    
    init() {
        self.nowFrame = 0
    }
    
}

