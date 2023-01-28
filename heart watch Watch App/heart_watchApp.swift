//
//  heart_watchApp.swift
//  heart watch Watch App
//
//  Created by Eddie Gabriel on 11/23/22.
//

import SwiftUI

@main
struct heart_watch_Watch_AppApp: App {
    
    @StateObject private var workoutManager = WorkoutManager()
    
    var body: some Scene {
        WindowGroup {
            watchView().environmentObject(workoutManager)
        }
    }
}
