//
//  TransactionInfo.swift
//  Expenses
//
//  Created by Lucas Rocali on 10/20/15.
//  Copyright © 2015 Lucas Rocali. All rights reserved.
//

import Foundation

class TransactionInfo{
    var type : String?
    var value : Float?
    var subcategory : SubCategory?
    var date : NSDate?
    
    func setType(type:String){
        self.type = type
    }
    func setValue(value:Float){
        self.value = value
    }
    func setSubCategory(subcategory:SubCategory){
        self.subcategory = subcategory
    }
    func setDate(date:NSDate){
        self.date = date
    }
    
    func getType() -> String{
        return self.type!
    }
    func getValue() -> Float{
        return self.value!
    }
    func getSubCategory() -> SubCategory{
        return self.subcategory!
    }
    func getDate() -> NSDate{
        return self.date!
    }
    
}