//
//  File Structure.swift
//  Yesh
//
//  Created by Manith Kha on 29/12/2023.
//
import Foundation
/*
 
 file structure in main documents directory:
 
 CurrentSession.data
 
 logs/
    yyyy-MM-dd-HH:mm
    e.g. 2023-12-29-14:54
 
 drinks/
    customIngredients.data
    customDrinks.data
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 */


func getLogFileNames() -> [String] {
    var filenames: [String] = []
    do {
        filenames = try FileManager.default.contentsOfDirectory(atPath: sessionLogsURL().path())
    } catch {
        print(error)
    }
    return filenames
}
