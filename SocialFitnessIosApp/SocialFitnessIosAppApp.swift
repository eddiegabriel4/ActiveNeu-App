//
//  SocialFitnessIosAppApp.swift
//  SocialFitnessIosApp
//
//  Created by Eddie Gabriel on 8/28/22.
//

import SwiftUI
import Firebase

@main
struct SocialFitnessIosAppApp: App {
    
    @State var group = false
    @State var information : creds = creds()
    @State var URL : String = ""
    
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if group == false {
                Login().environmentObject(information).onOpenURL { url in
                    URL = url.lastPathComponent
                    Auth.auth().addStateDidChangeListener { auth, user in
                        if let user {
                            information.UID = user.uid
                        }
                    }
                    group = true
                }
            }
            else {
                GroupSetUpView(input: URL, recur : $group).environmentObject(information).onAppear {
                    print(URL)
                }
            }
        }
    }
}
