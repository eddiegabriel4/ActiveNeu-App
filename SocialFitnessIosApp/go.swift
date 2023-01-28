//
//  go.swift
//  SocialFitnessIosApp
//
//  Created by Eddie Gabriel on 10/8/22.
//

import Foundation
import SwiftUI
import Neumorphic
import Firebase
import HealthKit


struct intro : View {
    
    @State var information : [infoHolder] = []
    @State var name : String = ""
    
    
    var body : some View {
        VStack {
            
            Text("testing").font(.system(size: 40, design: .rounded)).bold()
            TextField("what is the name of your dog? ", text: $name)
            ForEach(information, id: \.self) { object in
                Text("\(object.name)") + Text("\(object.breed)") + Text("\(object.age)")
            }
            
        }.onAppear() {
            var object1 = infoHolder(breed: "lab", name: "william", age: 7)
            information.append(object1)
            var object2 = infoHolder(breed: "lemon", name: name, age: 70)
            information.append(object2)
            
        }
    }
}


struct infoHolder : Identifiable, Hashable {
    
    var breed : String
    
    var name : String
    
    var age : Int
    
    var id = UUID()
}
