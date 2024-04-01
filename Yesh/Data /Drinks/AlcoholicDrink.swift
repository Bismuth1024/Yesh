//
//  AlcoholicDrink.swift
//  Yesh
//
//  Created by Manith Kha on 16/10/2023.
//

/*
 A model representing an alcoholic drink.
 
 id: For identifiable, may not be needed, currently its via name as well.
 name:
 imageName: For what to display as an icon
 ingredients: of type IngredientWrapper
 
 IngredientWrapper is just a DrinkIngredient and volume (Double) but as a struct so it can conform to protocols
 
 Ingredients can be added and removed via their name (String), adding by name will take from DrinkIngredient.IngredientsDictionary
 
 Just like for DrinkIngredient, there are a bunch of static constants for convenience that are again uniquely identified by name.
 
 
 
 */

import Foundation


struct AlcoholicDrink : Identifiable, Equatable, Codable, Hashable, Taggable {
    var id : String {
        name
    }
    
    var name: String
    var imageName: String
    var ingredients: [IngredientWrapper]
    var tags: [Tags] = []
    
    enum Tags : String, Codable, RawRepresentable, CaseIterable {
        case NonAlcoholic = "Non-Alcoholic", Shot, Custom, Cocktail, SpiritMixer = "Spirit & Mixer", SingleIngredient = "Single Ingredient"
    }
    
    init(name: String, imageName: String = "Coupe", ingredients: [(DrinkIngredient, Double)], tags: [Tags] = []) {
        self.name = name
        self.ingredients = []
        for ingredient in ingredients {
            self.ingredients.append(IngredientWrapper(ingredientType: ingredient.0, volume: ingredient.1))
        }
        self.imageName = imageName
        self.tags = tags
    }

    static func == (lhs: AlcoholicDrink, rhs: AlcoholicDrink) -> Bool {
        if lhs.name != rhs.name {
            return false
        }
        
        if lhs.imageName != rhs.imageName {
            return false
        }
        
        if lhs.ingredients.count != rhs.ingredients.count {
            return false
        }
        
        for idx in lhs.ingredients.indices {
            if (lhs.ingredients[idx] != rhs.ingredients[idx]) {
                return false
            }
        }
        
        if lhs.tags != rhs.tags {
            return false
        }
        return true
    }
    
    func numStandards() -> Double {
        var toReturn = 0.0
        for ingredient in ingredients {
            toReturn += ingredient.numStandards()
        }
        return toReturn
    }
    
    func totalSugar() -> Double {
        var toReturn = 0.0
        for ingredient in ingredients {
            toReturn += (ingredient.ingredientType.sugarPercent/100) * ingredient.volume
        }
        return toReturn
    }
    
    func totalVolume() -> Double {
        return ingredients.reduce(0.0, {current, wrapper in
            current + wrapper.volume
        })
    }
    
    @discardableResult mutating func addIngredient(ingredientName: String, volume: Double) -> Bool {
        if let ingredient = DrinkIngredient.IngredientsDictionary[ingredientName] {
            ingredients.append(IngredientWrapper(ingredientType: ingredient, volume: volume))
            return true
        } else {
            return false
        }
    }
    
    @discardableResult mutating func addIngredient() -> Bool {
        return addIngredient(ingredientName: "Other", volume: 30)
    }

    @discardableResult mutating func removeIngredient(_ ingredientName: String) -> Bool {
        let index = ingredients.firstIndex(where: {$0.ingredientType.name == ingredientName})
        if let index {
            ingredients.remove(at: index)
            return true
        } else {
            return false
        }
    }
    
    func printInfo() {
        print("Drink \"\(name)\" contains \(ingredients.count) ingredients:\n")
        for ingredient in ingredients {
            print(ingredient.info())
        }
    }
    
    func containsIngredient(_ ingredientName: String) -> Bool {
        return ingredients.contains(where: {$0.ingredientType.name == ingredientName})
    }
    
    func isValid() -> Bool {
        return !(containsIngredient("Other") || ingredients.count == 0)
    }
    
