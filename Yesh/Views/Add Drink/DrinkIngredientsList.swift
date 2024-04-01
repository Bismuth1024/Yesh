//
//  DrinkIngredientsList.swift
//  Yesh
//
//  Created by Manith Kha on 22/1/2024.
//

import SwiftUI

struct DrinkIngredientsList: View {
    @Binding var drink: AlcoholicDrink
    var body: some View {
        Section(
            content: {
                List {
                    ForEach(Array(zip($drink.ingredients.indices, $drink.ingredients)), id: \.0) { index, ingredient in
                        IngredientRowView(ingredient: ingredient, drink: $drink)
                    }
                    .onDelete { offsets in
                        drink.ingredients.remove(atOffsets: offsets)
                    }
                }
                Text(String(format: "Total standards: %.2f, Total sugar: %.1fg", drink.numStandards(), drink.totalSugar()))
            },
            header: {
                HStack {
                    Text("Ingredients")
                    Spacer()
                    Button("Add") {
                        drink.addIngredient()
                    }
                    .disabled(drink.containsIngredient("Other"))
                }
            }
        )
    }
}

#Preview {
    DrinkIngredientsList(drink: .constant(.Negroni))
}
