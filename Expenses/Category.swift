//
//  Category.swift
//  Expenses
//
//  Created by Lucas Rocali on 6/23/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import Foundation
import CoreData


class Category: NSManagedObject {
    @NSManaged var type : String
    @NSManaged var name : String
    
    
}