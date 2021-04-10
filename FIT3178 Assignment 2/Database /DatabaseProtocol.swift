//
//  DatabaseController.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 10/4/21.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case meal
    case ingredient
    case ingredient_measurement
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onMyMealsChange(change: DatabaseChange, myMeals: [Meal])
    func onIngredientsChange(change: DatabaseChange, ingredients: [Ingredient])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addMeal(name: String, instructions: String) -> Meal
    func addIngredient(name: String) -> Ingredient
    func addIngredientMeasurement(meal: Meal, ingredientName: String, measurement: String) -> IngredientMeasurement
    
    func createEmptyMeal() -> Meal
    func editMeal(meal: Meal) -> Meal
    func editMealName(meal: Meal, name: String)
    func editMealInstructions(meal: Meal, instructions: String)
    func editAddIngredientMeasurement(meal: Meal, ingredientName: String, measurement: String) -> IngredientMeasurement
    func editRemoveIngredientMeasurement(meal: Meal, ingredientMeasurement: IngredientMeasurement)
    func editSaveMeal(meal: Meal)
    
    func removeIngredientFromMeal(meal: Meal, ingredientMeasurement: IngredientMeasurement)
    func removeMeal(meal: Meal)
    func fetchAllIngredients() -> [Ingredient]
    func fetchIngredientByName(ingredientName: String) -> [Ingredient]
    func fetchMeal(mealName: String, mealInstructions: String) -> [Meal]
    func fetchMealByName(mealName: String) -> [Meal]
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
