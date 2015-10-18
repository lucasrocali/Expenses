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

    /*var integerNum = 0
    var calculating = "0"
    var calculator : Float = 0.00
    var calculationText = ""
    var oneDot : Bool = false
    var oneOp : Bool = false
    var calculatorNumbers = ["Photo","7","8","9","/","Date","4","5","6","x","Note","1","2","3","-","Location","0",".","=","+"]*/
    
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
    func saveExpense(value:Float){
        database.saveExpenseToDB(value)
    }
    
        
    
}