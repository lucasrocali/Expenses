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
    
    
    //var transactions : [Transaction] = []
    var balanceManager : BalanceManager = BalanceManager()
    
    var categoryManager: CategoryManager = CategoryManager()
    //var database : Database = Database()
    
    //var date : NSDate?
    let cal = NSCalendar.currentCalendar()
    
    //var transactionType = TransactionType()
   // var transactionValue = TransactionValue()
    
    var transactionInfoManager : TransactionInfoManager = TransactionInfoManager()
    

    init() {
        print("criando classe")
        balanceManager.currentMonth = balanceManager.getMonth(balanceManager.currentDate)
        //date = NSDate()
        //categories = information.getCategories()
        //appDelegate = UIApplication().delegate as! AppDelegate
        //managedContext = appDelegate.managedObjectContext!
    }
    
    
    
    func getDay(date:NSDate) -> Int{
        return cal.ordinalityOfUnit(.Day, inUnit: .Month, forDate: date)
    }
    
    func getMonth(date:NSDate) -> String {
        return Months[cal.ordinalityOfUnit(.Month, inUnit: .Year, forDate: date) - 1]
    }
    
    
    func getDateString(date:NSDate) -> String {
        return "\(getDay(date)) \(getMonth(date))"
    }
    
        
    
}