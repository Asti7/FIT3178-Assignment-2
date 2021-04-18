//
//  IngredientMeasurement+CoreDataProperties.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 18/4/21.
//
//

import Foundation
import CoreData


extension IngredientMeasurement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IngredientMeasurement> {
        return NSFetchRequest<IngredientMeasurement>(entityName: "IngredientMeasurement")
    }

    @NSManaged public var name: String?
    @NSManaged public var quantity: String?
    @NSManaged public var meals: Meal?

}

extension IngredientMeasurement : Identifiable {

}
