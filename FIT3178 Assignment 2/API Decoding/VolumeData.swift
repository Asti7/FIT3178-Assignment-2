//
//  VolumeData.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 10/4/21.
//

import UIKit
import Foundation

class VolumeData: NSObject, Decodable {
    var books: [MealData]?
    
 private enum CodingKeys: String, CodingKey {
    case books = "meals"
 }
}
