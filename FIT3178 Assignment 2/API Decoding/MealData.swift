//
//  MealData.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 10/4/21.
//

import UIKit
import Foundation

class MealData: NSObject, Decodable {
    
    var name: String
    var instructions: String
    var ingredients = [String]()
    var ingredientMeasurement = [String]()
    

    private enum RootKeys: String, CodingKey {
        case meals
    }
    
    private enum MealKeys: String, CodingKey {
    
        case strMeal
        case strInstructions
        
        case strIngredient1
        case strIngredient2
        case strIngredient3
        case strIngredient4
        case strIngredient5
        case strIngredient6
        case strIngredient7
        case strIngredient8
        case strIngredient9
        case strIngredient10
        case strIngredient11
        case strIngredient12
        case strIngredient13
        case strIngredient14
        case strIngredient15
        case strIngredient16
        case strIngredient17
        case strIngredient18
        case strIngredient19
        case strIngredient20
        
        case strMeasure1
        case strMeasure2
        case strMeasure3
        case strMeasure4
        case strMeasure5
        case strMeasure6
        case strMeasure7
        case strMeasure8
        case strMeasure9
        case strMeasure10
        case strMeasure11
        case strMeasure12
        case strMeasure13
        case strMeasure14
        case strMeasure15
        case strMeasure16
        case strMeasure17
        case strMeasure18
        case strMeasure19
        case strMeasure20
    }

    
    required init(from decoder: Decoder) throws {
        let mealContainer = try decoder.container(keyedBy: MealKeys.self)
        name = try mealContainer.decode(String.self, forKey: .strMeal)
        instructions = try mealContainer.decode(String.self, forKey: .strInstructions)
        
        
        
  
        
        if let ingredient  = try? mealContainer.decode(String.self, forKey: .strIngredient1) {
            ingredients.append(ingredient)
        }
        
        
        if let measurement = try? mealContainer.decode(String.self, forKey: .strMeasure1) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? mealContainer.decode(String.self, forKey: .strIngredient2) {
            ingredients.append(ingredient)
        }
        if let measurement = try? mealContainer.decode(String.self, forKey: .strMeasure2) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? mealContainer.decode(String.self, forKey: .strIngredient3) {
            ingredients.append(ingredient)
        }
        if let measurement = try? mealContainer.decode(String.self, forKey: .strMeasure3) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? mealContainer.decode(String.self, forKey: .strIngredient4) {
            ingredients.append(ingredient)
        }
        if let measurement = try? mealContainer.decode(String.self, forKey: .strMeasure4) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? mealContainer.decode(String.self, forKey: .strIngredient5) {
            ingredients.append(ingredient)
        }
        if let measurement = try? mealContainer.decode(String.self, forKey: .strMeasure5) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? mealContainer.decode(String.self, forKey: .strIngredient6) {
            ingredients.append(ingredient)
        }
        if let measurement = try? mealContainer.decode(String.self, forKey: .strMeasure6) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? mealContainer.decode(String.self, forKey: .strIngredient7) {
            ingredients.append(ingredient)
        }
        if let measurement = try? mealContainer.decode(String.self, forKey: .strMeasure7) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? mealContainer.decode(String.self, forKey: .strIngredient8) {
            ingredients.append(ingredient)
        }
        if let measurement = try? mealContainer.decode(String.self, forKey: .strMeasure8) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? mealContainer.decode(String.self, forKey: .strIngredient9) {
            ingredients.append(ingredient)
        }
        if let measurement = try? mealContainer.decode(String.self, forKey: .strMeasure9) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? mealContainer.decode(String.self, forKey: .strIngredient10) {
            ingredients.append(ingredient)
        }
        if let measurement = try? mealContainer.decode(String.self, forKey: .strMeasure10) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? mealContainer.decode(String.self, forKey: .strIngredient11) {
            ingredients.append(ingredient)
        }
        if let measurement = try? mealContainer.decode(String.self, forKey: .strMeasure11) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? mealContainer.decode(String.self, forKey: .strIngredient12) {
            ingredients.append(ingredient)
        }
        if let measurement = try? mealContainer.decode(String.self, forKey: .strMeasure12) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? mealContainer.decode(String.self, forKey: .strIngredient13) {
            ingredients.append(ingredient)
        }
        if let measurement = try? mealContainer.decode(String.self, forKey: .strMeasure13) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? mealContainer.decode(String.self, forKey: .strIngredient14) {
            ingredients.append(ingredient)
        }
        if let measurement = try? mealContainer.decode(String.self, forKey: .strMeasure14) {
            ingredientMeasurement.append(measurement)
        }
        
        if let ingredient  = try? mealContainer.decode(String.self, forKey: .strIngredient15) {
            ingredients.append(ingredient)
        }
        if let measurement = try? mealContainer.decode(String.self, forKey: .strMeasure15) {
            ingredientMeasurement.append(measurement)
        }
        
        if let ingredient  = try? mealContainer.decode(String.self, forKey: .strIngredient16) {
            ingredients.append(ingredient)
        }
        if let measurement = try? mealContainer.decode(String.self, forKey: .strMeasure16) {
            ingredientMeasurement.append(measurement)
        }
        
        if let ingredient  = try? mealContainer.decode(String.self, forKey: .strIngredient17) {
            ingredients.append(ingredient)
        }
        if let measurement = try? mealContainer.decode(String.self, forKey: .strMeasure17) {
            ingredientMeasurement.append(measurement)
        }
        
        if let ingredient  = try? mealContainer.decode(String.self, forKey: .strIngredient18) {
            ingredients.append(ingredient)
        }
        if let measurement = try? mealContainer.decode(String.self, forKey: .strMeasure18) {
            ingredientMeasurement.append(measurement)
        }
        
        if let ingredient  = try? mealContainer.decode(String.self, forKey: .strIngredient19) {
            ingredients.append(ingredient)
        }
        if let measurement = try? mealContainer.decode(String.self, forKey: .strMeasure19) {
            ingredientMeasurement.append(measurement)
        }
        
        if let ingredient  = try? mealContainer.decode(String.self, forKey: .strIngredient20) {
            ingredients.append(ingredient)
        }
        if let measurement = try? mealContainer.decode(String.self, forKey: .strMeasure20) {
            ingredientMeasurement.append(measurement)
        }
    
    }

}
