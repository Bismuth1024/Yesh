//
//  DrinkDataSet.swift
//  Yesh
//
//  Created by Manith Kha on 16/10/2023.
//



/*
 Calculation of BAC is done by approximating a set of differential equations that simplify the process of drinking alcohol.
 
 We consider 3 separate variables, each a function of time:
 
 
alc_in --drunk--> alc_stomach --absorbed--> alc_blood
 
 alc_in: the cumulative number of grams of alcohol ingested.  When a shot is drunk, this variable is immediately incremented like a step function.  When a drink is drunk more slowly, the shape of alc_in is a straight line sloping upwards.
 
 alc_stomach: the number of grams of alcohol in the person's stomach.  For simplicity we assume that as soon as alcohol is consumed it is in the stomach, i.e. d/dt of alc_in and alc_stomach equal initially.  Then, from the stomach alcohol is absorbed into the blood/TBW.  This is a first order process so we add d/dt(alc_stomach) = -k_stomach * alc_stomach.
 
 alc_blood: BAC.  Assuming that alcohol from the stomach goes into TBW we can calculate BAC via ((dose_grams/body_kg)/V_d)/10.  Since alcohol goes from stomach to blood, initially d/dt of alc_blood = -d/dt alc_stomach.  Then alcohol is either eliminated via a zero order process for BAC above 0.015, or first-order below this.
 
 
 
 
 
 
 */



import Foundation

struct DrinkDataSet {
    //Parameters for BAC calculation
    var t_step: Double = Settings.loadCodable(key: "t_step") ?? Settings.Defaults["t_step"] as! Double
    var k_stomach: Double = Settings.loadCodable(key: "k_stomach") ?? Settings.Defaults["k_stomach"] as! Double
    var k_blood: Double = Settings.loadCodable(key: "k_blood") ?? Settings.Defaults["k_blood"] as! Double
    var m_blood: Double = Settings.loadCodable(key: "m_blood") ?? Settings.Defaults["m_blood"] as! Double
    var BACextrapolationTarget: Double = Settings.loadCodable(key: "BACextrapolationTarget") ?? Settings.Defaults["BACextrapolationTarget"] as! Double
    var body_kg: Double = Settings.loadCodable(key: "bodyMass") ?? Settings.Defaults["bodyMass"] as! Double
    var V_d: Double = Settings.loadCodable(key: "vd") ?? Settings.Defaults["vd"] as! Double

    //Time range to iterate over
    var startTime: Date = Date()
    var endTime: Date = Date()
    
    //Arrays to hold values
    var alc_in: [Double] = [] // standards
    var alc_stomach: [Double] = [] // g/kg
    var alc_blood: [Double] = [] // g/dL
    var times: [Date] = [] // Dates
    
    //For plotting
    var scaled_alc_blood: [Double] = []
    
    init() {
        
    }
    
    init(from session: SessionStore) {
        if session.startTime == nil {
            return
        }
        
        //Currently is set to extrapolate 2 hours beyond end of session or last drink of session so far
        startTime = session.startTime!
        if let endTime = session.endTime {
            self.endTime = Date(timeInterval: 7200, since: endTime)
        } else {
            self.endTime = Date(timeInterval: 7200, since: session.latestDrinkTime() ?? session.startTime ?? Date())
        }
        
        //Generate time values
        times = Array(stride(from: self.startTime, through: self.endTime, by: t_step))

        //Zero arrays
        alc_in = Array(repeating: 0, count: getNticks())
        alc_stomach = Array(repeating: 0, count: getNticks())
        alc_blood = Array(repeating: 0, count: getNticks())
        
        
        session.sort()
        for drink in session.drinks {
            if let tEnd = drink.endTime { //If drink has been finished, use it to calculate
                //Get the index of when the drink was started (or shot)
                let startIdx = Int(ceil(drink.startTime.timeIntervalSince(self.startTime) / t_step))
                if drink.startTime == tEnd {
                    //shot, just increase cumulative standards for all future values
                    alc_in.replaceSubrange(startIdx..<alc_in.count, with: alc_in.suffix(from: startIdx).map {$0 + drink.drink.numStandards()})
                } else {
                    //Slow drink, ramp up to plateau for future values
                    let endIdx = Int(ceil(tEnd.timeIntervalSince(self.startTime) / t_step))
                    alc_in.replaceSubrange(endIdx..<alc_in.count, with: alc_in.suffix(from: endIdx).map {$0 + drink.drink.numStandards()})
                    let standardsIncrement = (drink.drink.numStandards() / tEnd.timeIntervalSince(drink.startTime)) * t_step
                    //The following simpler method should work due to pre sorting the drinks
                    var currentIncrement = standardsIncrement
                    for idx in (startIdx+1)..<endIdx {
                        alc_in[idx] = alc_in[idx] + currentIncrement
                        currentIncrement = currentIncrement + standardsIncrement
                    }
                }
            }
        }
        
        updateBAC()
    }
    
