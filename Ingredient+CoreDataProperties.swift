//
//  Ingredient+CoreDataProperties.swift
//  FIT3178 Assignment 2
//
//  Created by Astitva  on 10/4/21.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var ingredientDescription: String?
    @NSManaged public var name: String?

}

extension Ingredient : Identifiable {

}
