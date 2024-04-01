//
//  DrinkIngredient.swift
//  Yeshica
//
//  Created by Manith Kha on 8/2/2023.
//

import Foundation

/*
 A model for representing an ingredient of a drink.
 
 
 Properties:
    name: Name
    ABV:
    sugarPercent: (g/100 mL)
    tags: things like spirit, alcohol free, etc. could be used for later
 
 The static constants contain some default common ingredients, such as:
 Vodka: "Vodka", 40% alcohol, 0% sugar, tagged with spirit and sugar free
 
 In this application, ingredients need to be uniquely identified by their name - So you cannot have two
 different vodkas in one drink for example, one of them needs to be renamed.
 
 Note the distinction between the static constant Vodka and the name "Vodka" - an ingredient could be added with the name "Vodka",
 but with different other values to the static constant Vodka.  The static constants are for convenience, and eventually will be added
 to by the user: for example, they could add in "Vodka (brand X)" with 45 ABV if it's something they use often.
 
 This file also contains some volumes such as shot (corresponding to 30 mL) and so on.  The static constants can be retrieved by their
 name via the DrinkIngredient.IngredientDictionary variable.
 
 See more discussion in the AlcoholicDrink file.
 */

struct DrinkIngredient : Hashable, Equatable, Codable, Identifiable, Taggable
{
    static let RedWine = DrinkIngredient(name: "Red Wine", ABV: 14, sugarPercent: 0.7, tags: [.Wine])
    static let WhiteWine = DrinkIngredient(name: "White Wine", ABV: 14, sugarPercent: 1, tags: [.Wine])
    static let Champagne = DrinkIngredient(name: "Champagne", ABV: 13, sugarPercent: 1, tags: [.Wine, .Carbonated])

    static let Vodka = DrinkIngredient(name: "Vodka", ABV: 40, sugarPercent: 0, tags: [.Spirit, .SugarFree])
    static let Gin = DrinkIngredient(name: "Gin", ABV: 40, sugarPercent: 0, tags: [.Spirit, .SugarFree])
    static let Rum = DrinkIngredient(name: "Rum", ABV: 40, sugarPercent: 0, tags: [.Spirit, .SugarFree])
    static let Whiskey = DrinkIngredient(name: "Whiskey", ABV: 40, sugarPercent: 0, tags: [.Spirit, .SugarFree])
    static let Tequila = DrinkIngredient(name: "Tequila", ABV: 40, sugarPercent: 0, tags: [.Spirit, .SugarFree])
    static let Cognac = DrinkIngredient(name: "Cognac", ABV: 40, sugarPercent: 1.5, tags: [.Spirit, .SugarFree])
    static let Armagnac = DrinkIngredient(name: "Armagnac", ABV: 40, sugarPercent: 0, tags: [.Spirit])
    static let Mezcal = DrinkIngredient(name: "Mezcal", ABV: 40, sugarPercent: 0, tags: [.Spirit, .SugarFree])
    
    static let GreenChartreuse = DrinkIngredient(name: "Green Chartreuse", ABV: 55, sugarPercent: 26, tags: [.Liqueur])
    static let YellowChartreuse = DrinkIngredient(name: "Yellow Chartreuse", ABV: 40, sugarPercent: 31.2, tags: [.Liqueur])

    static let Cointreau = DrinkIngredient(name: "Cointreau", ABV: 40, sugarPercent: 23, tags: [.Spirit])
    
    static let Maraschino = DrinkIngredient(name: "Luxardo Maraschino Liqueur", ABV: 32, sugarPercent: 35, tags: [.Liqueur])
    static let Campari = DrinkIngredient(name: "Campari", ABV: 25, sugarPercent: 24, tags: [.Liqueur])
    static let SweetVermouth = DrinkIngredient(name: "Sweet Vermouth", ABV: 15, sugarPercent: 16, tags: [.Wine])
    static let DryVermouth = DrinkIngredient(name: "Dry Vermouth", ABV: 15, sugarPercent: 3, tags: [.Wine])
    static let Jagermeister = DrinkIngredient(name: "Jagermeister", ABV: 35, sugarPercent: 13.2, tags: [.Liqueur])
    
    static let Absinthe = DrinkIngredient(name: "Absinthe", ABV: 60, sugarPercent: 0, tags: [.Spirit])
    
    static let Beer = DrinkIngredient(name: "Beer", ABV: 5, sugarPercent: 0, tags: [.Carbonated])
    static let Cider = DrinkIngredient(name: "Cider", ABV: 5, sugarPercent: 5, tags: [.Carbonated])
    
    static let Alize = DrinkIngredient(name: "Alize", ABV: 16, sugarPercent: 20, tags: [.Liqueur])

    static let Soju = DrinkIngredient(name: "Soju", ABV: 15, sugarPercent: 5, tags: [.Spirit])
    static let Sake = DrinkIngredient(name: "Sake", ABV: 15, sugarPercent: 0, tags: [.Spirit, .SugarFree])
    
    static let LemonJuice = DrinkIngredient(name: "Lemon Juice", ABV: 0, sugarPercent: 1.6, tags: [.NonAlcoholic])
    static let LimeJuice = DrinkIngredient(name: "Lime Juice", ABV: 0, sugarPercent: 1.6, tags: [.NonAlcoholic])
    static let SimpleSyrup = DrinkIngredient(name: "Simple Syrup", ABV: 0, sugarPercent: 61.5, tags: [.NonAlcoholic])
    
