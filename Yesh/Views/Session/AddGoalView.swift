//
//  AddGoalView.swift
//  Yeshica
//
//  Created by Manith Kha on 8/1/2023.
//

import SwiftUI

struct AddGoalView: View {
    @Binding var isShowing: Bool
    @State var goalType = DrinkGoal.GoalType.Drunk
    @State var goalTime = Date()
    @Binding var goal : DrinkGoal?
    
    var body: some View {
        List {
            HStack {
                Picker("Goal", selection: $goalType) {
                    ForEach(DrinkGoal.GoalType.allCases, id: \.self) {type in
                        Text(type.rawValue)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            DatePicker("Time",
                       selection: $goalTime,
                       in: Date()...,
                       displayedComponents: [.date, .hourAndMinute]
            )
            Button(action: {addGoal()}) {
                Text("Add")
            }
            Button(role: .destructive, action: {clearGoal()}) {
                Text("Clear goal")
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    isShowing = false
                }) {
                    Text("Back")
                }
            }
        }
    }
    
    func addGoal() {
        goal = DrinkGoal(type: goalType, numStandards: 2//UserSettings.DrinkThresholds[goalType]!
                         , time: goalTime)
        isShowing = false
    }
    
    func clearGoal() {
        goal = nil
        isShowing = false
    }
    
}

struct AddGoalView_Previews: PreviewProvider {
    static var previews: some View {
        AddGoalView(isShowing: .constant(true), goal: .constant(.sample))
    }
}
