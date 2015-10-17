//
//  DefaultModel.swift
//  Expenses
//
//  Created by Lucas Rocali on 10/17/15.
//  Copyright © 2015 Lucas Rocali. All rights reserved.
//

import Foundation

class DefaultInfo : InfoManager {
    var nextInfo : InfoManager? = nil
    var defaultData = [
        "General":["General10","General2","General3"],
        "House":["House1","House2","House3"],
        "Food":["Food1","Food2","Food3"],
        "Groceries":["Groceries1","Groceries2","Groceries3"],
        "Payments":["Payments1","Payments2","Payments3"],
        "Transport":["Transport1","Transport2","Transport3"],
        "Utilities":["Utilities1","Utilities2","Utilities3"],
        "Car":["Car1","Car2","Car3"],
        "Personal":["Personal1","Personal2","Personal3"]
    ]
    
    func getCategories() -> [Category] {
        let database : Database = Database()
        for (data,subdata) in defaultData {
            database.saveCategoryToDB(data, subcategories: subdata)
              
        }
        print("Created default model, lets fetch from DB")
        return database.getCategories()
    }
}