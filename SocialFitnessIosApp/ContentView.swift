//
//  ContentView.swift
//  SocialFitnessIosApp
//
//  Created by Eddie Gabriel on 8/28/22.
//

import SwiftUI
import HealthKit
import HealthKitUI
import Lottie
import UIKit
import Firebase
import FirebaseDatabase



struct ContentView: View {
    
    @State var fitness : main = main()
    @State var ringData : HKActivitySummary = HKActivitySummary()
    @State var ringDataYesterDay : HKActivitySummary = HKActivitySummary()
    @State var elevationData : FlightsClimbed = FlightsClimbed()
    @State var hourlySteps : StepsHourlyInfo = StepsHourlyInfo()
    @EnvironmentObject var offset : offsetKeeper
    @EnvironmentObject var walkingInfo : walking
    @EnvironmentObject var loginCreds : creds
    @State var showSocialView = false
    @State var show = false
    @State var showMenu = false
    @State private var backToLogin = false
    @EnvironmentObject var dimensions : dimensions
    @State var scaleFactor : Double = 1.0
    @State var scooch  = 0
    @State var metric = false
    @State var showGroup = false
    
    
    
    
    
    var body: some View {
        if backToLogin {
            Login()
        }
        else {
            content
            
        }
    }
    var content : some View {
        
        
       
        
        ZStack{
            
           
            
            ZStack {
                
                
                
                Color.Neumorphic.main.edgesIgnoringSafeArea(.all)
                
                
                
                VStack(spacing: dimensions.height / 43) {
                    
            
                    
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: dimensions.width - 50, height: 125)
                        HStack{
                            
                            ZStack{
                                Circle().fill(Color.Neumorphic.main).softOuterShadow().frame(width: 110, height: 110).frame(width:100, height: 100)
                                RingBigView(fitness: fitness, ringInfo: $ringData).frame(width: 45, height: 45)
                            }
                            
                            RingNumbersView(fitness: fitness, ActivitySummary: $ringData).padding()
                            
                            
                            RingNumbersViewYesterday(fitness: fitness, ActivitySummary: $ringDataYesterDay).padding(.leading, 20)
                        }
                    }
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: dimensions.width - 50, height: 160)
                        ElevationView(fitness: fitness, elevationData: elevationData).offset(x: -(((dimensions.width - 50) / 2) - 174))
                        ElevationGraphView(fitness: fitness, localFlightsClimbed: elevationData.getElevationWeekData()).frame(width: 50, height: 20).offset(x: 87 + ((dimensions.width - 50) / 2 ) - 174 , y: 9)
                        
                    }
                    
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: dimensions.width - 50, height: 160)
                        
                        
                        
                        RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: 180, height: 10).offset(y: 27.5)
                        
                        WalkingPerson().frame(width: 20, height: 20).offset(x: -10)
                        
                        StepLengthView(fitness: fitness, metric: $metric).offset(y: 58).offset(x: 0)
                        
                        ZStack {
                            Circle().fill(Color.Neumorphic.main).softOuterShadow().frame(width: 40, height: 40)
                            Text(Image(systemName: "figure.walk")).font(.system(size: 24, design: .rounded)).bold().offset(y: -1)
                        }.offset(x: -144 - (((dimensions.width - 50) / 2) - 174), y: -51)
                        
                        
                        
                        
                        
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            withAnimation {
                                self.show.toggle()
                            }
                            
                        }, label: {Text(Image(systemName: "info")).font(.system(size: 19, design: .rounded)).bold().foregroundColor(.blue)}).softButtonStyle(Circle(), pressedEffect: .hard).offset(x: 140 + ((dimensions.width - 50) / 2 ) - 174 , y: 49)
                        
                    }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow().frame(width: dimensions.width - 50, height: 160)
                        
                        StepsViewHour(fitness : fitness).offset(x: -(((dimensions.width - 50) / 2) - 174))
                        
                        StepGraphHourly(fitness: fitness, localHourStepInfo: hourlySteps.Steps48HrArray).frame(width: 540, height: 160).offset(x: 85 + ((dimensions.width - 50) / 2 ) - 174, y: 0)
                        
                        ZStack{
                            Circle().fill(Color.Neumorphic.main).softOuterShadow().frame(width: 70, height: 70).frame(width:0, height: 0)
                                .offset(x:-73, y:25)
                            DayNightTransition().offset(x: 17 , y: 25)
                        }.offset(x: -(((dimensions.width - 50) / 2) - 174) - 6)
                        
                    }
                    HStack(spacing: 13){
                        
                        
                        
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            self.showGroup = false
                            self.showSocialView = true
                            
                            
                        }) {
                            Text("Rankings ").fontWeight(.bold)
                            + Text(Image(systemName: "chart.bar.fill")).font(.system(size: 20)).bold()
                            
                        }.softButtonStyle(Capsule(), pressedEffect: .hard).sheet(isPresented: $showSocialView, content: {
                            SocialView(metric: $metric)
                        })
                        
                        
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            withAnimation {
                                self.showMenu.toggle()
                            }
                            
                        }, label: {Text(Image(systemName: "line.3.horizontal")).font(.system(size: 19, design: .rounded)).bold().foregroundColor(.gray)}).softButtonStyle(Circle(), pressedEffect: .hard)
                        
                        
                        
                        
                        
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            self.showGroup = true
                            
                            
                        }) {
                            Text("Groups ").fontWeight(.bold)
                            + Text(Image(systemName: "person.3.fill")).font(.system(size: 20)).bold()
                            
                        }.softButtonStyle(Capsule(), pressedEffect: .hard).sheet(isPresented: $showGroup, content: {
                            GroupCreate(metric: $metric)
                        })

                        
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                }.scaleEffect(scaleFactor)
                
                
            }
            
            
            .onAppear() {
                if dimensions.height < 680 {
                    scaleFactor = 0.9
                    scooch = -17
                }
                
                print(loginCreds.email) //works
            }
            if self.show == true {
                VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight)).edgesIgnoringSafeArea(.all)
            }
            if self.show {
                
                GeometryReader { ok in
                    
                    PopUp().position(x: ok.size.width / 2, y: ok.size.height / 2)
                    
                    
                }.background(Color.black.opacity(0.1).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            self.show.toggle()
                        }
                    }
                )
            }
            
            if self.showMenu == true {
                VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight)).edgesIgnoringSafeArea(.all)
            }
            if self.showMenu {
                
                GeometryReader { ok in
                    PopUp2(backToLogin: $backToLogin, metric: $metric).position(x: (ok.size.width / 2), y: (ok.size.height / 2))
                    
                }.background(Color.black.opacity(0.1).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            self.showMenu.toggle()
                        }
                    }
                )
            }
        }
        }
            
    }
        
    
    


struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct RingNumbersView: View {
    
    
    
    @State var fitness : main
    @Binding var ActivitySummary : HKActivitySummary
    
    
    var body: some View {
        let red = Int(ActivitySummary.activeEnergyBurned.doubleValue(for: .largeCalorie()))
        let green = Int(ActivitySummary.appleExerciseTime.doubleValue(for: .minute()))
        let blue = Int(ActivitySummary.appleStandHours.doubleValue(for: .count()))
        let fontSize : CGFloat = 25
        
        VStack {
            Text("\(red)").font(.system(size: fontSize, design: .rounded)).bold().foregroundColor(Color(UIColor(red: 250/255, green: 29/255, blue: 30/255, alpha: 1)))
            
            Text("\(green)").font(.system(size: fontSize, design: .rounded)).bold().foregroundColor(Color(UIColor(red: 100/255, green: 1, blue: 0, alpha: 1)))
            
            Text("\(blue)").font(.system(size: fontSize, design: .rounded)).bold().foregroundColor(Color(UIColor(red: 3/255, green: 255/255, blue: 255/255, alpha: 1)))
        }.onAppear() {
            fitness.makeQuery() { summary in
                ActivitySummary = summary
            }
        }
    }
    
    
}


struct RingNumbersViewYesterday: View {
    
    
    
