//
//  SearchMealsTableViewController.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 6/4/21.
//

import UIKit

class SearchMealsTableViewController: UITableViewController, UISearchBarDelegate {
    
    let SECTION_MEALS = 0
    let SECTION_ADD_MEAL = 1
    
    let CELL_MEAL = "mealCell"
    let CELL_INFO = "addMealCell"
    
    
    var delegate: AddMealDelegate?
    
    
    var meals: [Meal] = [
        
        Meal("Pizza", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor", []),
        
        Meal("Apple", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor", []),
        
        Meal("Guava", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor", [])
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // search bar
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == SECTION_MEALS{
            return meals.count
        }else if section == SECTION_ADD_MEAL{
            if meals.isEmpty{
                return 1
            }else{
                return 0
            }
        }
        
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == SECTION_MEALS{
            let  mealCell = tableView.dequeueReusableCell(withIdentifier: CELL_MEAL, for: indexPath)
            let meal = meals[indexPath.row]
            
            mealCell.textLabel?.text = meal.name
            mealCell.detailTextLabel?.text = meal.instructions
            return mealCell
        }
        
        let infoCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
        let defaultCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
        
        defaultCell.textLabel?.text = "\(meals.count) searches"
        
        
        if meals.isEmpty{
            infoCell.textLabel?.text = "Not what you were looking for ? \n Tap to add a new meal"
            infoCell.selectionStyle = .default
            return infoCell
        }
        
        return defaultCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.section == SECTION_MEALS{
            delegate?.addMeal(meal: meals[indexPath.row])
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_MEALS{
            return true
        }
        
        return false
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        
        if editingStyle == .delete && indexPath.section == SECTION_MEALS {
            tableView.performBatchUpdates({
                self.meals.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadSections([SECTION_ADD_MEAL], with: .automatic)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


protocol AddMealDelegate{
    func addMeal(meal: Meal)
}

