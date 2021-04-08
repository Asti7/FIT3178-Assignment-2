//
//  CreateNewMealTableViewController.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 8/4/21.
//

import UIKit

class CreateNewMealTableViewController: UITableViewController, EditNameDelegate, EditInstructionsDelegate {
    
    
       
    
    let SECION_MEAL_NAME = 0
    let SECTION_INSTRUCTIONS = 1
    let SECTION_INGREDIENTS = 2
    let SECTION_ADD_INGREDIENT = 3
    
    
    
    var ingredients:[Ingredient] = [Ingredient(name: "Apple", ingredientDescription: "Lorem ipsum"),Ingredient(name: "Apple", ingredientDescription: "Lorem ipsum"),Ingredient(name: "Apple", ingredientDescription: "Lorem ipsum")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func editName(name: String) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: SECION_MEAL_NAME))
        cell?.textLabel?.text = name
    }
    
    
    func editInstructions(instructions: String) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: SECTION_INSTRUCTIONS))
        cell?.textLabel?.text = instructions
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case SECION_MEAL_NAME:
            return 1
        case SECTION_INSTRUCTIONS:
            return 1
        case SECTION_INGREDIENTS:
            return ingredients.count
        case SECTION_ADD_INGREDIENT:
            return 1
        default:
            return 0
        }
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case SECION_MEAL_NAME:
            return "MEAL NAME"
        case SECTION_INSTRUCTIONS:
            return "INSTRUCTIONS"
        case SECTION_INGREDIENTS:
            return "INGREDIENTS"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == SECION_MEAL_NAME{
            let mealNameCell = tableView.dequeueReusableCell(withIdentifier: "mealNameCell", for: indexPath)
            mealNameCell.textLabel?.text = "Tap to enter meal name"
            return mealNameCell
        }
        
        if indexPath.section == SECTION_INSTRUCTIONS{
            let instructionCell = tableView.dequeueReusableCell(withIdentifier: "instructionCell", for: indexPath)
            instructionCell.textLabel?.text = "Tap to enter meal instruction"
            return instructionCell
        }
        
        if indexPath.section == SECTION_INGREDIENTS{
            let ingredientCell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
            ingredientCell.textLabel?.text = ingredients[indexPath.row].name
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
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    
    
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     return true
     }
    
    

    
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete && indexPath.section == SECTION_INGREDIENTS {
            tableView.performBatchUpdates({
                self.ingredients.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadData()
            }, completion: nil)
        }
     
     }
     
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToEditNameScreen"{
            let destination = segue.destination as! EditNameViewController
            destination.delegate = self
        }else if segue.identifier == "goToEditInstructionScreen"{
            let destination = segue.destination as! EditInstructionsViewController
            destination.delegate = self
        }
    }
}