    static let SodaWater = DrinkIngredient(name: "Soda Water", ABV: 0, sugarPercent: 0, tags: [.NonAlcoholic, .SugarFree, .Carbonated])
    static let Lemonade = DrinkIngredient(name: "Lemonade", ABV: 0, sugarPercent: 10.8, tags: [.NonAlcoholic, .Carbonated])
    static let LemonadeNoSugar = DrinkIngredient(name: "Lemonade (No Sugar)", ABV: 0, sugarPercent: 0, tags: [.NonAlcoholic, .SugarFree, .Carbonated])
    static let Coke = DrinkIngredient(name: "Coke", ABV: 0, sugarPercent: 10.6, tags: [.NonAlcoholic, .Carbonated])
    static let CokeNoSugar = DrinkIngredient(name: "Coke (No Sugar)", ABV: 0, sugarPercent: 0, tags: [.NonAlcoholic, .Carbonated, .SugarFree])
    static let Redbull = DrinkIngredient(name: "Red Bull", ABV: 0, sugarPercent: 11, tags: [.NonAlcoholic, .Carbonated])
    static let TonicWater = DrinkIngredient(name: "Tonic Water", ABV: 0, sugarPercent: 7.1, tags: [.NonAlcoholic, .Carbonated])
    static let Water = DrinkIngredient(name: "Water", ABV: 0, sugarPercent: 0, tags: [.NonAlcoholic, .SugarFree])

    static let Other = DrinkIngredient(name: "Other", ABV: 0, sugarPercent: 0, tags: [.Invalid])
    
    enum Tags : String, Codable, RawRepresentable, CaseIterable {
        case NonAlcoholic = "Non-Alcoholic", Spirit, Liqueur, Wine, Carbonated, SugarFree = "Sugar Free", Custom, Invalid
    }

    var name: String
    var ABV: Double
    var sugarPercent: Double
    var tags: [Tags]
    
    //ID is defined as being the name, hence the restricions explained above.
    var id : String {
        name
    }
    
    static func == (lhs: DrinkIngredient, rhs: DrinkIngredient) -> Bool {
        return lhs.name == rhs.name && lhs.ABV == rhs.ABV && lhs.sugarPercent == rhs.sugarPercent && lhs.tags == rhs.tags
    }
    
    static let Sizes = [
        "1/4 oz",
        "1/3 oz",
        "1/2 oz",
        "2/3 oz",
        "3/4 oz",
        "1 oz",
        "1 1/4 oz",
        "1 1/3 oz",
        "1 1/2 oz",
        "1 2/3 oz",
        "1 3/4 oz",
        "2 oz",
        "3 oz",
        "4 oz",
        
        "Shot",
        "Shooter",
        "Small wine glass",
        "Medium wine glass",
        "Large wine glass",
        "Beer bottle",
        "Can"
    ]
    
    static let Volumes = [
        7.5,
        10,
        15,
        20,
        22.5,
        30,
        37.5,
        40,
        45,
        50,
        52.5,
        60,
        90,
        120,
        
        30,
        60,
        150,
        200,
        250,
        375,
        330
    ]
    
    static var SizesDictionary = Dictionary(uniqueKeysWithValues: zip(Sizes, Volumes))
    
    static var IngredientsDictionary : [String: DrinkIngredient] = [
        "Red Wine": .RedWine,
        "White Wine": .WhiteWine,
        "Vodka": .Vodka,
        "Gin": .Gin,
        "Rum": .Rum,
        "Whiskey": .Whiskey,
        "Tequila": .Tequila,
        "Cognac": .Cognac,
        "Armagnac": .Armagnac,
        "Absinthe": .Absinthe,
        "Beer": .Beer,
        "Cider": .Cider,
        "Mezcal": .Mezcal,
        "Soju": .Soju,
        "Sake": .Sake,
        
        "Alize": .Alize,
        
        "Green Chartreuse": .GreenChartreuse,
        "Yellow Chartreuse": .YellowChartreuse,
        "Luxardo Maraschino Liqueur": .Maraschino,
        "Cointreau": .Cointreau,
        "Campari": .Campari,
        "Sweet Vermouth": .SweetVermouth,
        "Dry Vermouth": .DryVermouth,
        "Jagermeister": .Jagermeister,
        
        "Lemon Juice": .LemonJuice,
        "Lime Juice": .LimeJuice,
        "Simple Syrup": .SimpleSyrup,
        
        "Soda Water": .SodaWater,
        "Lemonade": .Lemonade,
        "Lemonade (No Sugar)": .LemonadeNoSugar,
        "Coke": .Coke,
        "Coke (No Sugar)": .CokeNoSugar,
        "Red Bull": .Redbull,
        "Tonic Water": .TonicWater,
        "Water": .Water,
        
        "Other": .Other
    ]
    
    static var Names = Array(IngredientsDictionary.keys.sorted())
    
    static var ABVOptions : [Double] = (0...200).map{Double($0)/2}
    
    
    func hasTag(_ tag: DrinkIngredient.Tags) -> Bool {
        return tags.contains(tag)
    }
    
    @discardableResult mutating func addTag(_ tag: DrinkIngredient.Tags) -> Bool {
        if hasTag(tag) {
            return false
        } else {
            tags.append(tag)
            return true
        }
    }
    
    @discardableResult mutating func removeTag(_ tag: DrinkIngredient.Tags) -> Bool {
        let toReturn = hasTag(tag)
        tags.removeAll(where: {$0 == tag})
        return toReturn
    }
    
    static func loadCustomIngredients() {
        let customIngredients: [DrinkIngredient]? = Settings.loadCodable(key: "customIngredients")
        
        if let customIngredients {
            for ingredient in customIngredients {
                IngredientsDictionary[ingredient.name] = ingredient
            }
        }
    }
}
