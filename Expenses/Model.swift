//
//  Model.swift
//  Expenses
//
//  Created by Lucas Rocali on 6/22/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import Foundation
import CoreData
import UIKit
/*
NAME should be BALANCE
To do: 
Chain of responsability between database and model DONE
Create logic to manage expense/income DONE






*/

class Model {
    
    //Singleton
    private struct Static {
        static var instance: Model?
    }
    class var sharedInstance: Model {
        if (Static.instance == nil) {
            Static.instance = Model()
           
        }
        return Static.instance!
    }

    var expenses : [Expense] = []
    
    var database : Database = Database()
    
    
    
    init() {
        print("criando classe")
        //categories = information.getCategories()
        //appDelegate = UIApplication().delegate as! AppDelegate
        //managedContext = appDelegate.managedObjectContext!
    }
    func getExpenses(){
        expenses = database.fetchExpenses()
    }
    func saveExpense(value:Float,subcategory:SubCategory){
        database.saveExpenseToDB(value,subcategory:subcategory)
    }
    
        
    
}