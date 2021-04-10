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
    
    var indicator = UIActivityIndicatorView()
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .all
    var searchedMeals = [MealData]()
    
    
    let REQUEST_STRING = "https://www.themealdb.com/api/json/v1/1/search.php?s="
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        // search bar
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.tableView.center
        self.view.addSubview(indicator)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, searchText.count > 0 else {
            return;
        }
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.clear
        searchedMeals.removeAll()
        tableView.reloadData()
        URLSession.shared.invalidateAndCancel()
        requestMeals(mealName: searchText)
    }
    
    

    func requestMeals(mealName: String) {
        let searchString = REQUEST_STRING + mealName
        let jsonURL = URL(string: searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let task = URLSession.shared.dataTask(with: jsonURL!){(data, response, error) in
            DispatchQueue.main.async{
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
            }
            
            if let error = error {
                print(error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let volumeData = try decoder.decode(VolumeData.self, from: data!)
                if let books = volumeData.books {
                    self.searchedMeals.append(contentsOf: books)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch let err {
                print(err)
            }
        }
        task.resume()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == SECTION_MEALS{
            return searchedMeals.count
        }else if section == SECTION_ADD_MEAL{
            if searchedMeals.isEmpty{
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
            let meal = searchedMeals[indexPath.row]
            
            mealCell.textLabel?.text = meal.name
            mealCell.detailTextLabel?.text = meal.instructions
            return mealCell
        }
        
        let infoCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
        let defaultCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
        
        defaultCell.textLabel?.text = "\(searchedMeals.count) searches"
        
        
        if searchedMeals.isEmpty{
            infoCell.textLabel?.text = "Not what you were looking for ? \n Tap to add a new meal"
            infoCell.selectionStyle = .default
            return infoCell
        }
        
        return defaultCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == SECTION_ADD_MEAL {
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }
        
        let selectedMeal = searchedMeals[indexPath.row]
        
        let doesExist = databaseController?.fetchMeal(mealName: selectedMeal.name, mealInstructions: selectedMeal.instructions)
        if doesExist!.count > 0 {
            displayMessage(title: "Duplicate Meal", message: "A meal with the same name and instructions already exists in your list")
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        // add the cocktail to the database
        let meal = databaseController?.addMeal(name: searchedMeals[indexPath.row].name, instructions: searchedMeals[indexPath.row].instructions)
        let ingredients = selectedMeal.ingredients
        let measurements = selectedMeal.ingredientMeasurement
        
        // given the generated cocktail, use the delegate to add ingredients
        for n in 0...searchedMeals[indexPath.row].ingredients.count - 1 {
            let measurement = (n >= measurements.count ? "N/A" : measurements[n]) // some ingredients don't have measurements, so replace with n/a if no ingredient provided
            let _ = databaseController?.addIngredientMeasurement(meal: meal!, ingredientName: ingredients[n], measurement: measurement)
        }
        navigationController?.popViewController(animated: false)
        return
        
    }

    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
        preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
        UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
     
    
}

