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
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Login().environmentObject(creds())
        }
    }
}
