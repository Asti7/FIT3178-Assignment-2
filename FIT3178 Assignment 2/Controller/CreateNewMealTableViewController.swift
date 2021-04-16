//
//  CreateNewMealTableViewController.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 8/4/21.
//

import UIKit

class CreateNewMealTableViewController: UITableViewController, DatabaseListener, ChangeTitleNameDelegate {
        
    let SECION_MEAL_NAME = 0
    let SECTION_INSTRUCTIONS = 1
    let SECTION_INGREDIENT_MEASUREMENTS = 2
    let SECTION_ADD_INGREDIENT = 3

    
    var clickedMeal: Meal?
        
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        if clickedMeal == nil {
            self.navigationItem.title = "Create New Meal"
            clickedMeal = databaseController?.createEmptyMeal()
        } else {
            self.navigationItem.title = clickedMeal?.name
            clickedMeal = databaseController?.editMeal(meal: clickedMeal!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         databaseController?.addListener(listener: self)
     }

     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         databaseController?.removeListener(listener: self)
     }
    
    
    func changeTitle(name: String) {
        navigationItem.title = name
    }
    

 
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case SECTION_INGREDIENT_MEASUREMENTS:
            return clickedMeal?.ingredients?.count ?? 1
        default:
            return 1
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case SECION_MEAL_NAME:
            return "MEAL NAME"
        case SECTION_INSTRUCTIONS:
            return "INSTRUCTIONS"
        case SECTION_INGREDIENT_MEASUREMENTS:
            return "INGREDIENTS"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == SECION_MEAL_NAME{
            let mealNameCell = tableView.dequeueReusableCell(withIdentifier: "mealNameCell", for: indexPath)
            
            mealNameCell.textLabel?.text = clickedMeal?.name ?? "Enter Meal name"
            return mealNameCell
        }
        
        if indexPath.section == SECTION_INSTRUCTIONS{
            let instructionCell = tableView.dequeueReusableCell(withIdentifier: "instructionCell", for: indexPath)
            instructionCell.textLabel?.text = clickedMeal?.instructions ?? "Enter instructions"
            return instructionCell
        }
        
        if indexPath.section == SECTION_INGREDIENT_MEASUREMENTS{
            let ingredientCell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
            
            ingredientCell.textLabel?.text = (clickedMeal?.ingredients?.allObjects as! [IngredientMeasurement])[indexPath.row].name
            
            ingredientCell.detailTextLabel?.text = (clickedMeal?.ingredients?.allObjects as! [IngredientMeasurement])[indexPath.row].quantity
        
            return ingredientCell
        }
        
        if indexPath.section == SECTION_ADD_INGREDIENT{
            let addIngredientCell = tableView.dequeueReusableCell(withIdentifier: "addIngredientCell", for: indexPath)
            addIngredientCell.textLabel?.text = "Add Ingredient"
            return addIngredientCell
        }
        
        let defaultCell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        defaultCell.textLabel?.text = "Unable to load screen"
        
        return defaultCell
    }
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     return true
     }
    
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_INGREDIENT_MEASUREMENTS {
            let mealIngredients = clickedMeal?.ingredients?.allObjects as! [IngredientMeasurement]
            let ingredient = mealIngredients[indexPath.row] as IngredientMeasurement
            let _ = databaseController?.editRemoveIngredientMeasurement(meal: clickedMeal!, ingredientMeasurement: ingredient)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
     }
     

    
    
    @IBAction func saveMeal(_ sender: UIBarButtonItem) {
        if clickedMeal?.name == nil || clickedMeal?.instructions == nil || clickedMeal?.ingredients?.count == 0 {
            displayMessage(title: "Missing Fields", message: "A meal must have a name and some ingredients")
            return
        }
        
        
        let _ = databaseController?.editSaveMeal(meal: clickedMeal!)
        navigationController?.popViewController(animated: true)
        return
    }
    
    
    
    
    func onMyMealsChange(change: DatabaseChange, myMeals: [Meal]) {
        tableView.reloadData()
    }
    
    func onIngredientsChange(change: DatabaseChange, ingredients: [Ingredient]) {
    }

    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToEditNameScreen"{
            let destination = segue.destination as! EditNameViewController
            destination.delegate = self
            destination.meal = self.clickedMeal
            destination.databaseController = self.databaseController
        }else if segue.identifier == "goToEditInstructionScreen"{
            let destination = segue.destination as! EditInstructionsViewController
            destination.meal = self.clickedMeal
            destination.databaseController = self.databaseController
        }else if segue.identifier == "goToAddIngredientScreen"{
            let destination = segue.destination as! AddIngredientTableViewController
            destination.meal = self.clickedMeal
            destination.databaseController = self.databaseController
        }
    }
}


extension CreateNewMealTableViewController{
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
        preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
        UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
