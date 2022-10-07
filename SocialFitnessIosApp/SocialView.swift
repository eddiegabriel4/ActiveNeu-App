//
//  SocialView.swift
//  SocialFitnessIosApp
//
//  Created by Eddie Gabriel on 9/21/22.
//

import Foundation
import SwiftUI
import Neumorphic
import HealthKit
import FirebaseDatabase
import Firebase

struct SocialView : View {  // this will have the 3 buttons and do view control but the info will be in 3 seperate similar views
    
    @State private var showingController = 0
    
    @EnvironmentObject var LoginCreds :  creds
    
    @Binding var metric : Bool
    
    let impact = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        
        ZStack(alignment: .top){
            
            Color.Neumorphic.main.edgesIgnoringSafeArea(.all)
            
            VStack{
                Spacer()
                Picker("", selection: $showingController, content: {
                    Text("Flights").tag(0)
                    Text("Steps").tag(1)
                    Text("Walking Rate").tag(2)
                }).pickerStyle(SegmentedPickerStyle()).padding(50).offset(y: 17)
                
                if showingController == 0 {
                    FlightsRank().offset(y: -40)
                }
                if showingController == 1 {
                    StepsRank().offset(y: -40)
                }
                if showingController == 2 {
                    SpeedRank(metric: $metric).offset(y: -40)
                }
                
                
            }.onAppear {
                
            }
        }.onChange(of: showingController) { newval in
            impact.impactOccurred()
        }
        
        
    }
}


struct FlightsRank : View {
    
    @State var data : RankingDataHolder = RankingDataHolder()
    @EnvironmentObject var LoginCreds :  creds
    
    var body : some View {
        
        ZStack{
            
            Color.Neumorphic.main.edgesIgnoringSafeArea(.all)
            
            VStack (spacing: 16) {
                Text("Top 5 Users:").font(.system(size: 26, design: .rounded)).padding().bold().offset(x:-82)
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: 300, height: 70)
                    
                    //Text("\(data.rank)")
                    HStack(alignment: .bottom) {
                        if data.datas.count >= 5 {
                            
                            Text("\(Int(data.datas[0]))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.orange)
                            Text(" in past week").font(.system(size: 13, design: .rounded)).bold().offset(x: -7, y: -8)
                            
                        }
                        else {
                            Text("")
                        }
                        
                    }
                }
                
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: 300, height: 70)
                    
                    //Text("\(data.rank)")
                    HStack(alignment: .bottom) {
                        if data.datas.count >= 5 {
                            
                            Text("\(Int(data.datas[1]))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.orange)
                            Text(" in past week").font(.system(size: 13, design: .rounded)).bold().offset(x: -7, y: -8)
                            
                        }
                        else {
                            Text("")
                        }
                        
                    }
                }
                
                
                
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: 300, height: 70)
                    
