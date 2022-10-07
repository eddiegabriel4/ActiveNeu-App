//
//  GroupCreate.swift
//  SocialFitnessIosApp
//
//  Created by Eddie Gabriel on 10/5/22.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseDatabase
import Neumorphic

struct GroupCreate : View {
    @EnvironmentObject var loginCreds : creds
    @State var showCreationFields : Bool = false
    @State var showNoGroup : Bool = false
    @State var showCurrentGroup : Bool = false
    @State var groupName : String = ""
    @State var userName : String = ""
    private let database = Database.database().reference()
    @State private var groupController = 0
    @State var stepData : [GroupSteps] = []
    @State var flightData : [GroupFlights] = []
    @State var speedData : [GroupSpeed] = []
    @Binding var metric : Bool 
    
    @FocusState private var keyboard : Bool
    
    var body : some View {
        ZStack{
            Color.Neumorphic.main.edgesIgnoringSafeArea(.all)
            
            if showCreationFields {
                VStack {
                    VStack (spacing: 20){
                    HStack {
                        Text(Image(systemName: "pencil")).foregroundColor(Color.Neumorphic.secondary).font(Font.body.weight(.bold))
                        TextField("Group name", text: $groupName).autocapitalization(.none).foregroundColor(Color.Neumorphic.secondary).font(.system(size: 18, design: .rounded)).focused($keyboard).autocorrectionDisabled(true)
                    }.offset(x: 43).padding().background(
                        RoundedRectangle(cornerRadius: 30).fill(Color.Neumorphic.main)
                            .softInnerShadow(RoundedRectangle(cornerRadius: 30), darkShadow: Color.Neumorphic.darkShadow, lightShadow: Color.Neumorphic.lightShadow, spread: 0.5, radius: 2).frame(width: 340)
                    )
                    HStack {
                        Text(Image(systemName: "person")).foregroundColor(Color.Neumorphic.secondary).font(Font.body.weight(.bold))
                        TextField("name to be seen as", text: $userName).autocapitalization(.none).foregroundColor(Color.Neumorphic.secondary).font(.system(size: 18, design: .rounded)).focused($keyboard).autocorrectionDisabled(true)
                    }.offset(x: 43).padding().background(
                        RoundedRectangle(cornerRadius: 30).fill(Color.Neumorphic.main)
                            .softInnerShadow(RoundedRectangle(cornerRadius: 30), darkShadow: Color.Neumorphic.darkShadow, lightShadow: Color.Neumorphic.lightShadow, spread: 0.5, radius: 2).frame(width: 340)
                    )
                }
                    
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        if groupName != "" && userName != "" {
                            self.CreateGroup()
                            self.showCreationFields = false
                            self.showNoGroup = false
                            self.showCurrentGroup = true
                        }
                        
                        
                    }) {
                        Text("Create Group ").fontWeight(.bold)
                        + Text(Image(systemName: "plus")).font(.system(size: 20)).bold()
                        
                    }.softButtonStyle(Capsule(), pressedEffect: .hard).padding()
                    
                    
                    //once create button is pressed, toggle showCreationFields off and turn other on
                }
            }
            if showNoGroup {
                
                
                VStack{
                    Text("you are currently not in a group").font(.system(size: 25, design: .rounded)).bold().padding().multilineTextAlignment(.center)
                    Text("Groups allow you to create a custom leaderboard for you and your friends. You can create a group then invite people").font(.system(size: 15, design: .rounded)).bold().padding().multilineTextAlignment(.center)
                    
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        self.showCreationFields = true
                        self.showNoGroup = false
                        self.showCurrentGroup = false
                        
                        
                    }) {
                        Text("Create Group ").fontWeight(.bold)
                        + Text(Image(systemName: "plus")).font(.system(size: 20)).bold()
                        
                    }.softButtonStyle(Capsule(), pressedEffect: .hard).padding()
                }
                
                
            }
            if showCurrentGroup {
                // will need button to leave group
                ZStack{
                    VStack{
                        Picker("", selection: $groupController, content: {
                            Text("Flights").tag(0)
                            Text("Steps").tag(1)
                            Text("Walking Rate").tag(2)
                        }).pickerStyle(SegmentedPickerStyle()).padding()
                        
                        if groupController == 0{
                            VStack{
                                VStack(alignment: .leading) {
                                    Text("\(groupName)").font(.system(size: 36, design: .rounded)).bold().multilineTextAlignment(.center)
                                    Text("\(flightData.count) members").font(.system(size: 21, design: .rounded)).bold().foregroundColor(.gray)
                                }.padding()
                                
                                ScrollView{
                                    ForEach(flightData, id: \.self) { flight in
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: 300, height: 70)
                                            
                                            Text("\(flight.name):").font(.system(size: 18, design: .rounded)).bold() + Text(" \(flight.flights)").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.orange)
                                        }.padding(6)
                                        
                                    }
                                }.frame(height: 360)
                                
                        
                            }
                        }
                        
                        if groupController == 1 {
                            VStack{
                                VStack(alignment: .leading) {
                                    Text("\(groupName)").font(.system(size: 36, design: .rounded)).bold().multilineTextAlignment(.center)
                                    Text("\(stepData.count) members").font(.system(size: 21, design: .rounded)).bold().foregroundColor(.gray)
                                }.padding()
                                
                                ScrollView{
                                    ForEach(stepData, id: \.self) { step in
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: 300, height: 70)
                                            
                                            Text("\(step.name):").font(.system(size: 18, design: .rounded)).bold() + Text(" \(step.steps)").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.blue)
                                        }.padding(6)
                                        
                                    }
                                }.frame(height: 360)
                                
                                
                                
                            }
                        }
                        if groupController == 2 {
                            VStack{
                                VStack(alignment: .leading) {
                                    Text("\(groupName)").font(.system(size: 36, design: .rounded)).bold().multilineTextAlignment(.center)
                                    Text("\(speedData.count) members").font(.system(size: 21, design: .rounded)).bold().foregroundColor(.gray)
                                }.padding()
                                
                                ScrollView{
                                    ForEach(speedData, id: \.self) { step in
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: 300, height: 70)
                                            
                                            if self.metric == false {
                                                Text("\(step.name):").font(.system(size: 18, design: .rounded)).bold() + Text(" \(self.trailingZeroes(input: step.speed))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.blue) + Text(" mph").font(.system(size: 18, design: .rounded)).bold()
                                            }
                                            else {
                                                
                                                Text("\(step.name):").font(.system(size: 18, design: .rounded)).bold() + Text(" \(self.MPHMetric(input: self.trailingZeroes(input: step.speed)))").font(.system(size: 45, design: .rounded)).bold().foregroundColor(.blue) + Text(" kph").font(.system(size: 18, design: .rounded)).bold()
                                            }
                                        }.padding(6)
                                        
                                    }
                                }.frame(height: 360)
                                
                                
                                
                            }
                        }
                        let urlString = "https://activeneu.com/.well-known/apple-app-site-configuration/" + String(self.loginCreds.groupID)
                        let item = "come join my ActiveNeu group: '\(groupName)' " + urlString
                        let url = URL(string: urlString)
                        HStack(spacing: 20){
                            
                            
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                self.loginCreds.groupID = 0
                                UserDefaults.standard.set(0, forKey: "GroupID")
                                self.showNoGroup = true
                                self.showCurrentGroup = false
                                
                                
                                
                            }) {
                                Text("Leave Group ").fontWeight(.bold)
                                + Text(Image(systemName: "door.left.hand.open")).font(.system(size: 20)).bold()
                                
                            }.softButtonStyle(Capsule(), pressedEffect: .hard)
                            
                            ShareLink(item: item) {
                                Text("Invite members ").fontWeight(.bold)
                                + Text(Image(systemName: "square.and.arrow.up")).font(.system(size: 20)).bold()
                            }
                        }.padding()
                        
                    }
                }.onChange(of: groupController) { newval in
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                }.onAppear {
                    self.getStepsList() { completion in
                        stepData = completion   // working, just need to repeat for other data types
                    }
                    self.getFlightsList() { completion in
                        flightData = completion
                    }
                    self.getSpeedList() { completion in
                        speedData = completion
                    }
                    // create two more arrays for the other data types then use a segmented picker to change what VStack to show essentially
                }
            }
        }.onAppear {
            if loginCreds.groupID == 0 {
                self.showNoGroup = true
            }
            if loginCreds.groupID != 0 {
                self.showCurrentGroup = true
                let query = database.child("Groups").child(String(loginCreds.groupID)).child("groupName").getData() { error, data  in
                    groupName = data?.value as? String ?? "Unknown"
                }
            }
        }
    }
    
    
        func getStepsList(completion: @escaping ([GroupSteps]) -> ()) {
            var entry : Array<GroupSteps> = Array()
            let ref = Database.database().reference()
            let query = ref.child("Groups").child(String(loginCreds.groupID)).child("members").queryOrdered(byChild: "steps")
            
            query.observeSingleEvent(of: .value) {
                snapshot, x  in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    
                    
                    let stepsDict = snap.value as! [String : Any]
                    let steps = stepsDict["steps"]!
                    let name = stepsDict["name"]!
                    var keeper = GroupSteps(name: name as! String, steps: steps as! Int)
                    entry.append(keeper)
                    
                }
                
                completion(entry.reversed())
                
            }
            
            
        }
    
    func getSpeedList(completion: @escaping ([GroupSpeed]) -> ()) {
        var entry : Array<GroupSpeed> = Array()
        let ref = Database.database().reference()
        let query = ref.child("Groups").child(String(loginCreds.groupID)).child("members").queryOrdered(byChild: "speed")
        
        query.observeSingleEvent(of: .value) {
            snapshot, x  in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                
                
                let stepsDict = snap.value as! [String : Any]
                let steps = stepsDict["speed"]!
                let name = stepsDict["name"]!
                var keeper = GroupSpeed(name: name as! String, speed: steps as! Double)
                entry.append(keeper)
                
            }
            
            completion(entry.reversed())
            
        }
    }
    
    func getFlightsList(completion: @escaping ([GroupFlights]) -> ()) {
        var entry : Array<GroupFlights> = Array()
        let ref = Database.database().reference()
        let query = ref.child("Groups").child(String(loginCreds.groupID)).child("members").queryOrdered(byChild: "flights")
        
        query.observeSingleEvent(of: .value) {
            snapshot, x  in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                
                
                let stepsDict = snap.value as! [String : Any]
                let steps = stepsDict["flights"]!
                let name = stepsDict["name"]!
                var keeper = GroupFlights(name: name as! String, flights: steps as! Int)
                entry.append(keeper)
                
            }
            
            completion(entry.reversed())
            
        }
    }
    
    
    
    func CreateGroup() {
        
        let groupIdn = groupIdGenerator()
        self.loginCreds.groupID = groupIdn
        UserDefaults.standard.set(groupIdn, forKey: "GroupID")
        let object1 = [self.loginCreds.UID : "true"]
        let object2 = ["name" : userName,
                       "flights" : 0,
                       "steps" : 0,
                       "speed" : 0] as [String : Any]
        self.database.child("Groups").child(String(groupIdn)).child("allowed").setValue(object1)
        self.database.child("Groups").child(String(groupIdn)).child("groupName").setValue(groupName)
        self.database.child("Groups").child(String(groupIdn)).child("members").child(self.loginCreds.UID).setValue(object2)
        
        
        
        
    }
    
    func MPHMetric(input: String) -> String {
        let mph = Double(input)
        let kmh = mph! * 1.6
        
        let value2 = Double(round(kmh * 10) / 10)
        return trailingZeroes(input: value2)
        
    }
    
    func trailingZeroes(input: Double) -> String {
        let x = String(format: "%g", input)
        return x
    }
    
    
}



func groupIdGenerator() -> Int {
    var number = String()
    for _ in 1...6 {
       number += "\(Int.random(in: 0...9))"
    }
    return Int(number)!
}

struct GroupSpeed : Identifiable, Hashable {
    
    var name : String
    
    var speed : Double
    
    var id = UUID()
}

struct GroupSteps : Identifiable, Hashable {
    
    var name : String
    
    var steps : Int
    
    var id = UUID()
    
    
}

struct GroupFlights : Identifiable, Hashable {
    
    var name : String
    
    var flights : Int
    
    var id = UUID()
}
