//
//  CustomDrinksView.swift
//  Yesh
//
//  Created by Manith Kha on 18/1/2024.
//

import SwiftUI

struct CustomDrinksView: View {
    @State var filterTag: AlcoholicDrink.Tags? = nil
    @State var dummyDrink = AlcoholicDrink(name: "dummy", ingredients: [])
    @State var searchText = ""
    
    var searchResults: [String] {
        var drinks = AlcoholicDrink.DrinkDictionary
        
        for tag in dummyDrink.tags {
            drinks = drinks.filter({$1.hasTag(tag)})
        }
        
        if searchText.isEmpty {
            return drinks.keys.sorted()
        } else {
            return drinks.keys.filter({$0.contains(searchText)})
        }
    }
    
    var body: some View {
        Form {
            
            Section {
                TagEditor(object: $dummyDrink, isSearchable: false)
            } header: {
                Text("Filter")
            }
            
            Section {
                List {
                    ForEach(searchResults
                            , id: \.self) { drinkName in
                        let drink = AlcoholicDrink.DrinkDictionary[drinkName]!
                        HStack {
                            ResizeableImageView(imageName: drink.imageName, width: 60, height: 60)
                            Spacer()
                            ColouredNavigationLink(drinkName, value: drink)
                        }
                        
                    }
                }
            } header: {
                HStack {
                    Text("Drinks")
                    Spacer()
                    NavigationLink(value: AlcoholicDrink.New) {
                        Text("New")
                    }
                }
            }
        }
        .navigationDestination(for: AlcoholicDrink.self) { drink in
            EditDrinkView(drink: drink)
                .navigationTitle(drink == AlcoholicDrink.New ? "Edit drink" : "New drink")
        }
    }
}

#Preview {
    CustomDrinksView()
}
