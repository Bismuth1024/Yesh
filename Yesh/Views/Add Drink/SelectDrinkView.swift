//
//  SelectDrinkView.swift
//  Yeshica
//
//  Created by Manith Kha on 6/2/2023.
//

import SwiftUI

struct SelectDrinkView: View {
    @Binding var drink: AlcoholicDrink
    @Binding var isShowing: Bool
    @State var dummyDrink = AlcoholicDrink(name: "", ingredients: [])
    @State var searchText = ""
    
    var searchResults: [String] {
        var drinks = AlcoholicDrink.DrinkDictionary
        
        for filterTag in dummyDrink.tags {
            drinks = drinks.filter({$1.hasTag(filterTag)})
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
                IconTextField("magnifyingglass", text: $searchText, prompt: "search")
                
                TagEditor(object: $dummyDrink)
            } header: {
                Text("Filter")
            }
            
            Section {
                List {
                    ForEach(searchResults, id: \.self) {name in
                        HStack {
                            ResizeableImageView(imageName: AlcoholicDrink.DrinkDictionary[name]!.imageName, width: 50, height: 50)
                            Spacer()
                            Text(name)
                        }
                        .onTapGesture {
                            drink = AlcoholicDrink.DrinkDictionary[name]!
                            isShowing = false
                        }
                    }
                }
            } header: {
                Text("Drinks")
            }
        }
        .navigationTitle("Select Drink")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(role: .destructive, action: {isShowing = false}) {
                    Text("Cancel")
                }
            }
        }
    }
}

struct SelectDrinkView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDrinkView(drink: .constant(.GinAndTonic), isShowing: .constant(true))
    }
}