    mutating func updateBAC() {
        for idx in 1...(getNticks()-1) {
            let change_alc_in = alc_in[idx] - alc_in[idx - 1] //standards
            
            //Decay stomach alcohol according to a first order process
            let stomach_decay = t_step*k_stomach*alc_stomach[idx - 1] // g/kg
            
            //Also add the drunk alcohol in, remember one standard is 10g ethanol
            let change_alc_stomach = change_alc_in * 10 / body_kg - stomach_decay //g/kg
            alc_stomach[idx] = alc_stomach[idx - 1] + change_alc_stomach;
            
            //Alcohol leaving stomach goes to blood/TBW, convert units using V_d (g/kg -> mg%)
            alc_blood[idx] = alc_blood[idx - 1] + (stomach_decay/V_d)/10;
            
            //Decay linearly for saturated enzyme, decay exponentially for unsaturated
            alc_blood[idx] = alc_blood[idx] - t_step * ((alc_blood[idx - 1] < 0.015) ? k_blood*alc_blood[idx - 1] : m_blood)
        }
        
        //add extension here
        var shouldContinue = true
        
        while shouldContinue {
            extrapolateTick()
            if alc_blood.last! < BACextrapolationTarget {
                shouldContinue = false
            }
        }
        
        //Recalculate the scaled version
        updateScale()
    }
    
    mutating func extrapolateTick() {
        let last_in = alc_in.last!
        let last_stomach = alc_stomach.last!
        let last_blood = alc_blood.last!

        alc_in.append(last_in)
        
        let stomach_decay = t_step*k_stomach*last_stomach // g/kg
        alc_stomach.append(last_stomach - stomach_decay)
                
        alc_blood.append(last_blood + (stomach_decay/V_d)/10 - t_step * ((last_blood < 0.015) ? k_blood*last_blood : m_blood))
        
        times.append(times.last! + t_step)
        endTime += t_step
    }
    
    mutating func updateScale() {
        scaled_alc_blood = alc_blood.map({$0 * scaleFactor()})
    }
    
    func getNticks() -> Int {
        times.count
        //Int(ceil(endTime.timeIntervalSince(startTime) / t_step)) + 1
    }
    
    func maxAlcoholIn() -> Double {
        return alc_in.max() ?? 0.0
    }
    
    func maxBAC() -> Double {
        return alc_blood.max() ?? 0.0
    }
    
    func getStandardsYLimit() -> Double {
        //in case we want a goal etc
        return 1.1 * maxAlcoholIn()
    }
    
    func getBACYLimit() -> Double {
        //in case we want a goal etc
        return 1.1 * maxBAC()
    }
    
    func getStandardsTicks() -> [Double] {
        generateTicks(from: 0.0, through: getStandardsYLimit(), targetCount: 11, tickSpacings: [0.1, 0.2, 0.25, 0.5, 1.0, 1.5, 2.0])
    }
    
    func getXTicks() -> [Date] {
        generateTicks(from: startTime, through: endTime, targetCount: 9, tickSpacings: [600, 900, 1800, 3600, 5400, 7200])
    }
    
    func scaleFactor() -> Double {
        return maxAlcoholIn() / maxBAC()
    }
    
    func getTimeAbove(BAC: Double = 0.05) -> TimeInterval {
        var indices = getCrossingIndices(alc_blood, value: BAC)
        var runningTotal: TimeInterval = 0.0
        
        for i in 0..<(indices.count/2) {
            runningTotal += times[indices[i*2 + 1]].timeIntervalSince(times[indices[i*2]])
        }
        return runningTotal
    }
    

}


