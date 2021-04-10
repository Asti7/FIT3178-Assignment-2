//
//  EditNameViewController.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 6/4/21.
//

import UIKit

class EditNameViewController: UIViewController {

    @IBOutlet weak var editNameTextField: UITextField!
    var delegate: ChangeTitleNameDelegate?
    var databaseController: DatabaseProtocol!
    var meal: Meal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func onSavePressed(_ sender: UIBarButtonItem) {
        if editNameTextField.text != "" {
            let name =  editNameTextField.text!
            let _ = databaseController.editMealName(meal: meal!, name: name)
            delegate?.changeTitle(name: name)
            navigationController?.popViewController(animated: true)
            return
        }
        displayMessage(title: "Missing field", message: "A name must be provided for the meal")
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
        preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
        UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}

protocol ChangeTitleNameDelegate {
    func changeTitle(name:String)
}
