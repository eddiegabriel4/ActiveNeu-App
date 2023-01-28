//
//  heart.swift
//  SocialFitnessIosApp
//
//  Created by Eddie Gabriel on 11/23/22.
//


import Combine
import WatchConnectivity
import HealthKit

final class HeartRateObject: ObservableObject {
    var session: WCSession
    let delegate: WCSessionDelegate
    let subject = PassthroughSubject<Double, Never>()
    
    
    @Published private(set) var heartRate : Double = Double(0)
    
    init(session: WCSession = .default) {
        self.delegate = SessionDelegater(countSubject: subject)
        self.session = session
        self.session.delegate = self.delegate
        self.session.activate()
        
        subject
            .receive(on: DispatchQueue.main)
            .assign(to: &$heartRate)
    }
    
    //function(s) below will be used by button on watch to start up workout session, get heartrate, and send it, session.send message will be in update handler maybe? trust you can do this. in ios and watchos content view, youll create the object in this file, ios will use just property (ex heartRate here) so view is updated on update from watch. watch will have button activating a function below. func will start hk workoutsession, get live heartrate data, and send message on each update. watch should have button to end session maybe?
    
    
    //these aren't needed, were just references
//    func increment() {
//        heartRate += 1
//        session.sendMessage(["count": heartRate], replyHandler: nil) { error in
//            print(error.localizedDescription)
//        }
//    }
//
//    func decrement() {
//        heartRate -= 1
//        session.sendMessage(["count": heartRate], replyHandler: nil) { error in
//            print(error.localizedDescription)
//        }
//    }
    
    //this will simply update the heart rate then use the send func in heartConnect.swift to update val for iOS
    //this will prob be used when hr is changed in watchView if that works
    func updateHeartRate(newHR: Double) {
        
        //print(newHR)
        heartRate = newHR
        session.sendMessage(["HR" : heartRate], replyHandler: nil) { error in
            print("there was an error in sending HR to iPhone")
        }
        
    }
}
