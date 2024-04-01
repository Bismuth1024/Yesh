//
//  SessionDrinksView.swift
//  Yesh
//
//  Created by Manith Kha on 15/1/2024.
//

import SwiftUI

struct SessionDrinksView: View {
    @ObservedObject var CurrentSession: SessionStore //So that we can actually access the session
    let past: Bool //If this is set, then the session is an old log and cannot be edited
    @State var isFinishingDrink = false
    @State var isEditingDrink = false
    @State var currentIndex : Int? = nil
    @State var startTime = Date.now
    @State var endTime = Date.now

    
    var body: some View {
        List {
            ForEach($CurrentSession.drinks) {drink in
                DrinkRowView(wrapper: drink)
                .onTapGesture {
                    if (past) {return}
                    if drink.wrappedValue.endTime == nil {
                        currentIndex = CurrentSession.drinks.firstIndex(of: drink.wrappedValue)
                        isFinishingDrink = true
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        currentIndex = CurrentSession.drinks.firstIndex(of: drink.wrappedValue)
                        startTime = drink.wrappedValue.startTime
                        endTime = drink.wrappedValue.endTime ?? Date.now
                        isEditingDrink.toggle()
                    } label: {
                        Text("Edit")
                    }
                }
            }
            .onDelete(perform: drinkDeleted)
            .deleteDisabled(past)
        }
        .alert("Finish this drink now?", isPresented: $isFinishingDrink) {
            Button("Ok", role: .destructive) {
                CurrentSession.drinks[currentIndex!].endTime = Date()
            }
            Button("Cancel", role: .cancel) {
                
            }
        } message: {
            Text(getDrinkToFinish().description())
        }
        .sheet(isPresented: $isEditingDrink) {
            CurrentSession.drinks[currentIndex!].startTime = startTime
            CurrentSession.drinks[currentIndex!].endTime = endTime

        } content: {
            VStack {
                DatePicker("Start time", selection: $startTime, displayedComponents: [.hourAndMinute, .date])
                DatePicker("End time", selection: $endTime, displayedComponents: [.hourAndMinute, .date])
            }
        }
    }
    
    func getDrinkToFinish() -> SessionStore.DrinkWrapper {
        var drink = SessionStore.DrinkWrapper.sample
        if let idx = currentIndex {
            drink = CurrentSession.drinks[idx]
        }
        return drink
    }
    
    func drinkDeleted(at offsets: IndexSet) {
        CurrentSession.drinks.remove(atOffsets: offsets)
        CurrentSession.sort()
    }
}

#Preview {
    SessionDrinksView(CurrentSession: SessionStore(), past: false)
}
