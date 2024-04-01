//
//  YeshApp.swift
//  Yesh
//
//  Created by Manith Kha on 16/10/2023.
//

import SwiftUI

@main
struct YeshApp: App {
    private var CurrentSession : SessionStore

    init() {
        do {
            try FileManager.default.createDirectory(at: sessionLogsURL(), withIntermediateDirectories: true)
        } catch {
            print(error)
        }
        DrinkIngredient.loadCustomIngredients()
        AlcoholicDrink.loadCustomDrinks()
        AlcoholicDrink.addSpiritsToDatabase()
        CurrentSession = SessionStore()
        //CurrentSession.tryLoad()
    }
    
    var body: some Scene {
        WindowGroup {
            WrapperView()
        }
    }
}