                    //Text("\(data.rank)")
                    HStack(alignment: .bottom) {
                        if data.datas.count >= 5 {
                            
                            Text("\(Int(data.datas[2]))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.orange)
                            Text(" in past week").font(.system(size: 13, design: .rounded)).bold().offset(x: -7, y: -8)
                            
                        }
                        else {
                            Text("")
                        }
                        
                    }
                }
                
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: 300, height: 70)
                    
                    //Text("\(data.rank)")
                    HStack(alignment: .bottom) {
                        if data.datas.count >= 5 {
                            
                            Text("\(Int(data.datas[3]))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.orange)
                            Text(" in past week").font(.system(size: 13, design: .rounded)).bold().offset(x: -7, y: -8)
                            
                        }
                        else {
                            Text("")
                        }
                        
                    }
                }
                
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: 300, height: 70)
                    
                    //Text("\(data.rank)")
                    HStack(alignment: .bottom) {
                        if data.datas.count >= 5 {
                            
                            Text("\(Int(data.datas[4]))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.orange)
                            Text(" in past week").font(.system(size: 13, design: .rounded)).bold().offset(x: -7, y: -8)
                            
                        }
                        else {
                            Text("")
                        }
                        
                    }
                }
                VStack(alignment: .leading){
                    Text("Your ranking: ").font(.system(size: 18, design: .rounded)).bold()
                    HStack(alignment: .bottom){
                        Text("\(data.PostFix()) ").font(.system(size: 25, design: .rounded)).bold().foregroundColor(.orange).offset(y: 2)
                        Text("out of ").font(.system(size: 18, design: .rounded)).bold()
                        Text("\(data.total) ").font(.system(size: 25, design: .rounded)).bold().foregroundColor(.orange).offset(y: 2)
                        Text("total users").font(.system(size: 18, design: .rounded)).bold()
                        
                    }
                }.padding().offset(x:-40)
                Spacer()
                
            }.onAppear {
                
                
                
                getOrderedFlights() { completion in
                    data = completion
                    
                }
            }
        }
    }
    
    
    func getOrderedFlights(completion: @escaping (RankingDataHolder) -> ()) {  // this will be moved to flightsRankingView
        let data : RankingDataHolder = RankingDataHolder()
        var entry : Array<Double> = Array()
        let ref = Database.database().reference()
        let query = ref.child("TotalRankings").queryOrdered(byChild: "flights")
        
        query.observeSingleEvent(of: .value) {
            snapshot, x  in
            var total = 0
            var rank = 0
            for child in snapshot.children {
                total += 1
                let snap = child as! DataSnapshot
                
                if snap.key == LoginCreds.UID {
                    rank = total
                }
                
                let flightsDict = snap.value as! [String : Double]
                let flights = flightsDict["flights"]!
                entry.append(flights)
                
            }
            data.total = total
            data.rank = total - rank + 1  //????
            data.datas = entry.reversed() //only get first 5 here?
            completion(data)
            
        }
        
        
    }
    
}


struct StepsRank : View {
    @State var data : RankingDataHolder = RankingDataHolder()
    @EnvironmentObject var LoginCreds :  creds
    
    var body : some View {
        
        ZStack{
            
            Color.Neumorphic.main.edgesIgnoringSafeArea(.all)
            
            VStack (spacing: 16) {
                Text("Top 5 Users:").font(.system(size: 26, design: .rounded)).padding().bold().offset(x:-82)
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: 300, height: 70)
                    
                    //Text("\(data.rank)")
                    HStack(alignment: .bottom) {
                        if data.datas.count >= 5 {
                            
                            Text("\(Int(data.datas[0]))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.blue)
                            Text(" in past 24 hours").font(.system(size: 13, design: .rounded)).bold().offset(x: -7, y: -8)
                            
                        }
                        else {
                            Text("")
                        }
                        
                    }
                }
                
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: 300, height: 70)
                    
                    //Text("\(data.rank)")
                    HStack(alignment: .bottom) {
                        if data.datas.count >= 5 {
                            
                            Text("\(Int(data.datas[1]))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.blue)
                            Text(" in past 24 hours").font(.system(size: 13, design: .rounded)).bold().offset(x: -7, y: -8)
                            
                        }
                        else {
                            Text("")
                        }
                        
                    }
                }
                
                
                
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: 300, height: 70)
                    
