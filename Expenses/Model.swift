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
    var Months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
    ]
    
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
    var transactions : [Transaction] = []
    
    var database : Database = Database()
    
    var date : NSDate?
    let cal = NSCalendar.currentCalendar()
    
    init() {
        print("criando classe")
        date = NSDate()
        //categories = information.getCategories()
        //appDelegate = UIApplication().delegate as! AppDelegate
        //managedContext = appDelegate.managedObjectContext!
    }
    func getTransactions(){
        transactions = database.fetchTransactions()
    }
    func saveTransaction(type:String,value:Float,subcategory:SubCategory){
        /*
        let day = cal.ordinalityOfUnit(.Day, inUnit: .Month, forDate: date)
        let month = cal.ordinalityOfUnit(.Month, inUnit: .Year, forDate: date)
        let year = cal.ordinalityOfUnit(.Year, inUnit: .Era, forDate: date)
        print("Day \(day) month \(month) year \(year)")*/
        database.saveTransactionToDB(type,value:value,subcategory:subcategory,date:date!)
    }
    
    func getDay() -> Int{
        return cal.ordinalityOfUnit(.Day, inUnit: .Month, forDate: date!)
    }
    
    func getMonth() -> String {
        return Months[cal.ordinalityOfUnit(.Month, inUnit: .Year, forDate: date!) - 1]
    }
    
    func setDate(date:NSDate) {
        self.date = date
    }
    
        
    
}