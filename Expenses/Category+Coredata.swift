//
//  Category+Coredata.swift
//  Expenses
//
//  Created by Lucas Rocali on 9/15/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import Foundation
import CoreData

extension Category {
    func addSubCategory(value:SubCategory) {
        //println(value.name)
        var subcategories = self.valueForKeyPath("subcategories") as! NSMutableSet
        println(subcategories)
        subcategories.addObject(value)
    }
    
    func removeSubCategory(value:NSManagedObject) {
        var subcategories = self.valueForKeyPath("subcategories") as! NSMutableSet
        subcategories.removeObject(value)
    }
}