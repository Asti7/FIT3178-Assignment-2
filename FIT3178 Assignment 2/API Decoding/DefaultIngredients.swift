//
//  DefaultIngredients.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 10/4/21.
//

import UIKit
import Foundation

class DefaultIngredients: NSObject, Decodable {
    var ingredients: [IngredientData]?
       
    private enum CodingKeys: String, CodingKey {
       case ingredients = "meals"
    }
}
