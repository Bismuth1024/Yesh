//
//  Taggable.swift
//  Yesh
//
//  Created by Manith Kha on 23/1/2024.
//

import Foundation

protocol Taggable {
    associatedtype Tags: RawRepresentable, CaseIterable, Hashable where Tags.RawValue == String
    
    var tags: [Tags] {get set}
    @discardableResult mutating func addTag(_ tag: Tags) -> Bool
    @discardableResult mutating func removeTag(_ tag: Tags) -> Bool
    func hasTag(_ tag: Tags) -> Bool
    
    
    
}
