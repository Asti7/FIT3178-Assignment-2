//
//  IngredientData.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 10/4/21.
//

import Foundation
import UIKit

class IngredientData: NSObject, Decodable {
    var name:String
    
    private enum IngredientKeys: String, CodingKey {
        case strIngredient1
    }
    required init(from decoder: Decoder) throws {
        let ingredientContainer = try decoder.container(keyedBy: IngredientKeys.self)
        name = try ingredientContainer.decode(String.self, forKey: .strIngredient1)
    }
    
}
