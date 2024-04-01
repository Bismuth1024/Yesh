//
//  SaveDrinkView.swift
//  Yesh
//
//  Created by Manith Kha on 30/12/2023.
//

import SwiftUI

struct SaveDrinkView: View {
    @Binding var isShowing: Bool
    @Binding var drink: AlcoholicDrink
    @State var isNameCollision: Bool = false
    
    var body: some View {
        Form {
            DrinkIngredientsList(drink: $drink)
            
            Section(
                content: {
                    HStack {
                        Picker("Image", selection: $drink.imageName) {
                            ForEach(AlcoholicDrink.ImageNames, id: \.self) {name in
                                Text(name).tag(name)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .labelsHidden()
                        
                        Spacer()
                        
                        ResizeableImageView(imageName: drink.imageName, width: 100, height: 100)
                    }
                },
                header: {
                    Text("Image")
                }
            )
            
            Section {
                TagEditor(object: $drink)
            } header: {
                Text("Tags")
            }
            
            Section(
                content: {
                    HStack {
                        TextField("Name", text: $drink.name)
                        Spacer()
                        SafeButton("Save") {
                            checkName()
                        }
                        .foregroundStyle(.blue)
                        .disabled(!drink.isValid())
                    }
                },
                header: {
                    Text("Name")
                }
            )
            
        }
        .alert("", isPresented: $isNameCollision, actions: {
            Button("Overwrite", role: .destructive) {
                saveDrink()
            }
        }, message: {
            Text("A drink already exists with that name.  Would you like to overwrite this drink?")
        })
         
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(role: .destructive, action: {
                    isShowing = false
                }) {
                    Text("Cancel")
                }
            }
        }
    }
    
    func checkName() {
        if AlcoholicDrink.DrinkNames.contains(drink.name) {
            isNameCollision = true
        } else {
            saveDrink()
        }
    }
    
    func saveDrink() {
        drink.addTag(.Custom)
        AlcoholicDrink.DrinkDictionary[drink.name] = drink
        var customDrinks: [AlcoholicDrink] = Settings.loadArray(key: "customDrinks") ?? []
        customDrinks.append(drink)
        Settings.saveArray(customDrinks, key: "customDrinks")
        isShowing = false
    }
}

#Preview {
    SaveDrinkView(isShowing: .constant(true), drink: .constant(AlcoholicDrink.Mojito))
}
