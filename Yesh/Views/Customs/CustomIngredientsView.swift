//
//  CustomDrinksView.swift
//  Yesh
//
//  Created by Manith Kha on 18/1/2024.
//

import SwiftUI

struct CustomIngredientsView: View {
    @State var dummyIngredient = DrinkIngredient(name: "", ABV: 0.0, sugarPercent: 0.0, tags: [])
    @State var searchText: String = ""
    
    var searchResults: [String] {
        var ingredients = DrinkIngredient.IngredientsDictionary
        
        for tag in dummyIngredient.tags {
            ingredients = ingredients.filter({$1.hasTag(tag)})
        }
        
        if searchText.isEmpty {
            return ingredients.keys.sorted()
        } else {
            return ingredients.keys.filter({$0.contains(searchText)})
        }
    }
    
    var body: some View {
        Form {
            
            Section {
                TagEditor(object: $dummyIngredient)
            } header: {
                Text("Filter")
            }
            
            Section {
                List {
                    ForEach(searchResults, id: \.self) {ingredientName in
                        HStack {
                            
                            
                            ColouredNavigationLink(ingredientName, value: DrinkIngredient.IngredientsDictionary[ingredientName])
                        }
                    }
                    
                }
            } header: {
                Text("Ingredients")
            }
        }
        .navigationDestination(for: DrinkIngredient.self) { ingredient in
            EditIngredientView(ingredient: ingredient)
                .navigationTitle("Edit drink")
            
        }
        
    }
}

#Preview {
    CustomIngredientsView()
}
