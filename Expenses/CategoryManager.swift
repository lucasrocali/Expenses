//
//  CategoryManager.swift
//  Expenses
//
//  Created by Lucas Rocali on 2/1/16.
//  Copyright © 2016 Lucas Rocali. All rights reserved.
//

import Foundation

class CategoryManager {
    var transactions : [Transaction] = []
    
    var transacationsByCategory : [Transaction] = []
    
    var database : Database = Database()
    
    func getTransactions(){
        let temptransactions = database.fetchTransactions()
        transactions = temptransactions.sort({ $0.date.compare($1.date) == NSComparisonResult.OrderedDescending })
    }
    
    func getTransactionsByCategory() {
        transacationsByCategory = []
        for transaction: Transaction in transactions {
            print(transaction.subcategory.belongs.name)
        }
    }
}