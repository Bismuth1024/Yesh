//
//  TableWrapper.swift
//  Yesh
//
//  Created by Manith Kha on 1/2/2024.
//

import Foundation

struct TableWrapper : Identifiable {
    var name: String
    var thisValue: Double
    var recordValue: Double
    var formatter: (Double) -> String
    let id = UUID()
    
    /*
    var id: String {
        name
    }
     */
    
    init() {
        name = ""
        thisValue = 0.0
        recordValue = 0.0
        formatter = {_ in ""}
    }
    
    init(_ name: String, _ thisValue: Double, _ recordValue: Double, formatter: @escaping (Double) -> String) {
        self.name = name
        self.thisValue = thisValue
        self.recordValue = recordValue
        self.formatter = formatter
    }
    
    static func wrap(_ current: SummaryStats, _ record: SummaryStats) -> [String: TableWrapper] {
        var toReturn = [String: TableWrapper]()
        
        toReturn["Total Standards"] = TableWrapper("Total Standards", current.totalStandards, record.totalStandards) {val in
            String(format: "%.2f", val)
        }
        toReturn["Total Sugar"] = TableWrapper("Total Sugar", current.totalSugar, record.totalSugar) {val in
            String(format: "%.2f g", val)
        }
        toReturn["Total Volume"] = TableWrapper("Total Volume", current.totalVolume, record.totalVolume) {val in
            String(format: "%.0f mL", val)
        }
        toReturn["Peak BAC"] = TableWrapper("Peak BAC", current.peakBAC, record.peakBAC) {val in
            String(format: "%.3f", val)
        }
        toReturn["Time above 0.05 BAC"] = TableWrapper("Time above 0.05 BAC", current.timeAbove005, record.timeAbove005) {val in
            DateHelpers.secondsTo([.hour, .minute], value: Int(val))
        }
        toReturn["Duration"] = TableWrapper("Duration", current.duration, record.duration) {val in
            DateHelpers.secondsTo([.hour, .minute], value: Int(val))
        }
        
        return toReturn
    }
}


