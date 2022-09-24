//
//  StepGraphView.swift
//  SocialFitnessIosApp
//
//  Created by Eddie Gabriel on 8/28/22.
//

import Foundation
import SwiftUI
import HealthKit
import Neumorphic
import Combine




struct StepGraphHourly : View {  // hourly graph
    
    @State var fitness : main
    @State var localHourStepInfo : Array<StepsPerHour>
    @State var maximum : Double = 0.0
    @State var offset = CGFloat.zero
    @EnvironmentObject var offset2 : offsetKeeper
    
    
    var body : some View {
    
        let data: [StepsPerHour] = localHourStepInfo
        
        Text("Last 24 hours").font(.system(size: 15, design: .rounded)).bold().foregroundColor(.gray).offset(x: -34, y: -67).fixedSize(horizontal: true, vertical: false)

        ScrollViewReader { scrollview in
            
            ScrollView(.horizontal){
                
                HStack(spacing: 6) {
                    
                    ForEach(data) { item in
                        
                        VStack(alignment: .center, spacing: 2){
                        ZStack(alignment: .bottom){
                            RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main)
                                .frame(width: 20, height:110)
                            
                            RoundedRectangle(cornerRadius: 20).fill(.blue)
                                .frame(width: 20, height: item.animate ? ((item.steps) * (getRatio(max: maximum))) : 0)
                        }
                            VStack (alignment: .center) { // split up hour and pm,am
                                
                                Text("\(item.get12HourTime())").foregroundColor(.black).font(.system(size: 8, design: .rounded))
                                Text("\(item.getAMPM())").foregroundColor(.black).font(.system(size: 8, design: .rounded))
                            }
                            
                        }.id(item.id).offset(y:10)
                    }.onChange(of: data.count) { _ in
                        
                        scrollview.scrollTo(24)
                        
                    }
                }.onChange(of: offset) { newVal in
                    offset2.offset = offset - 491
                }
                .background(GeometryReader { proxy -> Color in 
                    DispatchQueue.main.async {
                        offset = -proxy.frame(in: .named("scroll")).origin.x
                        //offset2.offset = offset
                    }
                    return Color.clear
                }).frame(width: 640).padding().onAppear() {
                    
                    fitness.RecieveHourlySteps() { summary in
                        localHourStepInfo = summary.Steps48HrArray
                        maximum = localHourStepInfo.map{$0.steps}.max()!
                        for (index,_) in localHourStepInfo.enumerated() {
                            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.025) {
                                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.8)){
                                    localHourStepInfo[index].animate = true
                                }
                            }
                        }
                    }
                }
            }.frame(width: 167).offset(y: 0).coordinateSpace(name: "scroll")
        }
    }
}






struct StepsPerHour : Identifiable, Hashable { // object for hourly graph data
    
    var steps : Double
    var date : Date
    var animate : Bool = false
    var id : Int
    
    func get12HourTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh"
        let final = formatter.string(from: self.date)
        if String(final[0]) == "0" {
            return String(final[1])
        }
        else {
            return final
        }
    }
    
    func getAMPM() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        let final = formatter.string(from: self.date)
        return final
    }
}



struct StepsPerDay : Identifiable {  //object for daily graph data
    
    var steps : Double
    var date : Date
    var animate : Bool = false
    var id = UUID()
}





class StepsHourlyInfo : ObservableObject {  // object that contains total Steps and an array of stepsPerHour
    
    @Published var steps : Double
    @Published var Steps48HrArray : Array<StepsPerHour>
    
    init() {
        self.steps = 0.0
        self.Steps48HrArray = []
    }
    
    
}


class StepsDailyInfo : ObservableObject {  // object that contains total Steps and an array of stepsPerDay
    
   @Published var steps : Double
   @Published var Steps7DayArray : Array<StepsPerDay>
   @Published var healthyDays : Int
    
    init() {
        self.steps = 0.0
        self.Steps7DayArray = []
        self.healthyDays = 0
    }
    
}