    struct IngredientWrapper: Hashable, Identifiable, Codable, Equatable {
        //Needed for plotting - Don't just use tuple
        var ingredientType: DrinkIngredient
        var volume: Double
        
        var id : String {
            ingredientType.id
        }
        
        static func == (lhs: IngredientWrapper, rhs: IngredientWrapper) -> Bool {
            (lhs.ingredientType == rhs.ingredientType) && (lhs.volume == rhs.volume)
        }
        
        func numStandards() -> Double {
            (ingredientType.ABV/100) * volume * 0.078
        }
        
        func info() -> String {
            return ("\(ingredientType.name), \(volume) mL, \(ingredientType.ABV)% Alcohol, \(ingredientType.sugarPercent)% sugar\n")
        }
    }
    
    enum DrinkingMethod {
        case chug, slow
    }
    
    static let New = AlcoholicDrink(name: "New Drink", imageName: "Coupe", ingredients: [], tags: [.Custom])
    
    static let Other = AlcoholicDrink(name: "Other",  imageName: "Other", ingredients: [])
    
    static let Daiquiri = AlcoholicDrink(name: "Daiquiri", ingredients: [
        (.Rum, 60),
        (.LimeJuice, 22.5),
        (.SimpleSyrup, 22.5)
    ], tags: [.Cocktail])
    
    static let Margarita = AlcoholicDrink(name: "Margarita", ingredients: [
        (.Tequila, 60),
        (.Cointreau, 30),
        (.LimeJuice, 30)
    ], tags: [.Cocktail])
    
    static var Negroni = AlcoholicDrink(name: "Negroni", ingredients: [
        (.Gin, 30),
        (.SweetVermouth, 30),
        (.Campari, 30)
    ], tags: [.Cocktail])
    
    static let Martini = AlcoholicDrink(name: "Martini", ingredients: [
        (.Gin, 60),
        (.DryVermouth, 15),
    ], tags: [.Cocktail])
    
    static let Jagerbomb = AlcoholicDrink(name: "Jagerbomb", imageName: "Rocks Glass", ingredients: [
        (.Jagermeister, 30),
        (.Redbull, 120)
    ], tags: [.SpiritMixer])
    
    static let VodkaLemonade = AlcoholicDrink(name: "Vodka Lemonade", imageName: "Rocks Glass", ingredients: [
        (.Vodka, 30),
        (.Lemonade, 120)
    ], tags: [.SpiritMixer])
    
    static let RumAndCoke = AlcoholicDrink(name: "Rum and Coke", imageName: "Rocks Glass", ingredients: [
        (.Rum, 30),
        (.Coke, 120)
    ], tags: [.SpiritMixer])
    
    static let WhiskeyAndCoke = AlcoholicDrink(name: "Whiskey and Coke", imageName: "Rocks Glass", ingredients: [
        (.Whiskey, 30),
        (.Coke, 120)
    ], tags: [.SpiritMixer])
    
    static let GinAndTonic = AlcoholicDrink(name: "Gin and Tonic", imageName: "Rocks Glass", ingredients: [
        (.Gin, 30),
        (.TonicWater, 120)
    ], tags: [.SpiritMixer])
    
    static let AlizeLemonade = AlcoholicDrink(name: "Alize Lemonade", imageName: "Rocks Glass", ingredients: [
        (.Alize, 30),
        (.Lemonade, 120)
    ], tags: [.SpiritMixer])
    
    static let Mojito = AlcoholicDrink(name: "Mojito", imageName: "Highball Glass", ingredients: [
        (.Rum, 60),
        (.LimeJuice, 22.5),
        (.SimpleSyrup, 22.5),
        (.SodaWater, 90)
    ], tags: [.Cocktail])
    
    static let Sidecar = AlcoholicDrink(name: "Sidecar", ingredients: [
        (.Cognac, 30),
        (.Cointreau, 30),
        (.LemonJuice, 30)
    ], tags: [.Cocktail])
    
    static let SojuBottle = AlcoholicDrink(name: "Soju Bottle", ingredients: [
        (.Soju, 360)
    ], tags: [.SingleIngredient])
    
