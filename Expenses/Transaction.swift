//
//  Expense.swift
//  Expenses
//
//  Created by Lucas Rocali on 9/15/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import Foundation
import CoreData

class Transaction: NSManagedObject {
    @NSManaged var type : String
    @NSManaged var value : Float
    @NSManaged var subcategory : SubCategory
    @NSManaged var date : NSDate
}