//
//  EditDrinkView.swift
//  Yesh
//
//  Created by Manith Kha on 18/1/2024.
//

import SwiftUI

struct EditDrinkView: View {
    @State var drink: AlcoholicDrink = .Negroni
    @State var oldName: String = ""
    @State var isNameCollision: Bool = false
    @State var confirmingDelete: Bool = false
    
    var body: some View {
        Form {
            Section(
                content: {
                    TextField("Name", text: $drink.name)
                },
                header: {
                    Text("Name")
                }
            )
            
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
                        SafeButton("Delete") {
                            confirmingDelete.toggle()
                        }
                        .foregroundStyle(.red)
                        Spacer()
                        SafeButton("Save") {
                            checkName()
                        }
                        .foregroundStyle(.blue)
                        .disabled(!drink.isValid())
                    }
                },
                header: {
                    
                }
            )
            .alert("", isPresented: $confirmingDelete, actions: {
                Button("Delete", role: .destructive) {
                    deleteDrink()
                }
            }, message: {
                Text("Delete this drink?")
            })
            
        }
        .alert("", isPresented: $isNameCollision, actions: {
            Button("Overwrite", role: .destructive) {
                saveDrink()
            }
        }, message: {
            Text("A drink already exists with that name.  Would you like to overwrite this drink?")
        })
        .onAppear {
            oldName = drink.name
        }
    }
    
    func checkName() {
        if (oldName == drink.name) {
            saveDrink()
            return
        }
        
        if AlcoholicDrink.DrinkNames.contains(drink.name) {
            isNameCollision = true
        } else {
            saveDrink()
        }
    }
    
    func saveDrink() {
        drink.addTag(.Custom)
        AlcoholicDrink.DrinkDictionary.removeValue(forKey: oldName)
        AlcoholicDrink.DrinkDictionary[drink.name] = drink
        var customDrinks: [AlcoholicDrink] = Settings.loadArray(key: "customDrinks") ?? []
        customDrinks.append(drink)
        Settings.saveArray(customDrinks, key: "customDrinks")
        print("Saved as \(drink.name)")
    }
    
    func deleteDrink() {
        AlcoholicDrink.DrinkDictionary.removeValue(forKey: oldName)
        var customDrinks: [AlcoholicDrink] = Settings.loadArray(key: "customDrinks") ?? []
        customDrinks.removeAll(where: {$0.name == oldName})
        Settings.saveArray(customDrinks, key: "customDrinks")
    }
}

#Preview {
    EditDrinkView()
}
