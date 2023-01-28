//
//  BottomPopUp.swift
//  SocialFitnessIosApp
//
//  Created by Eddie Gabriel on 9/21/22.
//

import SwiftUI
import Neumorphic
import Foundation
import Firebase
import FirebaseDatabase


struct PopUp : View {
    
    
    
    var body : some View {
        
        VStack {
            Text(Image(systemName: "info")).font(.system(size: 30, design: .rounded)).foregroundColor(.blue).bold()
            Text("Actual step rate animated").font(.system(size: 20, design: .rounded))
            Text("based on today's data").font(.system(size: 20, design: .rounded))
            
            
            
            
        }.padding().background(Color.Neumorphic.main).cornerRadius(30)
         
    }
}


struct PopUp2 : View {
    
    @Binding var backToLogin : Bool
    @Binding var metric : Bool
    @EnvironmentObject var loginCreds : creds  // not sure if information is carried over
    
    
    var body : some View {
        
        VStack(spacing: 20) {
            
            
            Button(action: {    //do offset
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    Login().login = false
                    backToLogin = true
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
                
                
                
            }) {
                Text("Log out ").fontWeight(.bold)
                + Text(Image(systemName: "door.left.hand.open")).font(.system(size: 20)).bold()
                
            }.softButtonStyle(Capsule(), pressedEffect: .hard)
            
            
            Button(action: {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                self.metric.toggle()
                
                
            }) {
                if self.metric == false{
                    Text("Units: Imperial").fontWeight(.bold)
                    
                }
                if self.metric {
                    Text("Units: Metric").fontWeight(.bold)
                }
                
            }.softButtonStyle(Capsule(), pressedEffect: .hard)
            
            
            Button(action: {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                let user = Auth.auth().currentUser
                let firebaseAuth = Auth.auth()
                let database = Database.database().reference()
                do {
                    user?.delete { error in
                        if let error = error {
                            
                        }
                        else {
                            print("account deleted")
                        }
                    }
                    database.child("TotalRankings").child(loginCreds.UID).removeValue()
                    try firebaseAuth.signOut()
                    Login().login = false
                    backToLogin = true
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
                
                
                
            }) {
                Text("Delete account ").fontWeight(.bold)
                + Text(Image(systemName: "trash.fill")).font(.system(size: 20)).bold()
                
            }.softButtonStyle(Capsule(), pressedEffect: .hard)
           
            
            
            
            
            
            
            
        }.padding(30).background(Color.Neumorphic.main).cornerRadius(30)
         
    }
}





