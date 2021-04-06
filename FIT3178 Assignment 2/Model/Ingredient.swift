//
//  Ingredient.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 6/4/21.
//

import UIKit

class Ingredient: NSObject {
    
    var name: String
    var ingredientDescription: String
    
    init(name: String, ingredientDescription:String) {
        self.name = name
        self.ingredientDescription = ingredientDescription
    }

}
