//
//  Expense.swift
//  Expenses
//
//  Created by Lucas Rocali on 9/15/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import Foundation
import CoreData

class Expense: NSManagedObject {
    @NSManaged var value : Float
    @NSManaged var subcategory : SubCategory
}