class offsetKeeper : ObservableObject {
    
    @Published var offset : CGFloat
    
    init() {
        self.offset = CGFloat.zero
    }
    
}


func getRatioStep(max : Double) -> Double {
    
    let barHeight = 110.0
    let ratio = barHeight / max
    return ratio
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

///////////////////




struct ScrollViewOffset<Content: View>: View {
  let content: () -> Content
  let onOffsetChange: (CGFloat) -> Void

  init(
    @ViewBuilder content: @escaping () -> Content,
    onOffsetChange: @escaping (CGFloat) -> Void
  ) {
    self.content = content
    self.onOffsetChange = onOffsetChange
  }

  var body: some View {
      ScrollView(.horizontal) {
        offsetReader
              content()
        
    }
    .coordinateSpace(name: "frameLayer")
    .onPreferenceChange(OffsetPreferenceKey.self, perform: onOffsetChange)
  }

  var offsetReader: some View {
      GeometryReader { proxy in
           Color.clear
             .preference(
               key: OffsetPreferenceKey.self,
               value: proxy.frame(in: .named("frameLayer")).minX
             )
         }
         .frame(height: 0)
      
  }
}




private struct OffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}




struct StepGraphHourlyLight : View {  // hourly graph
    
    @State var fitness : main
    @State var localHourStepInfo : Array<StepsPerHour>
    @State var maximum : Double = 0.0
    @State var offset = CGFloat.zero
    @EnvironmentObject var offset2 : offsetKeeper
    
    var body : some View {
    
        let data: [StepsPerHour] = localHourStepInfo
        
        Text("last 24 hours").font(.system(size: 15, design: .rounded)).bold().foregroundColor(.gray).offset(x: -34, y: -67).fixedSize(horizontal: true, vertical: false)

        ScrollViewReader { scrollview in
            
            ScrollView(.horizontal){
                
                HStack(spacing: 6) {
                    
                    ForEach(data) { item in
                        
                        VStack(alignment: .center, spacing: 2){
                        ZStack(alignment: .bottom){
                            RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main)
                                .softInnerShadow(RoundedRectangle(cornerRadius: 20), darkShadow: Color.Neumorphic.darkShadow, lightShadow: Color.Neumorphic.lightShadow, spread: 0.3, radius: 2)
                                .frame(width: 20, height:110)
                            
                            RoundedRectangle(cornerRadius: 20).fill(.blue)
                                .frame(width: 20, height: item.animate ? ((item.steps) * (getRatio(max: maximum))) : 0)
                        }
                            VStack (alignment: .center) { // split up hour and pm,am
                                
                                Text("\(item.get12HourTime())").foregroundColor(.black).font(.system(size: 8, design: .rounded))
                                Text("\(item.getAMPM())").foregroundColor(.black).font(.system(size: 8, design: .rounded))
                            }
                            
                        }.id(item.id).offset(y:10)
                    }.onChange(of: data.count) { _ in
                        
                        scrollview.scrollTo(24)
                        
                    }
                }.onChange(of: offset) { newVal in   //not this
                    offset2.offset = offset - 491
                }
                .background(GeometryReader { proxy -> Color in  // not this
                    DispatchQueue.main.async {
                        offset = -proxy.frame(in: .named("scroll")).origin.x
                    }
                    return Color.clear
                }).frame(width: 640).padding().onAppear() {  //deleting all of this removes issue
                    
                    fitness.RecieveHourlySteps() { summary in
                        localHourStepInfo = summary.Steps48HrArray
                        maximum = localHourStepInfo.map{$0.steps}.max()! // not this
                        for (index,_) in localHourStepInfo.enumerated() {   // not this
                            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.025) {
                                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.8)){
                                    localHourStepInfo[index].animate = true
                                }
                            }
                        }
                    }
                }
            }.frame(width: 167).offset(y: 0).coordinateSpace(name: "scroll")
        }
    }
}