    @State var fitness : main
    @Binding var ActivitySummary : HKActivitySummary
    
    
    var body: some View {
        let red = Int(ActivitySummary.activeEnergyBurned.doubleValue(for: .largeCalorie()))
        let green = Int(ActivitySummary.appleExerciseTime.doubleValue(for: .minute()))
        let blue = Int(ActivitySummary.appleStandHours.doubleValue(for: .count()))
        let fontSize : CGFloat = 25
        
        HStack{
            VStack {
                Text("\(red)").font(.system(size: fontSize, design: .rounded)).bold().foregroundColor(Color(UIColor(red: 250/255, green: 29/255, blue: 30/255, alpha: 1)))
                
                Text("\(green)").font(.system(size: fontSize, design: .rounded)).bold().foregroundColor(Color(UIColor(red: 100/255, green: 1, blue: 0, alpha: 1)))
                
                Text("\(blue)").font(.system(size: fontSize, design: .rounded)).bold().foregroundColor(Color(UIColor(red: 3/255, green: 255/255, blue: 255/255, alpha: 1)))
                
            }.onAppear(){
                fitness.makeYesterdayQuery() { summary in
                    ActivitySummary = summary
                }
            }
            ZStack{
                Text(Image(systemName: "clock.arrow.circlepath")).font(.system(size: 30)).bold()
            }
            
        }
    }
    
    
}


struct ElevationView : View {
    
    @State var fitness : main
    @ObservedObject var elevationData : FlightsClimbed
    @EnvironmentObject var loginCreds : creds
    @State var showBar: Bool = false
    private let database = Database.database().reference()
    
    var body : some View {
        ZStack {
            
            VStack {
                
                VStack (alignment: .leading){
                    Text("\(Int(elevationData.getFlights()))").font(.system(size: 35, design: .rounded)).bold().foregroundColor(.orange)
                    Text(" in past week").font(.system(size: 13, design: .rounded)).bold()
                }.offset(x:-75, y: -5)
                
                
                ZStack(alignment: .bottom){
                    RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main)
                        .softInnerShadow(RoundedRectangle(cornerRadius: 20), darkShadow: Color.Neumorphic.darkShadow, lightShadow: Color.Neumorphic.lightShadow, spread: 0.3, radius: 2).frame(width: 20, height:90)
                    
                    RoundedRectangle(cornerRadius: 20).fill(.orange)
                        .frame(width: 20, height: showBar ? (elevationData.calculatePercentInt()) : 0)
                    
                }.position(x: 55, y: 33).onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8).delay(0.6)) {
                            showBar = true
                        }
                    }
                }
                
                HStack{
                    
                    VStack(alignment: .leading){
                        Text("\(elevationData.calculatePercent())").bold()
                        
                        Text("\(elevationData.getMonument())").font(.system(size: 12, design: .rounded))
                        
                    }
                        
                        Spacer()
                }.offset(x:75, y:-34)
                
            }
            
            ZStack {
                Circle().fill(Color.Neumorphic.main).softOuterShadow().frame(width: 40, height: 40)
                //LottieView().offset(y: -2)
                Text(Image(systemName: "figure.stairs")).font(.system(size: 22, design: .rounded)).bold().offset(x: 2, y: -1)
            }.position(x: 55, y: 25)
        }.frame(width: 400, height: 150).onAppear() {
            fitness.RecieveFlightsClimbed() { summary in
                    elevationData.flights = summary!.flights
                self.database.child("TotalRankings").child(loginCreds.UID).child("flights").setValue(Int(summary!.flights))
                if self.loginCreds.groupID != 0 {
                    self.database.child("Groups").child(String(self.loginCreds.groupID)).child("members").child(self.loginCreds.UID).child("flights").setValue(Int(summary!.flights))
                }
                    
            }
            
        }
    }
}