    static var DrinkDictionary: [String: AlcoholicDrink] = [
        "Daiquiri": .Daiquiri,
        "Margarita": .Margarita,
        "Negroni": .Negroni,
        "Martini": .Martini,
        "Jagerbomb": .Jagerbomb,
        "Vodka Lemonade": .VodkaLemonade,
        "Rum and Coke": .RumAndCoke,
        "Whiskey and Coke": .WhiskeyAndCoke,
        "Gin and Tonic": .GinAndTonic,
        "Alize Lemonade": .AlizeLemonade,
        "Mojito": .Mojito,
        "Sidecar": .Sidecar,
        
        "Beer bottle": AlcoholicDrink(name: "Beer Bottle", ingredients: [
            (.Beer, 375)
        ], tags: [.SingleIngredient]),
        
        "Beer can": AlcoholicDrink(name: "Beer can", ingredients: [
            (.Beer, 330)
        ], tags: [.SingleIngredient]),
        
        "White wine (small glass)": AlcoholicDrink(name: "White wine (small glass)", ingredients: [
            (.WhiteWine, 150)
        ], tags: [.SingleIngredient]),
        
        "White wine (medium glass)": AlcoholicDrink(name: "White wine (medium glass)", ingredients: [
            (.WhiteWine, 200)
        ], tags: [.SingleIngredient]),
        
        "White wine (large glass)": AlcoholicDrink(name: "White wine (large glass)", ingredients: [
            (.WhiteWine, 250)
        ], tags: [.SingleIngredient]),
        
        "Red wine (small glass)": AlcoholicDrink(name: "Red wine (small glass)", ingredients: [
            (.RedWine, 150)
        ], tags: [.SingleIngredient]),
        
        "Red wine (medium glass)": AlcoholicDrink(name: "Red wine (medium glass)", ingredients: [
            (.RedWine, 200)
        ], tags: [.SingleIngredient]),
        
        "Red wine (large glass)": AlcoholicDrink(name: "Red wine (large glass)", ingredients: [
            (.RedWine, 250)
        ], tags: [.SingleIngredient])
    ]
    
    static var DrinkNames: [String] {
        Array(DrinkDictionary.keys).sorted()
    }
    
    static var ImageNames: [String] = [
        "Coupe",
        "Highball Glass",
        "Rocks Glass",
        "Shot Glass"
    ]
    
    func hasTag(_ tag: AlcoholicDrink.Tags) -> Bool {
        return tags.contains(tag)
    }
    
    @discardableResult mutating func addTag(_ tag: AlcoholicDrink.Tags) -> Bool {
        if hasTag(tag) {
            return false
        } else {
            tags.append(tag)
            return true
        }
    }
    
    @discardableResult mutating func removeTag(_ tag: AlcoholicDrink.Tags) -> Bool {
        let toReturn = hasTag(tag)
        tags.removeAll(where: {$0 == tag})
        return toReturn
    }
    
    //This function is for adding a bunch of shit like "Vodka shot" without me having to type it
    //Also means that any new spirits will automatically be added which is nice but honestly I should just write it all out
    static func addSpiritsToDatabase() {
        for element in DrinkIngredient.IngredientsDictionary.enumerated() {
            let entry = element.1
            let name = entry.0
            let ingredient = entry.1
            if ingredient.hasTag(.Spirit) || ingredient.hasTag(.Liqueur) {
                var drinkName = name + " (shot)"
                DrinkDictionary[drinkName] = AlcoholicDrink(name: drinkName, imageName: "Shot Glass", ingredients: [
                    (ingredient, 30.0)
                ], tags: [.SingleIngredient, .Shot])
                drinkName = name + " (shooter)"
                DrinkDictionary[drinkName] = AlcoholicDrink(name: drinkName, imageName: "Shot Glass", ingredients: [
                    (ingredient, 60.0)
                ], tags: [.SingleIngredient, .Shot])
            }
        }
    }
    
    static func loadCustomDrinks() {
        let customDrinks: [AlcoholicDrink] = Settings.loadArray(key: "customDrinks") ?? []
        
        for drink in customDrinks {
            DrinkDictionary[drink.name] = drink
        }
    }
}



