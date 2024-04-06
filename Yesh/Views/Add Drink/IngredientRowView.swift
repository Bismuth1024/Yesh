//
//  IngredientRowView.swift
//  Yeshica
//
//  Created by Manith Kha on 7/2/2023.
//
//  This is a row that is displayed when editing the ingredients of a drink
//
/*
 Visual structure:
 Image of ingredient | Picker for ingredient, picker for volume | Picker for ABV
 
 Selecting the ingredient picker will set the whole ingredient variable to a copy of a static constant taken from DrinkIngredient.IngredientsDictionary
 
 
 
 
 
 
 
 
 
 */

import SwiftUI

struct IngredientRowView: View {
    @Binding var ingredient: AlcoholicDrink.IngredientWrapper
    @Binding var drink: AlcoholicDrink
    
    var availableIngredients: [String] {
        var names = DrinkIngredient.Names
        //names = names.filter({$0 == ingredient.ingredientType.name})
        let currentUsedNames = drink.ingredients.map({$0.ingredientType.name})
        
        names = names.filter({!currentUsedNames.contains($0) || $0 == ingredient.ingredientType.name})
        return names
    }
    
    var body: some View {
        HStack {
            ResizeableImageView(imageName: ingredient.ingredientType.name, width: 50, height: 50)
            Spacer()
            VStack {
                Picker("Ingredient", selection: $ingredient.ingredientType.name) {
                    ForEach(availableIngredients, id: \.self) {name in
                        Text(name).tag(name)
                    }
                }
                
                .pickerStyle(MenuPickerStyle())
                
                Spacer()
                
                Picker("Volume", selection: $ingredient.volume) {
                    ForEach(DrinkIngredient.Sizes, id: \.self) {name in
                        Text(name).tag(DrinkIngredient.SizesDictionary[name]!)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding([.top, .bottom], 20)
            
            Spacer()
            
            Picker("ABV", selection: $ingredient.ingredientType.ABV) {
                ForEach(DrinkIngredient.ABVOptions, id: \.self) {val in
                    Text(String(format: "%.1f %%", val)).tag(val)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 100.0, height: 100.0)
            .clipped()
        }
        .labelsHidden()
        .onChange(of: ingredient.ingredientType.name)  { new in
            self.ingredient.ingredientType = DrinkIngredient.IngredientsDictionary[new]!
        }
    }
    
    
}

struct IngredientRowView_Previews: PreviewProvider {
    @State static var ingredient =  AlcoholicDrink.IngredientWrapper(ingredientType: .Vodka, volume: 30)
    @State static var drink = AlcoholicDrink.VodkaLemonade
    
    static var previews: some View {
        IngredientRowView(ingredient: $ingredient, drink: $drink)
    }
}


