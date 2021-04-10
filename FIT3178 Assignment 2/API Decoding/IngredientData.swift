//
//  IngredientData.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 10/4/21.
//

import Foundation
import UIKit

class IngredientData: NSObject, Decodable {
    var name: String
    var ingreDescription: String
    
    private enum IngredientKeys: String, CodingKey {
        case strIngredient
        case strDescription
    }
    
    
    required init(from decoder: Decoder) throws {
        let ingredientContainer = try decoder.container(keyedBy: IngredientKeys.self)
        self.name = try ingredientContainer.decode(String.self, forKey: .strIngredient)
        
        if let description = try ingredientContainer.decodeIfPresent(String.self, forKey: .strDescription){
            self.ingreDescription = description
        }else{
            self.ingreDescription = " "
        }
    }
}
