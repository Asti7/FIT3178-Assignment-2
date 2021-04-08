//
//  EditInstructionsViewController.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 6/4/21.
//

import UIKit

class EditInstructionsViewController: UIViewController {

    @IBOutlet weak var editInstructionsTextView: UITextView!
    
    
    
    var delegate: EditInstructionsDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSavePressed(_ sender: UIBarButtonItem) {
        
        if let instructionsText = editInstructionsTextView.text{
            delegate?.editInstructions(instructions: instructionsText)
            navigationController?.popViewController(animated: true)
        }
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


protocol EditInstructionsDelegate{
    func editInstructions(instructions: String)
}

