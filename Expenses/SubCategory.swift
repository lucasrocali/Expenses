//
//  SubCategory.swift
//  Expenses
//
//  Created by Lucas Rocali on 9/12/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import Foundation
import CoreData

class SubCategory: NSManagedObject{
    @NSManaged var name : String
    @NSManaged var belongs : Category
}