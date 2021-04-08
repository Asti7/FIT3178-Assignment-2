//
//  AddIngredientTableViewController.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 6/4/21.
//

import UIKit

class AddIngredientTableViewController: UITableViewController {

    
    var ingredients: [Ingredient] = [
        Ingredient(name: "Apple", ingredientDescription: "Fruit"),
        Ingredient(name: "Apple", ingredientDescription: "Fruit"),
        Ingredient(name: "Apple", ingredientDescription: "Fruit"),
        Ingredient(name: "Apple", ingredientDescription: "Fruit"),
        Ingredient(name: "Apple", ingredientDescription: "Fruit"),
        Ingredient(name: "Apple Pie Vanilla Ice Cream ", ingredientDescription: "Lorem ipsum")
    ]

    
    
    func displayMessage(ingredient: String){
        let dialouge = UIAlertController(title: "Add measurement", message: "Enter measurement for \(ingredient)", preferredStyle: .alert)
        
        let emptyDialouge = UIAlertController(title: "Empty Measurement", message: "You must enter a measurement for \(ingredient).", preferredStyle: .alert)
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
                print(measurement)
                
                if measurement.isEmpty{
                    self.present(emptyDialouge, animated: true, completion: nil)
                }
            }
        }))
        self.present(dialouge, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
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

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredient = ingredients[indexPath.row].name
        displayMessage(ingredient: ingredient)
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
       
        if segue.identifier == "goToIngredientDetailScreen"{
            let destination = segue.destination as! IngredientDetailViewController
            
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell){
                destination.detail = ingredients[indexPath.row].ingredientDescription
                destination.ingredientTitle = ingredients[indexPath.row].name
            }
        }
        
        
    }
    

}

protocol AddIngredientDelegate{
    func addIngredient(ingredient: Ingredient)
}
