//
//  CoreDataController.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 10/4/21.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate{
  
    
    
    
    let INGREDIENTS_URL = "https://www.themealdb.com/api/json/v1/1/list.php?i=list"
    
    var allMealsFetchedResultsController: NSFetchedResultsController<Meal>?
    var allIngredientsFetchedResultsController: NSFetchedResultsController<Ingredient>?
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    override init() {
        // Initialize the core data for parent and child contexts
        persistentContainer = NSPersistentContainer(name: "LUKEHAEFFNER_A2_iOSPortfolioTasks")
        persistentContainer.loadPersistentStores(){(description, error) in
            if let error = error {
                fatalError("Failed to load core data stack: \(error)")
            }
        }
        childContext.parent = self.persistentContainer.viewContext
        super.init()
        
        // if initial launch, add all default ingredients
        if fetchAllIngredients().count == 0 {
            createDefaultIngredients()
        }
    }
    
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save to CoreData: \(error)")
            }
        }
        
    }
    
    
    func saveChildContext() {
        if childContext.hasChanges {
             do {
                 try childContext.save()
             } catch {
                 fatalError("Failed to save to child Context CoreData: \(error)")
             }
         }
         
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allMealsFetchedResultsController { listeners.invoke { (listener) in
            if listener.listenerType == .meal || listener.listenerType == .all {
                listener.onMyMealsChange(change: .update, myMeals: fetchAllMeals())
            }}
        }
    }
    
    
    func cleanup() {
        saveContext()
        saveChildContext()
    }
    
    
    func addMeal(name: String, instructions: String) -> Meal {
        let meal = NSEntityDescription.insertNewObject(forEntityName: "Meal", into: persistentContainer.viewContext) as! Meal
        meal.name = name
        meal.instructions = instructions
        return meal
    }
    
    
    func addIngredientMeasurement(meal: Meal, ingredientName: String, measurement: String) -> IngredientMeasurement {
        let ingredientMeasurement = NSEntityDescription.insertNewObject(forEntityName: "IngredientMeasurement", into: persistentContainer.viewContext) as! IngredientMeasurement
        ingredientMeasurement.meals = meal
        ingredientMeasurement.name = ingredientName
        ingredientMeasurement.quantity = measurement
        
        return ingredientMeasurement
    }
    
    
    func addIngredient(name: String) -> Ingredient {
        let ingredient = NSEntityDescription.insertNewObject(forEntityName: "Ingredient", into: persistentContainer.viewContext) as! Ingredient
        ingredient.name = name
        return ingredient
    }
    
    
    func removeMeal(meal: Meal) {
        persistentContainer.viewContext.delete(meal)
    }
    
    func removeIngredientFromMeal(meal: Meal, ingredientMeasurement: IngredientMeasurement) {
        meal.removeFromIngredients(ingredientMeasurement)
    }
    
    
    func editMeal(meal: Meal) -> Meal {
        childContext.rollback()
        let childMeal = childContext.object(with: meal.objectID) as! Meal
        return childMeal
    }
    
    func createEmptyMeal() -> Meal {
        childContext.rollback()
        let emptyMeal = NSEntityDescription.insertNewObject(forEntityName: "Meal", into: childContext) as! Meal
        return emptyMeal
    }
    
    func editMealName(meal: Meal, name: String) {
        meal.name = name
        return
    }
    
    func editMealInstructions(meal: Meal, instructions: String) {
        meal.instructions = instructions
        return
    }
    
    func editAddIngredientMeasurement(meal:Meal, ingredientName: String, measurement: String) -> IngredientMeasurement {
        let ingredientMeasurement = NSEntityDescription.insertNewObject(forEntityName: "IngredientMeasurement", into: childContext) as! IngredientMeasurement
        ingredientMeasurement.meals = meal
        ingredientMeasurement.name = ingredientName
        ingredientMeasurement.quantity = measurement
        return ingredientMeasurement
    }
    
    
    func editRemoveIngredientMeasurement(meal:Meal, ingredientMeasurement: IngredientMeasurement) {
        meal.removeFromIngredients(ingredientMeasurement)
        return
    }
    
    
    func editSaveMeal(meal:Meal) {
        saveChildContext()
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == .meal || listener.listenerType == .all {
            listener.onMyMealsChange(change: .update, myMeals: fetchAllMeals())
        }
        
        if listener.listenerType == .ingredient || listener.listenerType == .all {
            listener.onIngredientsChange(change: .update, ingredients: fetchAllIngredients())
        }
    }
    
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    
    func fetchAllMeals() -> [Meal] {
        if allMealsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
            // sort it by name
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            
            //initialize the results controller
            allMealsFetchedResultsController = NSFetchedResultsController<Meal>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            // set this to be the results delegate
            allMealsFetchedResultsController?.delegate = self
            
            do {
                try allMealsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch request failed: \(error)")
            }
        }
        var meals = [Meal]()
        if allMealsFetchedResultsController?.fetchedObjects != nil {
            meals = (allMealsFetchedResultsController?.fetchedObjects)!
        }
        return meals
    }
    
    func fetchAllIngredients () -> [Ingredient] {
        if allIngredientsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            allIngredientsFetchedResultsController = NSFetchedResultsController<Ingredient>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            allIngredientsFetchedResultsController?.delegate = self
            do {
                try allIngredientsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch request failed: \(error)")
            }
        }
        var ingredients = [Ingredient]()
        if allIngredientsFetchedResultsController?.fetchedObjects != nil {
            ingredients = (allIngredientsFetchedResultsController?.fetchedObjects)!
        }
        return ingredients
    }
    
    
    
    func fetchIngredientByName(ingredientName: String) -> [Ingredient]  {
        var ingredient: [Ingredient] = []
        let ingredientPredicate = NSPredicate(format: "name == %@", ingredientName)
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        fetchRequest.predicate = ingredientPredicate
        do {
            try ingredient = persistentContainer.viewContext.fetch(fetchRequest) as [Ingredient]
            print(ingredient)
        } catch {
            print("Fetch failed")
        }
        return ingredient
    }
    
    
    func fetchMeal(mealName: String, mealInstructions: String) -> [Meal]{
        var meal: [Meal] = []
        let mealPredicate = NSPredicate(format: "name == %@ AND instructions == %@", mealName, mealInstructions)
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        fetchRequest.predicate = mealPredicate
        do {
            try meal = persistentContainer.viewContext.fetch(fetchRequest) as [Meal]
        } catch {
            print("Fetch Failed")
        }
        return meal
    }
    
    
    func fetchMealByName(mealName: String) -> [Meal] {
        var meal: [Meal] = []
        let mealPredicate = NSPredicate(format: "name == %@", mealName)
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        fetchRequest.predicate = mealPredicate
        do {
            try meal = persistentContainer.viewContext.fetch(fetchRequest) as [Meal]
        } catch {
            print("Fetch Failed")
        }
        return meal
    }
    
    
    func createDefaultIngredients() {
        let searchString = INGREDIENTS_URL
        let jsonURL = URL(string: searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let task = URLSession.shared.dataTask(with: jsonURL!){(data, response, error) in
            if let error = error {
                print(error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let volumeData = try decoder.decode(DefaultIngredients.self, from: data!)
                for ingredients in volumeData.ingredients! {
                    let ingredient = NSEntityDescription.insertNewObject(forEntityName: "Ingredient", into: self.childContext) as! Ingredient
                    ingredient.name = ingredients.name
                }
                DispatchQueue.main.async {
                    self.saveChildContext()
                }
            } catch let err {
                print(err)
            }
        }
        task.resume()
    }
    
}
