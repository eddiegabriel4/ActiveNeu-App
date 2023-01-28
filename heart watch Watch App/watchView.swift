//
//  ContentView.swift
//  heart watch Watch App
//
//  Created by Eddie Gabriel on 11/23/22.
//

import SwiftUI
import HealthKit

struct watchView: View {
    
    @EnvironmentObject var workoutManager: WorkoutManager
    @State var disabledInput : Bool = false

    
    //-------------------------
    
    @StateObject var heartBridge = HeartRateObject()
    
    //--------------------------
    
    
    var body: some View {
        VStack {
            
            //button will start workout, on_change modifier for watchView will report hr changes
            Button(action: {
                workoutManager.startWorkout()
                disabledInput = true
                
            }) {
                Label("start", systemImage: "heart.fill").foregroundColor(.green)
            }.padding().disabled(disabledInput)
            
            //area to display live heartrate
            Text(heartBridge.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
            
            Button(action: {
                disabledInput = false
                heartBridge.updateHeartRate(newHR: 0.0)
                workoutManager.endWorkout()
                
            }) {
                Label("end", systemImage: "xmark").foregroundColor(.red)}
            
            
        //when hr is updated, send it to shared session
        }.onChange(of: workoutManager.heartRate) { newVal in
            heartBridge.updateHeartRate(newHR: newVal)
        }
            
            .padding().onAppear() {
            
            workoutManager.requestAuthorization()
            
        }
        
        
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        watchView()
    }
}
