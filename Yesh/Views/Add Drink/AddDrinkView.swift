//
//  AddDrinkView.swift
//  Yesh
//
//  Created by Manith Kha on 28/11/2023.
//

/*
 Pops up when you want to add a drink to the current session.
 
 Here you can add, remove and edit ingredients, or press a button to select from preset drinks (opens a new view, SelectDrinkView)
 */

import SwiftUI

struct AddDrinkView: View {
    @Binding var isShowing: Bool //Because this window is a popup
    @ObservedObject var CurrentSession: SessionStore //So that we can actually access the session
    @State var drink: AlcoholicDrink = AlcoholicDrink.Negroni
    @State var isSelectingDrink: Bool = false //For the new popup to open SelectDrinkView
    @State var isSavingDrink: Bool = false //For saving the drink as a preset
    @State var quantity: Int = 1
    @State var drinkingMethod: AlcoholicDrink.DrinkingMethod = .chug
    @State var time: Date = Date()
    
    var body: some View {
        Form {
            Section(
                content: {
                    HStack {
                        Text(drink.name)
                        Spacer()
                        Button("Change") {
                            isSelectingDrink.toggle()
                        }
                        .fullScreenCover(isPresented: $isSelectingDrink) {
                            NavigationStack {
                                SelectDrinkView(drink: $drink, isShowing: $isSelectingDrink)
                            }
                        }
                    }
                },
                header: {
                    Text("Drink")
                }
            )
            
            DrinkIngredientsList(drink: $drink)
            
            Section(
                content: {
                    Stepper(value: $quantity, in: 1...10) {
                        Text("Quantity: \(quantity)")
                    }
                    
                    
                    HStack {
                        Spacer()
                        Button("Save as a preset") {
                            isSavingDrink.toggle()
                        }
                        .disabled(!drink.isValid())
                    }
                    .sheet(isPresented: $isSavingDrink) {
                        NavigationStack {
                            SaveDrinkView(isShowing: $isSavingDrink, drink: $drink)
                        }
                    }
                },
                header: {
                    Text("Quantity")
                }
            )
            
            Section(
                content: {
                    Picker("Drinking speed", selection: $drinkingMethod) {
                        Text("Shot/chug").tag(AlcoholicDrink.DrinkingMethod.chug)
                        Text("Slow (start now)").tag(AlcoholicDrink.DrinkingMethod.slow)
                    }
                    .pickerStyle(.segmented)
                    
                    HStack {
                        Text("\(drinkingMethod == .chug ? "at" : "starting at")")
                        Spacer()
                        DatePicker("Time", selection: $time, displayedComponents: [.hourAndMinute, .date])
                            .labelsHidden()
                    }
                    
                    HStack {
                        Spacer()
                        Button("Add") {
                            addDrink()
                        }
                        .disabled(!drink.isValid())
                    }
                },
                header: {
                    Text("Add as a:")
                }
            )
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(role: .destructive, action: {
                    isShowing = false
                }) {
                    Text("Cancel")
                }
            }
        }
      
            //THIS MUST BE DONE IN THE PARENT VIEW BUT DO NOT ASK ME WHY I SPENT DAYS TRYING TO MAKE IT WORK IN THE CHILD LIKE IT SHOULD
            //I worked it out: since the id of an IngredientWrapper resolves to the ID of the DrinkIngredient which is equal to the ingredient's name, changing the name changes the ID and this does something since the list uses the ID to work out what row you are looking at.  So, if you change the name and hence id, onchange of name won't fire.
            //I fixed it by using the index of the drink as its id for the purposes of ForEach instead of the id value.
    }
    
    func addDrink() {
        CurrentSession.drinks.append(SessionStore.DrinkWrapper(drink: drink, startTime: time, endTime: drinkingMethod == .chug ? time : nil))
        CurrentSession.saveCurrentSession()
        isShowing = false
    }
}

struct AddDrinkView_Previews: PreviewProvider {
    static var previews: some View {
        AddDrinkView(isShowing: .constant(true), CurrentSession: SessionStore())
    }
}
