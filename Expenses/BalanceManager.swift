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
    
    func getTransactions(){
        var temptransactions = database.fetchTransactions()
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
}