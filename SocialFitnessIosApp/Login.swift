//
//  Login.swift
//  SocialFitnessIosApp
//
//  Created by Eddie Gabriel on 9/21/22.
//

import Foundation
import SwiftUI
import HealthKit
import Neumorphic
import Firebase
import FirebaseDatabase

struct Login : View {
    
    @State var email = ""
    @State var password = ""
    @State var login = false
    @EnvironmentObject var loginCreds : creds
    @State var errorMsg = ""
    @FocusState private var keyboard : Bool
    private let database = Database.database().reference()
    @State var fitness : main = main()
    @Environment(\.openURL) var openURL
    
    var body : some View {
        if login {
            ContentView().environmentObject(offsetKeeper()).environmentObject(walking()).environmentObject(dimensions())
            
        }
        else {
            content
        }
    }
        
        var content: some View {
            ZStack {
                Color.Neumorphic.main.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 15){
                    
                    Loading().frame(width: 180, height: 180)
                    
                    HStack { //email
                        Text(Image(systemName: "envelope")).foregroundColor(Color.Neumorphic.secondary).font(Font.body.weight(.bold))
                        TextField("Email", text: $email).autocapitalization(.none).foregroundColor(Color.Neumorphic.secondary).font(.system(size: 18, design: .rounded)).focused($keyboard)
                    }.offset(x: 43)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 30).fill(Color.Neumorphic.main)
                                .softInnerShadow(RoundedRectangle(cornerRadius: 30), darkShadow: Color.Neumorphic.darkShadow, lightShadow: Color.Neumorphic.lightShadow, spread: 0.5, radius: 2).frame(width: 340)
                        )
                    
                    HStack { //password
                        Text(Image(systemName: "key")).foregroundColor(Color.Neumorphic.secondary).font(Font.body.weight(.bold))
                        SecureField("Password", text: $password).autocapitalization(.none).foregroundColor(Color.Neumorphic.secondary).focused($keyboard).font(.system(size: 18, design: .rounded))
                    }.offset(x: 43)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 30).fill(Color.Neumorphic.main)
                                .softInnerShadow(RoundedRectangle(cornerRadius: 30), darkShadow: Color.Neumorphic.darkShadow, lightShadow: Color.Neumorphic.lightShadow, spread: 0.5, radius: 2).frame(width: 340)
                        )
                    
                    
                    VStack(spacing: 33){ // sign up
                        
                        Button(action: {
                            
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            keyboard = false
                            loginCreds.email = email
                            register()
                            
                        }) {
                            Text("Sign up").fontWeight(.bold)
                        }
                        .softButtonStyle(RoundedRectangle(cornerRadius: 20))
                        
                    
                    
                     // login
                        
                        Button(action: {
                            
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            keyboard = false
                            loginCreds.email = email
                            loginFunc()
                            
                        }) {
                            Text("Login").fontWeight(.bold)
                        }
                        .softButtonStyle(RoundedRectangle(cornerRadius: 20))
                        
                        
                        
                    }.padding()
                    
                    
                    
                    
                    
                }.offset(y: -40).onAppear {
                    fitness.authorizeHealthkit()
                    Auth.auth().addStateDidChangeListener { auth, user in
                        if user != nil {
                            loginCreds.UID = user!.uid
                            let object : [String : Double] = [
                                "flights" : 0.0,
                                "steps"   : 0.0,
                                "speed"   : 0.0
                            ]
                            
                            self.database.child("TotalRankings").child(loginCreds.UID).setValue(object)
                            login.toggle()
                        }
                    }
                }
                Text(errorMsg).font(.system(size: 15, design: .rounded)).offset(y: 230)
                VStack{
                    
                    Button(action: {
                        
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        openURL(URL(string: "https://activeneu.weebly.com/")!)
                        
                    }) {
                        Text("Privacy Policy").fontWeight(.bold)
                    }
                    .softButtonStyle(RoundedRectangle(cornerRadius: 20))
                    
                    
                }.offset(y: 280)
                
            }
            
           
        
        
    }
    
    func register() {
        // tracking prompt here? if no then dont create account and toggle login
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                errorMsg = error!.localizedDescription
                print(error!.localizedDescription)
            }
        }
        
    }
    
    func loginFunc() {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard self != nil else { return }
            if error != nil {
                errorMsg = error!.localizedDescription
                print(error!.localizedDescription)
            }
        }
    }
}







struct Login_Preview : PreviewProvider {
    static var previews: some View {

        Login().previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max")).environment(\.colorScheme, .light)
    }
}


class creds : ObservableObject {
    
    @Published var UID : String
    @Published var email : String
    @Published var groupID : Int
    
    init() {
        self.UID = ""
        self.email = ""
        self.groupID = UserDefaults.standard.integer(forKey: "GroupID")
    }
}



class dimensions : ObservableObject {
    
    @Published var width : CGFloat
    @Published var height : CGFloat
    
    init () {
        self.width = UIScreen.main.bounds.width
        self.height = UIScreen.main.bounds.height
    }
}
