//
//  InfoManager.swift
//  Expenses
//
//  Created by Lucas Rocali on 10/17/15.
//  Copyright © 2015 Lucas Rocali. All rights reserved.
//

import Foundation

protocol InfoManager {
    var nextInfo : InfoManager? {get set}
    func getCategories(type:String) -> [Category]
    func getSubCategories(belongs:Category) -> [SubCategory]
}