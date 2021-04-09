//
//  Meal.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 6/4/21.
//

import UIKit

class Meal: NSObject {
    
    var name: String
    var instructions: String
    var ingredients: [IngredientMeasurement]
    
    
    init(_ name: String, _ instructions: String, _ ingredients: [IngredientMeasurement]) {
        self.name = name
        self.instructions = instructions
        self.ingredients = ingredients
    }
    
}
