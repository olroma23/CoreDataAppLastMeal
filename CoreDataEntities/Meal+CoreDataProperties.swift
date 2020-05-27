//
//  Meal+CoreDataProperties.swift
//  LastTimeMeal
//
//  Created by Roman Oliinyk on 25.05.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//
//

import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal")
    }

    @NSManaged public var date: Date?
    @NSManaged public var user: User?

}
