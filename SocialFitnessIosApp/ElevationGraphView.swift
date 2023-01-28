//
//  ElevationGraphView.swift
//  SocialFitnessIosApp
//
//  Created by Eddie Gabriel on 8/28/22.
//

import Foundation
import SwiftUI
import HealthKit
import Neumorphic

struct ElevationGraphView : View {
    
    @State var fitness : main
    @State var localFlightsClimbed : Array<FlightsPerDay>
    @State var totalFlights : Double = 0.0
    @State var maximum : Double = 0.0
    
    var body : some View {
        
        let data: [FlightsPerDay] = localFlightsClimbed
        
        Text("Last 7 days").font(.system(size: 15, design: .rounded)).bold().foregroundColor(.gray).offset(x: -36, y: -75).fixedSize(horizontal: true, vertical: false)
        HStack(spacing: 6){
            
            ForEach(data) { item in
                    
                    ZStack(alignment: .bottom){
                        RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main)
                            
                            .frame(width: 16, height:120)
                        
                        ZStack(alignment: .bottom) {
                            
                            RoundedRectangle(cornerRadius: 20).fill(.orange)
                                .frame(width: 16, height: item.animate ? ((item.flights) * (getRatio(max: maximum))) : 0)
                            
                                Text("\(item.getFlightsAsInt())").font(.system(size: 10, design: .rounded)).foregroundColor(.black).bold().offset(y: -4)
                            
                            
                        }
                    }
                    
                }
            }.onAppear() {
                fitness.RecieveFlightsClimbed() { summary in
                    localFlightsClimbed = summary!.getElevationWeekData()
                        totalFlights = summary!.flights
                        maximum = localFlightsClimbed.map{$0.flights}.max()!
                    for (index,_) in localFlightsClimbed.enumerated() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                            withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.8))  {
                                localFlightsClimbed[index].animate = true
                            }
                        }
                    }
                    
                }
                
            }
        
    }
}

struct FlightsPerDay : Identifiable {
    
    var flights : Double
    
    var date : Date
    
    var id = UUID()
    
    var animate : Bool = false
    
    func getFlightsAsInt() -> Int {
        return Int(self.flights)
    }
    
}


class FlightsClimbed : ObservableObject {
    
    @Published var flights : Double
    @Published var ElevationWeekStats : Array<FlightsPerDay>
    
    init() {
        self.flights = 0.0
        self.ElevationWeekStats = []
    }
    
    func resetFlights() {
        self.flights = 0.0
    }
    
    func getFlights() -> Double {
        return self.flights
    }
    
    func updateFlights(newFlights : Double) {
        self.flights += newFlights
    }
    
    func calculatePercent() -> String {
        let flights = self.flights
        
        if flights <= 18 && flights > 0 {
            let percent = ((flights * 10) / 186.0) * 100
            return String(round(100 * percent) / 100.0) + "%"
            
        }
        if flights <= 44 && flights > 18{
            let percent = ((flights * 10) / 450.0) * 100
            return String(round(100 * percent) / 100.0) + "%"
            
        }
        if flights <= 105 && flights > 44 {
            let percent = ((flights * 10) / 1063.0) * 100
            return String(round(100 * percent) / 100.0) + "%"
            
        }
        if flights <= 271 && flights > 105 {
            let percent = ((flights * 10) / 2722.0) * 100
            return String(round(100 * percent) / 100.0) + "%"
        }
        else {
            let percent = ((flights * 10) / 29032.0) * 100
            return String(round(100 * percent) / 100.0) + "%"
        }
    }
    
    func calculatePercentInt() -> CGFloat {
        let flights = self.flights
        
        if flights <= 18 && flights > 0 {
            let percent = ((flights * 10) / 186.0) * 100
            return CGFloat(round(100 * percent) / 100.0)
            
        }
        if flights <= 44 && flights > 18{
            let percent = ((flights * 10) / 450.0) * 100
            return CGFloat(round(100 * percent) / 100.0)
            
        }
        if flights <= 105 && flights > 44 {
            let percent = ((flights * 10) / 1063.0) * 100
            return CGFloat(round(100 * percent) / 100.0)
            
        }
        if flights <= 271 && flights > 105 {
            let percent = ((flights * 10) / 2722.0) * 100
            return CGFloat(round(100 * percent) / 100.0)
        }
        else {
            let percent = ((flights * 10) / 29032.0) * 100
            return CGFloat(round(100 * percent) / 100.0)
        }
    }
    
    
    func getMonument() -> String {
        let flights = self.flights
        
        if flights <= 18 && flights > 0 {
        
            return String("Leaning Twr of Pisa")
            
        }
        if flights <= 44 && flights > 18{
            
            return String("Great Pyramid")
            
        }
        if flights <= 105 && flights > 44 {
            
            return String("Eiffel Tower")
            
        }
        if flights <= 271 && flights > 105 {
            
            return String("Burj Khalifa")
        }
        else {

            return String("Mt. Everest")
        }
        
    }
    
    func getElevationWeekData() -> Array<FlightsPerDay> {
        return self.ElevationWeekStats
    }
    
}

func getRatio(max : Double) -> Double {
    
    let barHeight = 100.0
    let ratio = barHeight / max
    return ratio
}


extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}


