//
//  Loading.swift
//  SocialFitnessIosApp
//
//  Created by Eddie Gabriel on 9/21/22.
//

import Foundation
import Lottie
import SwiftUI
import Neumorphic

struct LoadingAnimation : UIViewRepresentable {
    
    
    func makeUIView(context: Context) -> UIView {
    
        
        let view = UIView()
        let animationView = AnimationView()
        animationView.animation = Animation.named("8720-hi-wink")
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.animationSpeed = 1.0
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.backgroundBehavior = .pauseAndRestore
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([animationView.widthAnchor.constraint(equalTo: view.widthAnchor), animationView.heightAnchor.constraint(equalTo: view.heightAnchor)])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
        
    }
}


struct Loading : View {
    
    
    var body : some View {
        VStack{
            LoadingAnimation().frame(width: 220, height: 220).offset(y: 30)
        }
    }
    
}


