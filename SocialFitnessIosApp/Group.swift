//
//  Group.swift
//  SocialFitnessIosApp
//
//  Created by Eddie Gabriel on 9/27/22.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseDatabase
import Neumorphic

struct GroupSetUpView : View {
    
    @State var showHome : Bool = false
    @State var groupName : String = ""
    @State var userName : String = ""
    @EnvironmentObject var user : creds
    @State var input: String
    @State var permission : Bool = false
    @State var showingSheet : Bool = true
    @State var message : String = ""
    @Binding var recur : Bool  //so doesnt go back to app launch, don't change
    private let database = Database.database().reference()
    
    var body : some View {
        
        ZStack{
            Color.Neumorphic.main.edgesIgnoringSafeArea(.all)
            VStack (spacing: 15){
                VStack (spacing: 15){
                HStack{
                    Text(Image(systemName: "person")).foregroundColor(Color.Neumorphic.secondary).font(Font.body.weight(.bold))
                    TextField("name to be seen as", text: $userName).autocapitalization(.none).foregroundColor(Color.Neumorphic.secondary).font(.system(size: 18, design: .rounded))
                }.offset(x: 43).padding()
                    .background(
                        RoundedRectangle(cornerRadius: 30).fill(Color.Neumorphic.main)
                            .softInnerShadow(RoundedRectangle(cornerRadius: 30), darkShadow: Color.Neumorphic.darkShadow, lightShadow: Color.Neumorphic.lightShadow, spread: 0.5, radius: 2).frame(width: 340)
                    )
                
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                    
                    if userName != "" && permission == true {
                        self.enterGroup()
                        UserDefaults.standard.set(input, forKey: "GroupID")
                        self.user.groupID = Int(input)!
                        
                        let object = [
                            "name"    : "\(userName)",
                            "flights" : 0.0,
                            "steps"   : 0.0,
                            "speed"   : 0.0
                        ] as [String : Any]
                        
                        self.database.child("Groups").child(String(user.groupID)).child("members").child(user.UID).setValue(object)
                        self.message = "successfully joined group"
                    }
                    
                    else {
                        self.message = "unable to join group"
                    }
                    
                }) {
                    Text("join group").fontWeight(.bold)
                    
                }.softButtonStyle(Capsule(), pressedEffect: .hard)
                
            }
                
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                    self.showHome = true
                    
                    
                }) {
                    Text("go home").fontWeight(.bold)
                    
                }.softButtonStyle(Capsule(), pressedEffect: .hard)
                
                if self.showHome {
                    ContentView().environmentObject(offsetKeeper()).environmentObject(walking()).environmentObject(dimensions()).environmentObject(user).onAppear {
                        recur = false
                        
                    }
                }
                
                
                
                Text("\(message)").padding()
                
                
            }.actionSheet(isPresented: $showingSheet) {
                ActionSheet(title: Text("Warning"), message: Text("A group called '" + "\(groupName)" + "' has sent you an invitation to join their group. If you press allow, all members currently in '" +  "\(groupName)" + "' will be able to see your steps, walking speed, and flights climbed"), buttons:
                                [.cancel {self.showingSheet = false}, .default(Text("allow")) {self.permission = true}])
            }.onAppear() {
                
                //second child here will be the groupID linked to creds, set number now for building, also in enterGroup function
                
                print(user.groupID)
                let query = database.child("Groups").child(input).child("groupName").getData() { error, data  in
                    groupName = data?.value as? String ?? "Unknown"

                }
                
                
                
                
                
                
            }
        }
        
    }
    
    func enterGroup() {
        self.database.child("Groups").child(input).child("allowed").updateChildValues([user.UID : "true"])
    }
}