struct StepsViewHour : View {
    @State var fitness : main
    @State var total : Int = 0
    @EnvironmentObject var loginCreds : creds
    @EnvironmentObject var dimensions : dimensions
    @State var hrSteps : StepsHourlyInfo = StepsHourlyInfo()
    private let database = Database.database().reference()
    
    var body : some View{
        
            ZStack {
                ZStack{
                    Circle().fill(Color.Neumorphic.main).softOuterShadow().frame(width: 40, height: 40)
                    Text(Image(systemName: "shoeprints.fill")).font(.system(size: 22, design: .rounded)).bold()
                }.offset(x: -50)
                
                
                ZStack{
                    VStack(alignment: .leading){
                        Text("\(total)").font(.system(size: 35, design: .rounded)).bold().foregroundColor(.blue)
                        Text(" in past day").font(.system(size: 13, design: .rounded)).bold()
                        
                    }
                }.offset(x: 24)
            
        }.offset(x: -95, y: -50).onAppear() {
            fitness.RecieveHourlySteps() { summary in
                hrSteps = summary
                total = Int(summary.steps)
                self.database.child("TotalRankings").child(loginCreds.UID).child("steps").setValue(summary.steps)
                
                if self.loginCreds.groupID != 0 {
                    self.database.child("Groups").child(String(self.loginCreds.groupID)).child("members").child(self.loginCreds.UID).child("steps").setValue(summary.steps)
                }
            }
            
            
        }
        
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.colorScheme, .light).previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
    }
}






class main {
    
    let healthstore = HKHealthStore()
    
    var elevationQuery : HKStatisticsCollectionQuery?
    
    var stepHourlyQuery : HKStatisticsCollectionQuery?
    
    var stepLengthQuery : HKStatisticsCollectionQuery?
    
    var walkingSpeedQuery : HKStatisticsCollectionQuery?

    
    
