//
//  EditNameViewController.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 6/4/21.
//

import UIKit

class EditNameViewController: UIViewController {

    @IBOutlet weak var editNameTextField: UITextField!
    
    @IBAction func onSavePressed(_ sender: UIBarButtonItem) {
        
        if let nameText = editNameTextField.text{
            delegate?.editName(name: nameText)
            print(nameText)
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    var delegate: EditNameDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol EditNameDelegate{
    func editName(name: String)
}
