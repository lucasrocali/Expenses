//
//  BalanceType.swift
//  Expenses
//
//  Created by Lucas Rocali on 10/18/15.
//  Copyright © 2015 Lucas Rocali. All rights reserved.
//

import Foundation

class TransactionType {
    var type : String
    var selectedIndexCat : Int?
    var selectedIndexSubCat : Int?
    
    var information : InfoManager = Database()
    var database : Database = Database()
    
    var category = true
    
    var categories : [Category] = []
    var subcategories : [SubCategory] = []
    
  
    
    init() {
        type = "Expense"
        categories = information.getCategories(type)
    }
    func switchType(){
        if type == "Expense"{
            type = "Income"
        } else {
            type = "Expense"
        }
        categories = information.getCategories(type)
    }
    
    func getCategories(){
        categories = database.getCategories(type)
    }
    func saveCategory(name:String){
        print("Save category \(name)")
        database.saveCategoryToDB("Expense",name:name, subcategories: [])
    }
    func saveSubCategory(name:String){
        print("Save subcatecory \(name) in \(categories[selectedIndexCat!].name)")
        database.saveSubCategoryToDB(categories[selectedIndexCat!],name:name)
    }
    func getSubCategories(){
        print("before \(subcategories.count)")
        subcategories = database.getSubCategories(categories[selectedIndexCat!])
        print("after \(subcategories.count)")
    }
    
    func backToCategories(){
        category = true
        selectedIndexCat = nil
        selectedIndexSubCat = nil

    }
    
    func getSelectedSubCategory() -> SubCategory {
        return subcategories[selectedIndexSubCat!]
    }
   

}