//
//  AddIngredientTableViewController.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 6/4/21.
//

import UIKit

class AddIngredientTableViewController: UITableViewController {

    
    var databaseController: DatabaseProtocol!
    var meal: Meal!
    
    var ingredients:[Ingredient] = []
    var ingredient: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredients = databaseController.fetchAllIngredients()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ingredients.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)

        let ingredeint = ingredients[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = ingredeint.name
        
        if ingredeint.ingredientDescription == " "{
            cell.selectionStyle = .none
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ingredient = ingredients[indexPath.row].name
    
        let dialouge = UIAlertController(title: "Add measurement",
                                         message: "Enter measurement for \(ingredient ?? "this ingredient")", preferredStyle: .alert)
        
        let emptyDialouge = UIAlertController(title: "Empty Measurement",
                                              message: "You must enter measurement for \(ingredient ?? "this ingredient").", preferredStyle: .alert)
        emptyDialouge.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        dialouge.addTextField { (textField) in
            textField.placeholder = "Measurement"
        }
        dialouge.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        dialouge.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak dialouge](_) in
            
            guard let textFields = dialouge?.textFields?[0] else{
                return
            }
            if let measurement = textFields.text{
                
                if measurement.isEmpty{
                    self.present(emptyDialouge, animated: true, completion: nil)
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }else{
                   let _ =  self.databaseController.editAddIngredientMeasurement(meal: self.meal, ingredientName: self.ingredient!, measurement: measurement)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }))
        self.present(dialouge, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "goToIngredientDetailScreen"{
            let destination = segue.destination as! IngredientDetailViewController
            
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell){
                destination.detail = ingredients[indexPath.row].ingredientDescription
                destination.ingredientTitle = ingredients[indexPath.row].name
            }
        }
    }
    

}
