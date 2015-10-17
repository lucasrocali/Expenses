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
    var defaultExpenses = [
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
    var defaultIncomes = [
        "Salary":["Promotion","Salary"],
        "Gift":["From mom","From dad"],
        "Stocks":["APPL","BBDC","GGLE"]
    ]
    
    func getCategories(type:String) -> [Category] {
        let database : Database = Database()
        if (type == "Expense"){
            for (data,subdata) in defaultExpenses {
                database.saveCategoryToDB("Expense",name:data, subcategories: subdata)
                
            }
        }
        if (type == "Income"){
            for (data,subdata) in defaultIncomes {
                database.saveCategoryToDB("Income",name:data, subcategories: subdata)
                
            }
        }
        print("Created default model, lets fetch from DB")
        return database.getCategories(type)
    }
    
    func getSubCategories(belongs: Category) -> [SubCategory] {
        //getCategories()
        let database : Database = Database()
        print("Created default model, lets fetch from DB")
        return database.getSubCategories(belongs)
    }
}