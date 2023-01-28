//
//  HeartVib.swift
//  SocialFitnessIosApp
//
//  Created by Eddie Gabriel on 11/23/22.
//

import SwiftUI
import HealthKit

//heart bridge object in here will have heart rate data same way as in content view now. animation speed will be synced to heart rate and vibration function
//all in here. onchange of heartbridge.heartrate, recall function maybe

struct HeartVib: View {
    
    @StateObject var heartBridge = HeartRateObject()
    @State var streaming : Bool = false
    @State var value : Int = 0
    
    var body: some View {
        
        ZStack {
            
            
            VStack{
                
                HStack {
                    RollingText(font: .system(size: 55, design: .rounded), weight: .black, valux: $value)
                    Text("BPM").font(.system(size: 19, design: .rounded))
                }
                
                if streaming == false {
                    VStack (alignment: .center) {
                        Text("Open the ActiveNeu companion app on your Apple Watch and press the start button to begin streaming live heart rate data to your iPhone. This will allow you to feel your live heart beat in your hand").font(.system(size: 16, design: .rounded))
                        Text("-Bring your attention to your heart beat to slow the rate").font(.system(size: 16, design: .rounded)).padding()
                    }.padding(20).multilineTextAlignment(.center)
                }
                
                
                
                
            }.onChange(of: heartBridge.heartRate) { [old = heartBridge.heartRate] newVal in
                //print(newVal)
                value = Int(newVal)
                if old == Double(0.0) {
                    heart_emulate()
                    streaming = true
                }
            }
            
        }.onAppear {
            value = Int(heartBridge.heartRate)
        }
        
    
        
        
    }
    
    
    func heart_emulate() {
        
        let startTime = Date().timeIntervalSince1970
    
        var bps = (60 / heartBridge.heartRate) * 1.2
        var proportion = (bps * 0.2)
        var first = bps - proportion
    
            //pretty sure you got the logic, now just make accurate rate from above
    
            Timer.scheduledTimer(withTimeInterval: first, repeats: true) { timer in
    
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
    
                    delay(proportion){
    
                        let impact = UIImpactFeedbackGenerator(style: .rigid)
                        impact.impactOccurred()
    
                    }
    
//                var bps = (60 / heartBridge.heartRate) * 1.2
//                var proportion = (bps * 0.2)
//                var first = bps - proportion
                if heartBridge.heartRate == Double(0.0) {
                    timer.invalidate()
                    print("ended")
                    return
                }
                
                let endTime = Date().timeIntervalSince1970    // 1512538956.57195 seconds
                let elapsedTime = endTime - startTime
                //you could change this to change vib refresh
                if elapsedTime > 5 {
                    timer.invalidate()
                    heart_emulate()
                }
    
            }
        }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    
    
    
   
    
}

struct RollingText : View {
    //@StateObject var heartBridge = HeartRateObject()
    var font: Font = .largeTitle
    var weight: Font.Weight = .regular
    @State var animationRange: [Int] = []
    @Binding var valux : Int
    var body : some View {
        HStack(spacing: 0) {
            ForEach(0..<animationRange.count, id: \.self) { index in
                Text("8").font(font).fontWeight(weight).opacity(0)
                    .overlay {
                        GeometryReader { proxy in
                            let size = proxy.size
                            
                            VStack(spacing: 0) {
                                ForEach(0...9, id: \.self) { number in
                                    
                                    Text("\(number)").font(font).fontWeight(weight)
                                        .frame(width: size.width, height: size.height, alignment: .center)
                                }
                            }
                            .offset(y: -CGFloat(animationRange[index]) * size.height)
                        }
                        .clipped()
                    }
            }
            
        }.onAppear {
            animationRange = Array(repeating: 0, count: "\(valux)".count)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
                updateText()
            }
        }.onChange(of: valux) { newVal in
            print(valux)
            let extra = "\(valux)".count - animationRange.count
            if extra > 0 {
                for _ in 0..<extra {
                    withAnimation(.easeIn(duration: 0.1)){animationRange.append(0)}
                }
            }
            else {
                for _ in 0..<(-extra) {
                    withAnimation(.easeIn(duration: 0.1)){animationRange.removeLast()}
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                updateText()
            }
        }
        
        
    }
    
    func updateText() {
        let stringValue = "\(valux)"
        for (inde, value) in zip(0..<stringValue.count, stringValue) {
            var fraction = Double(inde) * 0.15
            fraction = (fraction > 0.5 ? 0.5 : fraction)
            withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 1 + fraction, blendDuration: 1 + fraction)) {
                //valid numbers are getting to this point
                animationRange[inde] = (String(value) as NSString).integerValue
            }
        }
    }
    
}


struct HeartVib_Previews: PreviewProvider {
    static var previews: some View {
        HeartVib()
    }
}


