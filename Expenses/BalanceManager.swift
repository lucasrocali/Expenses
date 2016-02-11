//
//  BalanceManager.swift
//  Expenses
//
//  Created by Lucas Rocali on 10/20/15.
//  Copyright © 2015 Lucas Rocali. All rights reserved.
//

import Foundation

class BalanceManager {
    var transactions : [Transaction] = []
    
    var expenses : [Transaction] = []
    var incomes : [Transaction] = []
    
    var database : Database = Database()
    
    let currentDate = NSDate()
    let cal = NSCalendar.currentCalendar()
    
    var currentMonth : Int?
    
    func getTransactions(){
        let temptransactions = database.fetchTransactions()
        transactions = temptransactions.sort({ $0.date.compare($1.date) == NSComparisonResult.OrderedDescending })
        getExpenses()
        getIncomes()
    }
    func getExpenses() {
        expenses = []
        for transaction: Transaction in transactions {
            if transaction.type == "Expense"{
                expenses.append(transaction)
            }
        }
    }
    
    func getIncomes() {
        incomes = []
        for transaction: Transaction in transactions {
            if transaction.type == "Income"{
                incomes.append(transaction)
            }
        }
    }
    
    func getTotalExpense() -> Float {
        var totalExpenses : Float = 0
        for expense : Transaction in expenses {
            totalExpenses += expense.value
        }
        return totalExpenses
    }
    func getTotalIncome() -> Float{
        var totalIncomes : Float = 0
        for income : Transaction in incomes {
            totalIncomes += income.value
        }
        return totalIncomes
    }
    
    func getTotalBalance() -> Float {
        return getTotalIncome() - getTotalExpense()
    }
    func getDay(date:NSDate) -> Int{
       
        return cal.ordinalityOfUnit(.Day, inUnit: .Month, forDate: date)
    }
    func getMonth(date:NSDate) -> Int {
        
        return cal.ordinalityOfUnit(.Month, inUnit: .Year, forDate: date)
    }
    
    
    func getTotalMonthExpense() -> Float {
       
        //let currentMonth = getMonth(currentDate)
        var totalExpenses : Float = 0
        for expense : Transaction in expenses {
            if currentMonth! == getMonth(expense.date){
                totalExpenses += expense.value
            }
        }
        return totalExpenses
    }
    func getTotalMonthIncome() -> Float{
        //let currentMonth = getMonth(currentDate)
        var totalIncomes : Float = 0
        for income : Transaction in incomes {
             if currentMonth! == getMonth(income.date){
                totalIncomes += income.value
            }
        }
        return totalIncomes
    }
    
    func getTotalMonthBalance() -> Float {
        //getTransactions()
        return getTotalMonthIncome() - getTotalMonthExpense()
    }
    
    func getAvarageDayExpense() ->Float {
        var total : Float = 0
        let nOfDays = getDay(currentDate)
        total = getTotalMonthExpense()/Float(nOfDays)
        return total
    }
    func getAvarageDayIncome() -> Float {
        var total : Float = 0
        let nOfDays = getDay(currentDate)
        total = getTotalMonthIncome()/Float(nOfDays)
        return total
    }
    func getAvarageDayBalance() -> Float {
        return getAvarageDayIncome() - getAvarageDayExpense()
    }
    func getProjectedMonthExpense() ->Float {
        var total : Float = 0
        total = getAvarageDayExpense()*31
        return total
    }
    func getProjectedMonthIncome() ->Float {
        var total : Float = 0
        total = getAvarageDayIncome()*31
        return total
    }
    func getProjectedMonthBalance() ->Float {
        var total : Float = 0
        total = getAvarageDayBalance()*31
        return total
    }
    
    func setCurrentMonth(month:Int) {
        self.currentMonth! = month
    }
    
    
}