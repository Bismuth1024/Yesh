//
//  SummaryStats.swift
//  Yesh
//
//  Created by Manith Kha on 23/1/2024.
//

/*
 Duration
 Total standards
 Total sugar
 Total volume drunk (any drink)
 Peak BAC
 Total time above 0.05 BAC
 
 This SummaryStats struct should only hold the summary stats of a single session.  The separate StatRecords struct is for multiple -
 e.g. total standards in a period, highest BAC, longest duration of one session and so on.
 
 I want to add support for badges and shit like "Lifetime 10L of vodka drunk" and so on.  This means I need to keep track of
 
 totals per ingredient - standards or volume?
 totals per drink - standards or volume or count?
 maybe we need all, since you can have different ABVs and sizes and so on?
 
 For further discussion see StatRecords
 
 It's probably not worthwile to do this at the single session level - imagine saying "you had 2 negronis" like no shit bro
 */


import Foundation

/*
protocol Statistic {
    associatedtype T
    func combine(_ v1: T,_ v2: T) -> T
    func chooseBest(_ current: T,_ new: T) -> T
}
 */

struct SummaryStats {
    
    //var StatsDictionary : Dictionary<String, Any> = [:]
    
    var startTime: Date = Date()
    var endTime: Date = Date()
    
    var totalStandards: Double = 0.0
    var totalSugar: Double = 0.0
    var totalVolume: Double = 500.0
    var peakBAC: Double = 0.02
    var timeAbove005: Double = 0.0
    var VolumeDictionary = Dictionary<String, Double>()
    var StandardsDictionary = Dictionary<String, Double>()

    static let statNames = ["Total Standards", "Total Sugar", "Total Volume", "Peak BAC", "Time above 0.05 BAC", "Duration"]
    
    init() {
        
    }
    
    init(from Session: SessionStore) {
        startTime = Session.startTime ?? Date()
        endTime = Session.endTime ?? Date()
        totalStandards = Session.totalStandards()
        totalSugar = Session.totalSugar()
        totalVolume = Session.totalVolume()
        duration = endTime.timeIntervalSince(startTime)

        let DataSet = DrinkDataSet(from: Session)
        peakBAC = DataSet.maxBAC()
        timeAbove005 = DataSet.getTimeAbove()
    }
    
    var duration : TimeInterval = 0.0
    
    /*
    func combinedWith(_ other: SummaryStats) -> SummaryStats {
        var toReturn = SummaryStats()
        
        /*
        for (key, val) in StatsDictionary {
            if let otherVal = other.StatsDictionary[key] {
                let obj = SummaryStats.SuperDictionary[key]!
               // toReturn.StatsDictionary[key] = obj.combine(val, otherVal)
            }
        }
         */
        
        
        
        toReturn.nSessions = nSessions + other.nSessions
        toReturn.totalSugar = totalSugar + other.totalSugar
        toReturn.totalStandards = totalStandards + other.totalStandards
        toReturn.totalVolume = totalVolume + other.totalVolume
        toReturn.timeAbove005 = timeAbove005 + other.timeAbove005
        toReturn.startTime = DateHelpers.earliest(startTime, other.startTime)
        toReturn.endTime = DateHelpers.latest(endTime, other.endTime)
        toReturn.peakBAC = max(peakBAC, other.peakBAC)

        toReturn.VolumeDictionary = VolumeDictionary.merging(other.VolumeDictionary) {current, new in
            current + new
        }
        
        toReturn.StandardsDictionary = StandardsDictionary.merging(other.StandardsDictionary) {current, new in
            current + new
        }
        
        return toReturn
    }
     */
    
    //I may update records with a more extensible format - e.g. scope for records where the lowest value is the best, or even custom comparable types, and so on
    static var Records = SummaryStats() //All time records in one session - stored as a summarystats for convenience, although they don't necesarrily come from the same session
    
    static var RecordTimes : [String : Date] = [:] //For each record name eg total standards, contains the start time of the session where it was set
    
    static func updateRecords(using session: SessionStore) {
        let stats = SummaryStats(from: session)
        
        if stats.totalSugar > Records.totalSugar {
            Records.totalSugar = stats.totalSugar
            RecordTimes["Total Sugar"] = stats.startTime
        }
        
        if stats.totalStandards > Records.totalStandards {
            Records.totalStandards = stats.totalStandards
            RecordTimes["Total Standards"] = stats.startTime
        }
        
        if stats.totalVolume > Records.totalVolume {
            Records.totalVolume = stats.totalVolume
            RecordTimes["Total Volume"] = stats.startTime
        }
        
        if stats.peakBAC > Records.peakBAC {
            Records.peakBAC = stats.peakBAC
            RecordTimes["Peak BAC"] = stats.startTime
        }
        
        if stats.timeAbove005 > Records.timeAbove005 {
            Records.timeAbove005 = stats.timeAbove005
            RecordTimes["Time above 0.05 BAC"] = stats.startTime
        }
        
        if stats.duration > Records.duration {
            Records.duration = stats.duration
            RecordTimes["Duration"] = stats.startTime
        }
    }
    
    /*
    struct BasicStat : Statistic {
        func combine(_ v1: Double,_ v2: Double) -> Double {
            return v1 + v2
        }
        func chooseBest(_ current: Double,_ new: Double) -> Double {
            return max(current, new)
        }
    }

    /*
    struct AverageStat : Statistic {
        var count: Int = 0
        func combine(_ v1: Double,_ v2: Double) -> Double {
            return v1 + v2
        }
        func chooseBest(_ current: Double,_ new: Double) -> Double {
            return max(current, new)
        }
    }
     */
    
    struct MaxStat : Statistic {
        func combine(_ v1: Double,_ v2: Double) -> Double {
            return max(v1, v2)
        }
        func chooseBest(_ current: Double,_ new: Double) -> Double {
            return max(current, new)
        }
    }
    
    struct MinStat : Statistic {
        func combine(_ v1: Double,_ v2: Double) -> Double {
            return min(v1, v2)
        }
        func chooseBest(_ current: Double,_ new: Double) -> Double {
            return min(current, new)
        }
    }
    
    struct DictionaryStat : Statistic {
        typealias Dict = Dictionary<String, Double>
        
        func combine(_ v1: Dict, _ v2: Dict) -> Dict {
            v1.merging(v2) {current, new in
                current + new
            }
        }
        
        func chooseBest(_ current: Dict, _ new: Dict) -> Dict {
            return current
        }
    }
    
    static var SuperDictionary : [String : any Statistic] =
    [
        "Total Standards" : BasicStat(),
        "Total Sugar" : BasicStat(),
        "Total Volume" : BasicStat(),
        "Peak BAC" : MaxStat(),
        "Time above 0.05 BAC" : BasicStat(),
        "Volume Dictionary" : DictionaryStat(),
        "Standards Dictionary" : DictionaryStat()
    ]
     */
    
}