                    //Text("\(data.rank)")
                    HStack(alignment: .bottom) {
                        if data.datas.count >= 5 {
                            
                            Text("\(Int(data.datas[2]))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.blue)
                            Text(" in past 24 hours").font(.system(size: 13, design: .rounded)).bold().offset(x: -7, y: -8)
                            
                        }
                        else {
                            Text("")
                        }
                        
                    }
                }
                
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: 300, height: 70)
                    
                    //Text("\(data.rank)")
                    HStack(alignment: .bottom) {
                        if data.datas.count >= 5 {
                            
                            Text("\(Int(data.datas[3]))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.blue)
                            Text(" in past 24 hours").font(.system(size: 13, design: .rounded)).bold().offset(x: -7, y: -8)
                            
                        }
                        else {
                            Text("")
                        }
                        
                    }
                }
                
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: 300, height: 70)
                    
                    //Text("\(data.rank)")
                    HStack(alignment: .bottom) {
                        if data.datas.count >= 5 {
                            
                            Text("\(Int(data.datas[4]))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.blue)
                            Text(" in past 24 hours").font(.system(size: 13, design: .rounded)).bold().offset(x: -7, y: -8)
                            
                        }
                        else {
                            Text("")
                        }
                        
                    }
                }
                VStack(alignment: .leading){
                    Text("Your ranking: ").font(.system(size: 18, design: .rounded)).bold()
                    HStack(alignment: .bottom){
                        Text("\(data.PostFix()) ").font(.system(size: 25, design: .rounded)).bold().foregroundColor(.blue).offset(y: 2)
                        Text("out of ").font(.system(size: 18, design: .rounded)).bold()
                        Text("\(data.total) ").font(.system(size: 25, design: .rounded)).bold().foregroundColor(.blue).offset(y: 2)
                        Text("total users").font(.system(size: 18, design: .rounded)).bold()
                        
                    }
                }.padding().offset(x:-40)
                Spacer()
                
            }.onAppear {
                
                getOrderedSteps() { completion in
                    data = completion
                    
                }
            }
        }
    }
    
    
    func getOrderedSteps(completion: @escaping (RankingDataHolder) -> ()) {  // this will be moved to flightsRankingView
        let data : RankingDataHolder = RankingDataHolder()
        var entry : Array<Double> = Array()
        let ref = Database.database().reference()
        let query = ref.child("TotalRankings").queryOrdered(byChild: "steps")
        
        query.observeSingleEvent(of: .value) {
            snapshot, x  in
            var total = 0
            var rank = 0
            for child in snapshot.children {
                total += 1
                let snap = child as! DataSnapshot
                
                if snap.key == LoginCreds.UID {
                    rank = total
                }
                
                let flightsDict = snap.value as! [String : Double]
                let flights = flightsDict["steps"]!
                entry.append(flights)
                
            }
            data.total = total
            data.rank = total - rank + 1  //????
            data.datas = entry.reversed() //only get first 5 here?
            completion(data)
            
        }
        
        
    }
}

struct SpeedRank : View {
    @State var data : RankingDataHolder = RankingDataHolder()
    @Binding var metric : Bool
    @EnvironmentObject var LoginCreds :  creds
    
