//
//  EditIngredientView.swift
//  Yesh
//
//  Created by Manith Kha on 22/1/2024.
//

import SwiftUI

struct EditIngredientView: View {
    @State var ingredient: DrinkIngredient = .Vodka
    @State var oldName: String = ""
    @State var confirmingDelete = false
    @State var isNameCollision = false

    var body: some View {
        Form {
            Section {
                    TextField("Name", text: $ingredient.name)
                } header: {
                    Text("Name")
                }
                        
            /*
            Section {
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
                } header: {
                    Text("Image")
            }
             */
            
            Section {
                TagEditor(object: $ingredient)

            } header: {
                Text("Tags")
            }
            
            Section {
                InputSlider(name: "ABV", value: $ingredient.ABV, min: 0.0, max: 100.0, step: 0.1, nSigFigs: 4)
            } header: {
                Text("ABV")
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
                    }
                },
                header: {
                    
                }
            )
            .alert("", isPresented: $confirmingDelete, actions: {
                Button("Delete", role: .destructive) {
                    deleteIngredient()
                }
            }, message: {
                Text("Delete this drink?")
            })
            
        }
        .alert("", isPresented: $isNameCollision, actions: {
            Button("Overwrite", role: .destructive) {
                saveIngredient()
            }
        }, message: {
            Text("An ingredient already exists with that name.  Would you like to overwrite this drink?")
        })
        .onAppear {
            oldName = ingredient.name
        }
    }
    
    func addTag(_ str: String) {
        ingredient.addTag(DrinkIngredient.Tags(rawValue: str)!)
    }
    
    func deleteIngredient() {
        for tag in ingredient.tags {
            print(tag.rawValue)
        }
    }
    
    func saveIngredient() {
        
    }
    
    func checkName() {
        
    }
}

#Preview {
    EditIngredientView()
}
