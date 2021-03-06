//
//  EditInstructionsViewController.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 6/4/21.
//

import UIKit

class EditInstructionsViewController: UIViewController {

    @IBOutlet weak var editInstructionsTextView: UITextView!
    
    var databaseController: DatabaseProtocol!
    var meal: Meal!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        editInstructionsTextView.text = meal.instructions
    }
    
    @IBAction func onSavePressed(_ sender: UIBarButtonItem) {
        
        if editInstructionsTextView.text != "" {
            let instructions =  editInstructionsTextView.text!
            let _ = databaseController.editMealInstructions(meal: meal, instructions: instructions)
            navigationController?.popViewController(animated: true)
            return
        }
        
        displayMessage(title: "Missing Field", message: "Instructions for the meal should be provided")
    }
}


extension EditInstructionsViewController{
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
        preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
        UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