    var body : some View {
        
        ZStack{
            
            Color.Neumorphic.main.edgesIgnoringSafeArea(.all)
            
            VStack (spacing: 16) {
                Text("Top 5 Users:").font(.system(size: 26, design: .rounded)).padding().bold().offset(x:-82)
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: 300, height: 70)
                    
                    //Text("\(data.rank)")
                    HStack(alignment: .bottom) {
                        if data.datas.count >= 5 {
                            if metric == false {
                                Text("\(String(data.datas[0]))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.purple)
                                Text(" mph today").font(.system(size: 13, design: .rounded)).bold().offset(x: -7, y: -8)
                            }
                            else {
                                Text("\(self.MPHMetric(input: String(data.datas[0])))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.purple)
                                Text(" kph today").font(.system(size: 13, design: .rounded)).bold().offset(x: -7, y: -8)
                            }
                            
                        }
                        else {
                            Text("")
                        }
                        
                    }
                }
                
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: 300, height: 70)
                    
                    //Text("\(data.rank)")
                    HStack(alignment: .bottom) {
                        if data.datas.count >= 5 {
                            if metric == false {
                                Text("\(String(data.datas[1]))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.purple)
                                Text(" mph today").font(.system(size: 13, design: .rounded)).bold().offset(x: -7, y: -8)
                            }
                            
                            else {
                                    Text("\(self.MPHMetric(input: String(data.datas[1])))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.purple)
                                    Text(" kph today").font(.system(size: 13, design: .rounded)).bold().offset(x: -7, y: -8)
                                }
                            
                            
                        }
                        else {
                            Text("")
                        }
                        
                    }
                }
                
                
                
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: 300, height: 70)
                    
                    //Text("\(data.rank)")
                    HStack(alignment: .bottom) {
                        if data.datas.count >= 5 {
                            if metric == false {
                                Text("\(String(data.datas[2]))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.purple)
                                Text(" mph today").font(.system(size: 13, design: .rounded)).bold().offset(x: -7, y: -8)
                            }
                            else {
                                Text("\(self.MPHMetric(input: String(data.datas[2])))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.purple)
                                Text(" kph today").font(.system(size: 13, design: .rounded)).bold().offset(x: -7, y: -8)
                            }
                            
                        }
                        else {
                            Text("")
                        }
                        
                    }
                }
                
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: 300, height: 70)
                    
                    //Text("\(data.rank)")
                    HStack(alignment: .bottom) {
                        if data.datas.count >= 5 {
                            if metric == false{
                                Text("\(String(data.datas[3]))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.purple)
                                Text(" mph today").font(.system(size: 13, design: .rounded)).bold().offset(x: -7, y: -8)
                            }
                            else {
                                Text("\(self.MPHMetric(input: String(data.datas[3])))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.purple)
                                Text(" kph today").font(.system(size: 13, design: .rounded)).bold().offset(x: -7, y: -8)
                            }
                            
                        }
                        else {
                            Text("")
                        }
                        
                    }
                }
                
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: 300, height: 70)
                    
                    //Text("\(data.rank)")
                    HStack(alignment: .bottom) {
                        if data.datas.count >= 5 {
                            if metric == false {
                                Text("\(String(data.datas[4]))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.purple)
                                Text(" mph today").font(.system(size: 13, design: .rounded)).bold().offset(x: -7, y: -8)
                            }
                            else {
                                Text("\(self.MPHMetric(input: String(data.datas[4])))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.purple)
                                Text(" kph today").font(.system(size: 13, design: .rounded)).bold().offset(x: -7, y: -8)
                            }
                            
                        }
                        else {
                            Text("")
                        }
                        
                    }
                }
                
                VStack(alignment: .leading){
                    Text("Your ranking: ").font(.system(size: 18, design: .rounded)).bold()
                    HStack(alignment: .bottom){
                        Text("\(data.PostFix()) ").font(.system(size: 25, design: .rounded)).bold().foregroundColor(.purple).offset(y: 2)
                        Text("out of ").font(.system(size: 18, design: .rounded)).bold()
                        Text("\(data.total) ").font(.system(size: 25, design: .rounded)).bold().foregroundColor(.purple).offset(y: 2)
                        Text("total users").font(.system(size: 18, design: .rounded)).bold()
                        
                    }
                }.padding().offset(x:-40)
                Spacer()
                
            }.onAppear {
                
                getOrderedSpeed() { completion in
                    data = completion
                    
                }
            }
        }
    }
    
    
    func getOrderedSpeed(completion: @escaping (RankingDataHolder) -> ()) {  // this will be moved to flightsRankingView
        let data : RankingDataHolder = RankingDataHolder()
        var entry : Array<Double> = Array()
        let ref = Database.database().reference()
        let query = ref.child("TotalRankings").queryOrdered(byChild: "speed")
        
        query.observeSingleEvent(of: .value) {
            snapshot, x  in
            var total = 0
            var rank = 0
            for child in snapshot.children {
                total += 1
                let snap = child as! DataSnapshot
                
                if snap.key == LoginCreds.UID {
                    rank = total
                }
                
                let flightsDict = snap.value as! [String : Double]
                let flights = flightsDict["speed"]!
                entry.append(flights)
                
            }
            data.total = total
            data.rank = total - rank + 1  //????
            data.datas = entry.reversed() //only get first 5 here?
            completion(data)
            
        }
        
        
    }
    
    func MPHMetric(input: String) -> String {
        let mph = Double(input)
        let kmh = mph! * 1.6
        
        let value2 = Double(round(kmh * 10) / 10)
        return trailingZeroes(input: value2)
        
    }
    
}





class RankingDataHolder {
    
    var rank : Int
    var total : Int
    var datas : Array<Double>
    
    init() {
        self.rank = 0
        self.total = 0
        self.datas = Array()
    }
    
    func PostFix() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: self.rank))!
    }
}



func trailingZeroes(input: Double) -> String {
    let x = String(format: "%g", input)
    return x
}
