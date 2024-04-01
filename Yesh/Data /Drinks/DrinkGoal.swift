//
//  DrinkGoal.swift
//  Yesh
//
//  Created by Manith Kha on 19/12/2023.
//

import Foundation

struct DrinkGoal : Hashable, Equatable, Codable {
    enum GoalType : String, Codable, CaseIterable {
        case Buzzed, Tipsy, Drunk, Smashed
    }
    
    var type: GoalType
    var numStandards: Double
    var time: Date = Date()
    
    static var sample = DrinkGoal(type: .Drunk, numStandards: 4, time: Date())
}