    func authorizeHealthkit() {
        
        
        let allTypes = Set([HKObjectType.activitySummaryType(), HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.flightsClimbed)!, HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!, HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.walkingStepLength)!, HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.walkingSpeed)!])
        
        healthstore.requestAuthorization(toShare: nil, read: allTypes) { (chk, error) in if(chk) {
            print("permission granted")
        }
        }
    }
    
    func makeQuery(completion: @escaping (_ summary : HKActivitySummary) -> ()) {
        
        let calendar = NSCalendar.current
        let endDate = Date()
        
        
        guard let startDate = calendar.date(byAdding: .day, value: 0, to: endDate) else {
            fatalError("error")
        }
        
        let units: Set<Calendar.Component> = [.day, .month, .year, .era]
        
        var startDatecomps = calendar.dateComponents(units, from: startDate)
        startDatecomps.calendar = calendar
        
        var endDatecomps = calendar.dateComponents(units, from: endDate)
        endDatecomps.calendar = calendar
        
        let summariesWithinRange = HKQuery.predicate(forActivitySummariesBetweenStart: startDatecomps, end: endDatecomps)
        
        
        let query = HKActivitySummaryQuery(predicate: summariesWithinRange) {
            (sample, results, error) -> Void in
            if let results = results {
                if results.isEmpty == false {
                    var summary = results[0]
                    completion(summary)
                    
                }
                else {
                    var summaryElse = buildTest()
                    completion(summaryElse)
                }
            }
            
        }
        query.updateHandler = {sample, results, error in
            if let results = results {
                var summary = results[0]
                completion(summary)
            }
            
        }
        
        healthstore.execute(query)
    }
    
    
    func makeYesterdayQuery(completion: @escaping (_ summary : HKActivitySummary) -> ()) {
        
        let calendar = NSCalendar.current
        let endDate = Date()
        
        
        guard let startDate = calendar.date(byAdding: .day, value: -1, to: endDate) else {
            fatalError("error")
        }
        
        let units: Set<Calendar.Component> = [.day, .month, .year, .era]
        
        var startDatecomps = calendar.dateComponents(units, from: startDate)
        startDatecomps.calendar = calendar
        
        var endDatecomps = calendar.dateComponents(units, from: endDate)
        endDatecomps.calendar = calendar
        
        let summariesWithinRange = HKQuery.predicate(forActivitySummariesBetweenStart: startDatecomps, end: endDatecomps)
        
        
        let query = HKActivitySummaryQuery(predicate: summariesWithinRange) {
            (sample, results, error) -> Void in
            if let results = results {
                if results.isEmpty == false {
                    var summary = results[0]
                    completion(summary)
                    
                }
                else {
                    var summaryElse = buildTest()
                    completion(summaryElse)
                }
            }
            
        }
        
        healthstore.execute(query)
    }
    
    
    func makeElevationQuery(completion: @escaping (HKStatisticsCollection?) -> ()) {
        
        let elevationType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.flightsClimbed)!
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -6, to: endDate)
        let components = DateComponents(calendar: calendar, timeZone: calendar.timeZone, hour: 0, minute: 0, second: 0, weekday: 2)
        
        let anchorDate = calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .backward)
        
        let daily = DateComponents(day : 1)
        
        let summariesWithinRange = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictStartDate)
        
        elevationQuery = HKStatisticsCollectionQuery(quantityType: elevationType, quantitySamplePredicate: summariesWithinRange, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: daily)
        
        elevationQuery!.initialResultsHandler = {elevationQuery, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        elevationQuery!.statisticsUpdateHandler = {elevationQuery, statistics, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        healthstore.execute(elevationQuery!)
        
    }
    
    func MakeHourlyStepsQuery(completion: @escaping (HKStatisticsCollection?) -> ()) {
        let type = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .hour, value: -24, to: endDate)
        let components =  DateComponents(calendar: calendar, timeZone: calendar.timeZone, month: nil, day: nil, hour: 0)
        let anchorDate = calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .backward)
        
        let hourly = DateComponents(hour : 1)
        let summariesWithinRange = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictStartDate)
        
        stepHourlyQuery = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: summariesWithinRange, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: hourly)
        
        stepHourlyQuery!.initialResultsHandler = {stepHourlyQuery, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        stepHourlyQuery!.statisticsUpdateHandler = {stepHourlyQuery, statistics, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        healthstore.execute(stepHourlyQuery!)
        
    }
    
    func MakeWalkingSpeedQuery(completion: @escaping (HKStatisticsCollection?) -> ()) {
        let type = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.walkingSpeed)!
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -1, to: endDate)
        let components =  DateComponents(calendar: calendar, timeZone: calendar.timeZone, month: nil, day: nil, hour: 0)
        let anchorDate = calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .backward)
        let daily = DateComponents(day : 1)
        let summariesWithinRange = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictStartDate)
        
        walkingSpeedQuery = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: summariesWithinRange, options: .discreteAverage, anchorDate: anchorDate!, intervalComponents: daily)
        
        walkingSpeedQuery!.initialResultsHandler = {stepLengthQuery, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        walkingSpeedQuery!.statisticsUpdateHandler = {stepLengthQuery, stats, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        healthstore.execute(walkingSpeedQuery!)
    }
    
    func RecieveWalkingSpeed(completion: @escaping (_ summary : String) -> ()) {
        
        var walkingSpeed = 0.0
        self.MakeWalkingSpeedQuery { statisticsCollection in
            if let statisticsCollection = statisticsCollection {
                let startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
                let endDate = Date()
                var keep = []
                statisticsCollection.enumerateStatistics(from: startDate!, to: endDate) {
                    (statistics, stop) in
                    if let length = statistics.averageQuantity()?.doubleValue(for: .meter().unitDivided(by: HKUnit.second())) {
                        keep.append(length)
                    }
                }
                var mid = 0.0
                
                
                    
                    if keep.count == 2 {
                        mid = ((keep.first as! Double) + (keep.last as! Double)) / 2
                    }
                    else {
                        if (keep.first != nil) {
                            mid = keep.first as! Double
                        }
                        
                        
                    }
                
                
                
                let value = mid * 2.237
                let value2 = Double(round(value * 10) / 10)
                completion(self.trailingZeroes(input: value2))
                
            }
        }
    }
    
   
    
    func MakeStepLengthQuery(completion: @escaping (HKStatisticsCollection?) -> ()) {
        let type = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.walkingStepLength)!
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -1, to: endDate)
        let components =  DateComponents(calendar: calendar, timeZone: calendar.timeZone, month: nil, day: nil, hour: 0)
        let anchorDate = calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .backward)
        let daily = DateComponents(day : 1)
        let summariesWithinRange = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictStartDate)
        
        stepLengthQuery = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: summariesWithinRange, options: .discreteAverage, anchorDate: anchorDate!, intervalComponents: daily)
        
        stepLengthQuery!.initialResultsHandler = {stepLengthQuery, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        stepLengthQuery!.statisticsUpdateHandler = {stepLengthQuery, stats, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        healthstore.execute(stepLengthQuery!)
    }
    
    func RecieveHourlySteps(completion: @escaping (_ summary : StepsHourlyInfo) -> ()){
        
        
        var stepsHourInfo = StepsHourlyInfo()
        
        self.MakeHourlyStepsQuery { statisticsCollection in
            if let statisticsCollection = statisticsCollection {
                stepsHourInfo.steps = 0.0
                stepsHourInfo.Steps48HrArray = []
                let startDate = Calendar.current.date(byAdding: .hour, value: -24, to: Date())
                let endDate = Date()
                var index = 0
                statisticsCollection.enumerateStatistics(from: startDate!, to: endDate) {
                    (statistics, stop) in
                    if let step = statistics.sumQuantity()?.doubleValue(for: .count()) {
                        var temp = StepsPerHour(steps: step, date: statistics.startDate, id: index)
                        index += 1
                        stepsHourInfo.Steps48HrArray.append(temp)
                        stepsHourInfo.steps += step
                    }
                    else {
                        
                        var temp2 = StepsPerHour(steps: 0, date: statistics.startDate, id: index)
                        index += 1
                        stepsHourInfo.Steps48HrArray.append(temp2)
                    }
                }
                completion(stepsHourInfo)
            }
        }
        
    }
    
    func RecieveStepLength(completion: @escaping (_ summary : String) -> ()) {
        
        var stepLength = 0.0
        self.MakeStepLengthQuery { statisticsCollection in
            if let statisticsCollection = statisticsCollection {
                let startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
                let endDate = Date()
                var keep = []
                statisticsCollection.enumerateStatistics(from: startDate!, to: endDate) {
                    (statistics, stop) in
                    if let length = statistics.averageQuantity()?.doubleValue(for: .inch()) {
                        keep.append(length)
                    }
                }
                var mid = 0.0
                    if keep.count == 2 {
                        mid = ((keep.first as! Double) + (keep.last as! Double)) / 2
                    }
                    else {
                        if keep.first != nil {
                            mid = keep.first as! Double
                        }
                    }
                
                let value = mid
                let value2 = Double(round(value * 10) / 10)
                completion(self.trailingZeroes(input: value2))
                
            }
        }
    }
    
    func trailingZeroes(input: Double) -> String {
        var x = String(format: "%g", input)
        return x
    }
    
    
    
    func MakeDailyStepsQuery(completion: @escaping (HKStatisticsCollection?) -> ()) {
        let type = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -7, to: endDate)
        let components =  DateComponents(calendar: calendar, timeZone: calendar.timeZone, month: nil, day: nil, hour: 0)
        let anchorDate = calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .backward)
        
        let daily = DateComponents(day : 1)
        let summariesWithinRange = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictStartDate)
        
        stepHourlyQuery = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: summariesWithinRange, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: daily)
        
        stepHourlyQuery!.initialResultsHandler = {stepHourlyQuery, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        stepHourlyQuery!.statisticsUpdateHandler = {stepHourlyQuery, statistics, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        healthstore.execute(stepHourlyQuery!)
        
    }
    
    
    func RecieveDailySteps(completion: @escaping (_ summary : StepsDailyInfo) -> ()){
        
        var stepsDayInfo = StepsDailyInfo()
        
        self.MakeDailyStepsQuery { statisticsCollection in
            if let statisticsCollection = statisticsCollection {
                stepsDayInfo.steps = 0.0
                stepsDayInfo.Steps7DayArray = []
                let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
                let endDate = Date()
                statisticsCollection.enumerateStatistics(from: startDate!, to: endDate) {
                    (statistics, stop) in
                    if let step = statistics.sumQuantity()?.doubleValue(for: .count()) {
                        var temp = StepsPerDay(steps: step, date: statistics.startDate)
                        stepsDayInfo.Steps7DayArray.append(temp)
                        stepsDayInfo.steps += step
                        if step >= 10000 {
                            stepsDayInfo.healthyDays += 1
                        }
                    }
                    else {
                        
                        var temp2 = StepsPerDay(steps: 0, date: statistics.startDate)
                        stepsDayInfo.Steps7DayArray.append(temp2)
                    }
                }
                completion(stepsDayInfo)
            }
        }
        
    }
    
    
    
    func RecieveFlightsClimbed(completion: @escaping (_ summary : FlightsClimbed?) -> ()) {
        
        var flightsClimbed = FlightsClimbed()
        
        
        self.makeElevationQuery { statisticsCollection in
            if let statisticsCollection = statisticsCollection {
                flightsClimbed.resetFlights()
                flightsClimbed.ElevationWeekStats = [] //IMPORTANT FOR RESETTING GRAPH ON UPDATES
                let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())
                let endDate = Date()
                statisticsCollection.enumerateStatistics(from: startDate!, to: endDate) {
                    (statistics, stop) in
                    
                    if let count = statistics.sumQuantity()?.doubleValue(for: .count()) {
                        
                        var temp = FlightsPerDay(flights: count, date: statistics.startDate)
                        flightsClimbed.ElevationWeekStats.append(temp)
                        
                        flightsClimbed.updateFlights(newFlights: count)
                    }
                    else {
                        var temp2 = FlightsPerDay(flights: 0, date: statistics.startDate)
                        flightsClimbed.ElevationWeekStats.append(temp2)
                        
                    }
                }
                completion(flightsClimbed)
            }
            else {
                for _ in 1...7 {
                    var temp3 = FlightsPerDay(flights: 0, date: Date())
                    flightsClimbed.ElevationWeekStats.append(temp3)
                }
                completion(flightsClimbed)
            }
        }
    }
    
    
    
}



func buildTest() -> HKActivitySummary {
    
    let test = HKActivitySummary()
    test.activeEnergyBurned = HKQuantity(unit: .largeCalorie(), doubleValue: 0)
    test.activeEnergyBurnedGoal = HKQuantity(unit: .largeCalorie(), doubleValue: 0)
    test.appleExerciseTime = HKQuantity(unit: .minute(), doubleValue: 0)
    test.appleExerciseTimeGoal = HKQuantity(unit: .minute(), doubleValue: 0)
    test.appleStandHours = HKQuantity(unit: .count(), doubleValue: 0)
    test.appleStandHoursGoal = HKQuantity(unit: .count(), doubleValue: 0)
    return test
    
}

struct LotteView2 : UIViewRepresentable {
    
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView()
        let animationView = AnimationView()
        animationView.animation = Animation.named("stairFigure1")
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.play()
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.6
        animationView.backgroundBehavior = .pauseAndRestore
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([animationView.widthAnchor.constraint(equalTo: view.widthAnchor), animationView.heightAnchor.constraint(equalTo: view.heightAnchor)])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

struct LottieView : View {
    
    var body : some View {
        VStack{
            LotteView2().frame(width: 75, height: 75)
        }
    }
    
}





