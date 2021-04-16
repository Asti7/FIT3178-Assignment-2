//
//  CoreDataController.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 10/4/21.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate{
  
    
    // creating NSFetchedResultsController refrences
    var allMealsFetchedResultsController: NSFetchedResultsController<Meal>?
    var allIngredientsFetchedResultsController: NSFetchedResultsController<Ingredient>?
    
    // url for api call
    let INGREDIENTS_URL = "https://www.themealdb.com/api/json/v1/1/list.php?i=list"
    
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    override init() {
        // Initialising core data for contexts i.e., parent and child
        persistentContainer = NSPersistentContainer(name: "Assignment2-DataModel")
        persistentContainer.loadPersistentStores(){(description, error) in
            if let error = error {
                fatalError("Failed to load core data stack: \(error)")
            }
        }
        childContext.parent = self.persistentContainer.viewContext
        super.init()
        
        // if it is the initial launch, add all the ingredients
        if fetchAllIngredients().count == 0 {
            createDefaultIngredients()
        }
    }
    
    
    // save the context which is actually going to write to coredata.
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save to CoreData: \(error)")
            }
        }
        
    }
    
    // saving the child context, which is for changes in coredata and this is will save to the parent.
    func saveChildContext() {
        if childContext.hasChanges {
             do {
                 try childContext.save()
             } catch {
                 fatalError("Failed to save to child Context CoreData: \(error)")
             }
         }
         
    }
    
    // notifying listeners that an event has happened.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allMealsFetchedResultsController { listeners.invoke { (listener) in
            if listener.listenerType == .meal || listener.listenerType == .all {
                listener.onMyMealsChange(change: .update, myMeals: fetchAllMeals())
            }}
        }
    }
    
    
    //MARK: - DatabaseProtocol methods
    
    func cleanup() {
        saveContext()
        saveChildContext()
    }
    
    
    // adding meal to coredata stack.
    func addMeal(name: String, instructions: String) -> Meal {
        let meal = NSEntityDescription.insertNewObject(forEntityName: "Meal", into: persistentContainer.viewContext) as! Meal
        meal.name = name
        meal.instructions = instructions
        return meal
    }
    
    // adding ingredient measurement to coredata stack.
    func addIngredientMeasurement(meal: Meal, ingredientName: String, measurement: String) -> IngredientMeasurement {
        let ingredientMeasurement = NSEntityDescription.insertNewObject(forEntityName: "IngredientMeasurement", into: persistentContainer.viewContext) as! IngredientMeasurement
        ingredientMeasurement.meals = meal
        ingredientMeasurement.name = ingredientName
        ingredientMeasurement.quantity = measurement
        
        return ingredientMeasurement
    }
    
    // adding ingredient to coredata stack.
    func addIngredient(name: String) -> Ingredient {
        let ingredient = NSEntityDescription.insertNewObject(forEntityName: "Ingredient", into: persistentContainer.viewContext) as! Ingredient
        ingredient.name = name
        return ingredient
    }
    
    // removing a meal from coredata stack.
    func removeMeal(meal: Meal) {
        persistentContainer.viewContext.delete(meal)
    }
    
    // removing ingredient measurement from a meal in coredata stack.
    func removeIngredientFromMeal(meal: Meal, ingredientMeasurement: IngredientMeasurement) {
        meal.removeFromIngredients(ingredientMeasurement)
    }
    
    
    // creates a copy of a parent context and removes any previous childcontext objects.
    func editMeal(meal: Meal) -> Meal {
        childContext.rollback()
        let childMeal = childContext.object(with: meal.objectID) as! Meal
        return childMeal
    }
    
    
    // creates an empty meal within the childcontext and discards previous childcontext objects.
    func createEmptyMeal() -> Meal {
        childContext.rollback()
        let emptyMeal = NSEntityDescription.insertNewObject(forEntityName: "Meal", into: childContext) as! Meal
        return emptyMeal
    }
    
    // edits the name for a meal within the childcontext.
    func editMealName(meal: Meal, name: String) {
        meal.name = name
        return
    }
    
    // edits the instructions for a meal within the chidcontext.
    func editMealInstructions(meal: Meal, instructions: String) {
        meal.instructions = instructions
        return
    }
    
    // adds an ingredient measurement to a meal child context.
    func editAddIngredientMeasurement(meal:Meal, ingredientName: String, measurement: String) -> IngredientMeasurement {
        let ingredientMeasurement = NSEntityDescription.insertNewObject(forEntityName: "IngredientMeasurement", into: childContext) as! IngredientMeasurement
        ingredientMeasurement.meals = meal
        ingredientMeasurement.name = ingredientName
        ingredientMeasurement.quantity = measurement
        return ingredientMeasurement
    }
    
    
    // removes an ingredient measurement from a meal child context.
    func editRemoveIngredientMeasurement(meal:Meal, ingredientMeasurement: IngredientMeasurement) {
        meal.removeFromIngredients(ingredientMeasurement)
        return
    }
    
    
    // saves the child context.
    func editSaveMeal(meal:Meal) {
        saveChildContext()
    }
    
    
    
    // creating database listeners which delegates can listen to
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == .meal || listener.listenerType == .all {
            listener.onMyMealsChange(change: .update, myMeals: fetchAllMeals())
        }
        
        if listener.listenerType == .ingredient || listener.listenerType == .all {
            listener.onIngredientsChange(change: .update, ingredients: fetchAllIngredients())
        }
    }
    
    // removes a database listener.
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    
    //MARK: - Default ingredients

    // gets called on initial launch and uses themealdb api for getting ingredients
    func createDefaultIngredients() {
        let searchURL = INGREDIENTS_URL
        let jsonURL = URL(string: searchURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
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
                    ingredient.ingredientDescription = ingredients.ingredientDescription
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
    
    
    
    
    //MARK: - Fetch methods for getting data from coredata.
    
    func fetchAllMeals() -> [Meal] {
        if allMealsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
            
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            
            allMealsFetchedResultsController = NSFetchedResultsController<Meal>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
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
    
}
