//
//  BalanceType.swift
//  Expenses
//
//  Created by Lucas Rocali on 10/18/15.
//  Copyright © 2015 Lucas Rocali. All rights reserved.
//

import Foundation

class BalanceType {
    var type : String
    
    init() {
        type = "Expense"
    }
    func switchType(){
        if type == "Expense"{
            type = "Income"
        } else {
            type = "Expense"
        }
    }
}