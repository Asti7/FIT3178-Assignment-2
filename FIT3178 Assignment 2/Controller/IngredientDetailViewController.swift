//
//  IngredientDetailViewController.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 7/4/21.
//

import UIKit

class IngredientDetailViewController: UIViewController {

    @IBOutlet weak var ingredientDetail: UITextView!
    
    var detail: String?
    var ingredientTitle: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ingredientDetail.text = detail
        navigationItem.title = ingredientTitle
    }

}
