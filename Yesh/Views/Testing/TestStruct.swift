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

struct TestStruct : Hashable, Equatable, Codable, Identifiable
{
    
    static let Vodka = TestStruct(name: "Vodka", tags: [.Spirit, .SugarFree])
    
    enum Tags : String, Codable, RawRepresentable, CaseIterable {
        case NonAlcoholic = "Non-Alcoholic", Spirit, Liqueur, Wine, Carbonated, SugarFree = "Sugar Free", Custom, Invalid
    }
    
    var name: String

    var tags: [Tags]
    
    //ID is defined as being the name, hence the restricions explained above.
    var id : String {
        name
    }
    
    /*
    static func == (lhs: DrinkIngredient, rhs: DrinkIngredient) -> Bool {
        return lhs.name == rhs.name && lhs.ABV == rhs.ABV && lhs.sugarPercent == rhs.sugarPercent
    }
     */
    
    func hasTag(_ tag: TestStruct.Tags) -> Bool {
        return tags.contains(tag)
    }
    
    @discardableResult mutating func addTag(_ tag: TestStruct.Tags) -> Bool {
        if hasTag(tag) {
            return false
        } else {
            tags.append(tag)
            print("Added \(tag.rawValue), current is")
            for tag in tags {
                    print(tag.rawValue)
            }
            return true
        }
    }

}
