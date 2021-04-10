//
//  MyMealsTableViewController.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 6/4/21.
//

import UIKit

class MyMealsTableViewController: UITableViewController, DatabaseListener{
   
    
    

    let SECTION_MEALS = 0
    let SECTION_INFO = 1
    let CELL_MEAL = "mealCell"
    let CELL_INFO = "mealSizeCell"
    
    
    
    
    var currentMeals: [Meal] = []
    
    weak var databaseController: DatabaseProtocol?
    
    var listenerType: ListenerType = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SECTION_MEALS:
            return currentMeals.count
        case SECTION_INFO:
            return 1
        default:
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_MEALS{
            let  mealCell = tableView.dequeueReusableCell(withIdentifier: CELL_MEAL, for: indexPath)
            let meal = currentMeals[indexPath.row]
            
            mealCell.textLabel?.text = meal.name
            mealCell.detailTextLabel?.text = meal.instructions
            return mealCell
        }
        
        let infoCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
        
        if currentMeals.isEmpty{
            infoCell.textLabel?.text = "No stored meals. Click + to add some."
            
        }else{
            infoCell.textLabel?.text = "\(currentMeals.count) stored meal"
        }
        
        return infoCell
     }
     
    
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_MEALS {
            return true
        }
        return false
     }
     
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {        
        if editingStyle == .delete && indexPath.section == SECTION_MEALS {
            self.databaseController!.removeMeal(meal: currentMeals[indexPath.row])
        }
     }
    
    //MARK: - DatabaseListener protocol methods
    
    
    func onMyMealsChange(change: DatabaseChange, myMeals: [Meal]) {
        currentMeals = myMeals
        tableView.reloadData()
    }
    func onIngredientsChange(change: DatabaseChange, ingredients: [Ingredient]) {
    }
    
     
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToMealDetailScreen"{
            let destination = segue.destination as! CreateNewMealTableViewController
            
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell){
                destination.clickedMeal = currentMeals[indexPath.row]
            }
            
        }
        
     }
     
    
}
