//
//  SessionView.swift
//  Yesh
//
//  Created by Manith Kha on 29/11/2023.
//

import SwiftUI

struct SessionView: View {
    @ObservedObject var CurrentSession: SessionStore = SessionStore() //So that we can actually access the session
    var past: Bool //To disable editing
    @State var showingAddDrink = false
    @State var isAddingGoal = false
    @State var currentGoal: DrinkGoal? = DrinkGoal.sample
    @State var isConfirmingEnd = false
    @State var graphShowing = false
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            if CurrentSession.startTime == nil {
                Button("New session") {
                    CurrentSession.startTime = Date.now
                }
            } else {
                VStack {
                    if CurrentSession.endTime != nil {
                        Text("Session (" + DateHelpers.dateToTime(CurrentSession.startTime ?? Date.now) + " - " + DateHelpers.dateToDescription(CurrentSession.endTime ?? Date.now) + ")")
                    } else {
                        Text("Session (started " + DateHelpers.dateToDescription(CurrentSession.startTime ?? Date()) + ")")
                    }
                         
                    Picker("type", selection: $graphShowing) {
                        Text("Graph").tag(true)
                        Text("Drinks").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .padding([.leading, .trailing, .bottom], 5)
                    
                    TwoOptionView(isFirstShowing: $graphShowing) {
                        GraphView(CurrentSession: CurrentSession)
                    } and: {
                        SessionDrinksView(CurrentSession: CurrentSession, past: past)
                    }
                    .frame(width: relativeWidth(0.9), height: relativeHeight(0.65))
                    
                    /*
                     if graphShowing {
                     GraphView()
                     .frame(width: relativeWidth(0.9), height: relativeHeight(0.7))
                     } else {
                     SessionDrinksView()
                     .frame(width: relativeWidth(0.9), height: relativeHeight(0.7))
                     }
                     */
                    
                    Button(action: {
                        isAddingGoal = true
                        //CurrentSession.clear()
                        //SessionStore.removeCurrentSession()
                    }) {
                        Text("Placeholder")
                    }
                    .sheet(isPresented: $isAddingGoal) {
                        NavigationStack {
                            AddGoalView(isShowing: $isAddingGoal, goal: $currentGoal)
                        }
                    }
                    
                    if (!past) {
                        HStack {
                            Button("Add Drink") {
                                showingAddDrink.toggle()
                            }
                            .sheet(isPresented: $showingAddDrink) {
                                NavigationStack {
                                    AddDrinkView(isShowing: $showingAddDrink, CurrentSession: CurrentSession)
                                }
                            }
                            .padding()
                            Spacer()
                            Button("End Session") {
                                isConfirmingEnd = true
                            }
                            .foregroundColor(.red)
                            .padding()
                        }
                    } else {
                        Button("update") {
                            CurrentSession.trim()
                            CurrentSession.saveCompletedSession()
                        }
                    }
                }
                .onChange(of: scenePhase) { phase in
                    if past {return}
                    if phase == .inactive {
                        saveAction()
                    }
                }
                .alert("Are you sure you want to end the session?", isPresented: $isConfirmingEnd) {
                    Button(role: .destructive) {
                        endSession()
                    } label: {
                        Text("End Session")
                    }
                }
            }
        }
    }
    
    func endSession() {
        CurrentSession.endTime = Date.now
        CurrentSession.saveCompletedSession()
        CurrentSession.clear()
        SessionStore.removeCurrentSession()
    }
    
    func saveAction() {
        CurrentSession.saveCurrentSession()
    }
    
}

#Preview {
    SessionView(past: false)
}
