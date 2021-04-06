//
//  MyMealsTableViewController.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 6/4/21.
//

import UIKit

class MyMealsTableViewController: UITableViewController, AddMealDelegate {
    
    
    
    
    let SECTION_MEALS = 0
    let SECTION_INFO = 1
    let CELL_MEAL = "mealCell"
    let CELL_INFO = "mealSizeCell"
    
    var myMeals: [Meal] = [
        
        Meal("Pizza", "Go to a pizza shop and buy it. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor", []),
        
        Meal("Pizza", "Go to a pizza shop and buy it. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor", []),
        
        Meal("Pizza", "Go to a pizza shop and buy it. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor", [])
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func addMeal(meal: Meal) {
        tableView.performBatchUpdates({
            self.myMeals.append(meal)
            self.tableView.insertRows(at: [IndexPath(row: myMeals.count - 1, section: SECTION_MEALS)], with: .automatic)
            self.tableView.reloadSections([SECTION_INFO], with: .automatic)
        }, completion: nil)
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SECTION_MEALS:
            return myMeals.count
        case SECTION_INFO:
            return 1
        default:
            return 0
        }
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_MEALS{
            let  mealCell = tableView.dequeueReusableCell(withIdentifier: CELL_MEAL, for: indexPath)
            let meal = myMeals[indexPath.row]
            
            mealCell.textLabel?.text = meal.name
            mealCell.detailTextLabel?.text = meal.instructions
            return mealCell
        }
        
        let infoCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
        
        if myMeals.isEmpty{
            infoCell.textLabel?.text = "No stored meals. Click + to add some."
            
        }else{
            infoCell.textLabel?.text = "\(myMeals.count) stored meal"
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
            tableView.performBatchUpdates({
                self.myMeals.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadSections([SECTION_INFO], with: .automatic)
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
     // Get the new view controller using segue.destination.
        if segue.identifier == "goToSearchMealsScreen"{
            let destination = segue.destination as! SearchMealsTableViewController
            destination.delegate = self
        }
     // Pass the selected object to the new view controller.
     }
     
    
}
