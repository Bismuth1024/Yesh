//
//  StatRecords.swift
//  Yesh
//
//  Created by Manith Kha on 2/2/2024.
//
/*
 I want to be able to define a list of stats.
 
 Each should have:
 a name
 a method for combining them over a period (e.g. total standards should add up, but peak BAC should keep the highest)
 a method for choosing the "best" one for a record (e.g. time above 0.05 should pick highest, but time to peak should pick lowest)
 
 ideally the name should be a key for a dictionary, the dictionary values are the other two methods
 
 
 
 method for getting from summary stats of a session
 
 then object containing
    -combine
    -choose best
 
 
 We use dictionaries to keep track of records by ingredient/drink - we can make cool pie charts
 
 Ingredient/volume dictionary
 Ingredient/standards dictionary
 
 Drink/volume dictionary
 Drink/standards dictionary
 
 The methods for filling these dictionaries up are handled here to not bloat the SummaryStats class.  Is this the right choice?
 I dunno
 
 Eventually we can ask stuff like "in what session did i drink the most volume of vodka" but ill add support for that to be called
 when required, rather than automatically calculated for everything
 
*/

import Foundation

struct StatRecords : Codable {
    
    enum ReplacementMethod : Codable {
        case max
        case min
    }
    
    static func getComparator(_ method: ReplacementMethod) -> (Double, Double) -> Bool {
        switch method {
        case .max:
            return {$0 > $1}
        case .min:
            return {$0 < $1}
        default:
            return {$0 > $1}
        }
    }
    
    //This is so we have scope for minimum values as well or other custom "best record" types
    struct DatedStatistic : Codable {
        var value: Double = 0.0
        var time: Date = Date()
        var replacementMethod: ReplacementMethod = .max
        
        mutating func compareWith(newValue: Double, at newTime: Date) {
            if getComparator(replacementMethod)(newValue, value) {
                value = newValue
                time = newTime
            }
        }
    }
    
    static let statNames = ["Total Standards", "Total Sugar", "Total Volume", "Peak BAC", "Time above 0.05 BAC", "Duration"]
    
    init() {
        
    }
    
    init(startTime: Date, endTime: Date) {
        self.startTime = startTime
        self.endTime = endTime
    }
    
    static var AllTimeRecords = StatRecords(startTime: Date.distantPast, endTime: Date.distantFuture)
    static var OneYearRecords = StatRecords(startTime: Date.now, endTime: Date.init(timeIntervalSinceNow: 0))
    
    
    
    var addedSessions: Set<Date> = []
    
    var startTime : Date = Date()
    var endTime : Date = Date()
    
    var nSessions: Int = 0 //can be sessions, weeks, etc. see TimePeriod below
    
    var totalSugar: Double = 0.0
    var totalStandards: Double = 0.0
    var totalVolume: Double = 0.0
    var totalTimeAbove: TimeInterval = 0.0
    var totalPeakBAC: Double = 0.0 //Just so we can calculate the average peak BAC
    var totalDuration: TimeInterval = 0.0
    
    //Max in one session with the time (of the session) that it happened
    var maxSugar = DatedStatistic()
    var maxStandards = DatedStatistic()
    var maxVolume = DatedStatistic()
    var maxBAC = DatedStatistic()
    var maxTimeAbove = DatedStatistic()
    var maxDuration = DatedStatistic()
    
    //Averages per period
    var averageSugar : Double {
        totalSugar/Double(max(nSessions, 1))
    }
    var averageStandards : Double {
        totalStandards/Double(max(nSessions, 1))
    }
    var averageVolume : Double {
        totalVolume/Double(max(nSessions, 1))
    }
    var averageTimeAbove : TimeInterval {
        totalTimeAbove/Double(max(nSessions, 1))
    }
    var averagePeakBAC : Double {
        totalPeakBAC/Double(max(nSessions, 1))
    }
    var averageDuration : Double {
        totalDuration/Double(max(nSessions, 1))
    }
    
    var IngredientsVolumeDictionary: Dictionary<String, Double> = [:]
    var IngredientsStandardsDictionary: Dictionary<String, Double> = [:]
    var DrinkVolumeDictionary: Dictionary<String, Double> = [:]
    var DrinkStandardsDictionary: Dictionary<String, Double> = [:]
    
    mutating func append(_ session: SessionStore) {
        //Check session is valid
        guard let sessionStart = session.startTime else {return}
        //Check it's in the range
        guard (startTime...endTime).contains(sessionStart) else {return}
        
        if addedSessions.contains(sessionStart) {return}
                
        let stats = SummaryStats(from: session)
        
        totalStandards += stats.totalStandards
        totalSugar += stats.totalSugar
        totalVolume += stats.totalVolume
        totalTimeAbove += stats.timeAbove005
        totalPeakBAC += stats.peakBAC
        totalDuration += stats.duration

        maxSugar.compareWith(newValue: stats.totalSugar, at: sessionStart)
        maxStandards.compareWith(newValue: stats.totalStandards, at: sessionStart)
        maxVolume.compareWith(newValue: stats.totalVolume, at: sessionStart)
        maxBAC.compareWith(newValue: stats.peakBAC, at: sessionStart)
        maxTimeAbove.compareWith(newValue: stats.timeAbove005, at: sessionStart)
        maxDuration.compareWith(newValue: stats.duration, at: sessionStart)

        
        for wrapper in session.drinks {
            let drink = wrapper.drink
            DrinkVolumeDictionary.accumulateInsert(key: drink.name, value: drink.totalVolume())
            DrinkStandardsDictionary.accumulateInsert(key: drink.name, value: drink.numStandards())
            for iWrapper in drink.ingredients {
                let ingredient = iWrapper.ingredientType
                if ingredient.ABV < 0.1 {continue}
                IngredientsVolumeDictionary.accumulateInsert(key: ingredient.name, value: iWrapper.volume)
                IngredientsStandardsDictionary.accumulateInsert(key: ingredient.name, value: iWrapper.numStandards())
            }
            
        }
        
        nSessions += 1
        addedSessions.insert(sessionStart)

    }
    
    
    //This enum is to choose the way in which a StatRecords instance calculates records.  The struct always looks from startTime
    //To endTime, but it can be used to find the best values in one {session, week, month, year} within that time.
    enum TimePeriod {
        case session, week, month, year
    }
    
    mutating func autoCalculate() {
        var filenames = getLogFileNames()
        filenames = filenames.filter {name in
            (startTime...endTime).contains(SessionStore.FilenameFormatter.date(from: name) ?? Date())
        }
        
        let tempSession = SessionStore()
        for name in filenames {
            tempSession.loadFromFile(fileURL: sessionLogsURL().appending(path: name))
            append(tempSession)
        }
    }
    
    static func findBestWeek(startTime: Date, endTime: Date) {
        var weekStartDays = DateHelpers.getFirstsOf(.weekday, startTime: startTime, endTime: endTime, includeEarlier: true)
        var startIdx = 0
        var endIdx = 1
        
        //var currentBest =
        while endIdx < weekStartDays.count {
            let newSummary = StatRecords(startTime: weekStartDays[startIdx], endTime: weekStartDays[endIdx])
        }
    }
}

extension Dictionary where Value == Double, Key == String {
    mutating func accumulateInsert(key: String, value: Double) {
        /*
        if let currentValue = self[key] {
            self[key] = currentValue + value
        } else {
            self[key] = value
        }
         */
        self[key] = self[key] ?? 0.0 + value
    }
}
