//
//  TransactionManager.swift
//  Expenses
//
//  Created by Lucas Rocali on 10/20/15.
//  Copyright © 2015 Lucas Rocali. All rights reserved.
//

import Foundation

class TransactionInfoManager {
    
    var transactionInfo : TransactionInfo = TransactionInfo()
    
    //Category part
    var selectedIndexCat : Int?
    var selectedIndexSubCat : Int?
    
    var information : InfoManager = Database()
    var database : Database = Database()
    
    var selectCategoryState = true
    
    var categories : [Category] = []
    var subcategories : [SubCategory] = []
    
    //Value part
    var integerNum = 0
    var calculating = "0"
    var totalText = "0"
    var calculationText = ""
    var oneDot : Bool = false
    var oneOp : Bool = false
    var calculatorNumbers = ["Date","7","8","9","/","Photo","4","5","6","x","Note","1","2","3","-","Loc","0",".","=","+"]
    let calculator:Calculator = Calculator()
    
    init() {
        defaultTransactionInfo()
    }
    
    func saveTransaction(){
        /*
        let day = cal.ordinalityOfUnit(.Day, inUnit: .Month, forDate: date)
        let month = cal.ordinalityOfUnit(.Month, inUnit: .Year, forDate: date)
        let year = cal.ordinalityOfUnit(.Year, inUnit: .Era, forDate: date)
        print("Day \(day) month \(month) year \(year)")*/
        transactionInfo.setId(getRandonId())
        print(getRandonId())
        database.saveTransactionToDB(transactionInfo)
    }
    func updateTransaction(){
        database.updateTransactionToDB(transactionInfo)
    }
    
    func getRandonId() -> String {
        let len = 10
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString as String
    }
    
    func deleteTransaction(transaction:Transaction){
        database.deleteTransaction(transaction)
    }
    
    func defaultTransactionInfo() {
        transactionInfo.setType("Expense")
        transactionInfo.setValue(0)
        transactionInfo.setDate(NSDate())
        getCategories()
        
        backToCategories()
        resetInput()
    }
    
    func setTransactionInfo(transactionToEdit : Transaction) {
        transactionInfo.setType(transactionToEdit.type)
        transactionInfo.setValue(transactionToEdit.value)
        transactionInfo.setDate(transactionToEdit.date)
        transactionInfo.setId(transactionToEdit.id)
        getCategories()
        selectCategoryState = false
        
        selectedIndexCat = getCatIndex(transactionToEdit.subcategory.belongs)
        getSubCategories()

        selectedIndexSubCat = getSubCatIndex(transactionToEdit.subcategory)
        
        //calculating
        integerNum = 2
        //calculating = "0"
        totalText = "\(transactionToEdit.value)"
        calculationText = "\(transactionToEdit.value)"
        oneDot = true
        //oneOp = false
        
    }
    func switchType(){
        if transactionInfo.getType() == "Expense"{
            transactionInfo.setType("Income")
        } else {
            transactionInfo.setType("Expense")
        }
        categories = information.getCategories(transactionInfo.getType())
    }
    
    func getCategories(){
        categories = information.getCategories(transactionInfo.getType())
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
        subcategories = information.getSubCategories(categories[selectedIndexCat!])
        print("after \(subcategories.count)")
    }
    
    func backToCategories(){
        selectCategoryState = true
        selectedIndexCat = nil
        selectedIndexSubCat = nil
        
    }
    
    func setSubCategory(){
        transactionInfo.setSubCategory(subcategories[selectedIndexSubCat!])
    }
    
    func getSelectedSubCategory() -> SubCategory {
        return subcategories[selectedIndexSubCat!]
    }
    
    func getCatIndex(selectedCategory:Category) -> Int {
        for (var i = 0; i < categories.count ; i++) {
            if selectedCategory.name == categories[i].name {
                return i
            }
        }
        return 0
    }
    
    func getSubCatIndex(selectedSubCategory:SubCategory) -> Int {
        for (var i = 0; i < subcategories.count ; i++) {
            if selectedSubCategory.name == subcategories[i].name {
                return i
            }
        }
        return 0
    }
    
    
    func resetInput() {
        integerNum = 0
        calculating = "0"
        totalText = "0"
        calculationText = "0"
        oneDot = false
        oneOp = false
    }
    func getTotalAndCalculation(indexPressed:Int) -> (String,String) {
        let keyPressed = calculatorNumbers[indexPressed]
        print("PRESSED KEY \(keyPressed) AT POSITION \(indexPressed)")
        //=
        if keyPressed == "=" {
            equalPressed()
        }
        //.
        if keyPressed == "." {
            dotPresssed()
        }
        //Number
        if (indexPressed + 1)%5 != 0 && indexPressed != 17 && indexPressed != 18{
            numberPressed(keyPressed)
            
        }
        //Operation
        if (indexPressed + 1)%5 == 0{
            operatorPressed(keyPressed)
            
        }
        transactionInfo.setValue((calculator.getUsualTotal(totalText) as NSString).floatValue)
        return (calculator.getUsualTotal(totalText),calculator.getReadableString(calculationText))
    }
    
    func equalPressed(){
        calculationText = totalText
        calculating = "0"
    }
    
    func dotPresssed(){
        integerNum = 1
        //First dot
        if !oneDot && !hasDot(calculationText){
            if calculating == "0"{
                totalText += "."
            }
            calculationText += "."
        }
        oneDot = true
        
    }
    
    func numberPressed(inputNumber:String){
        if calculating == "0"{
            //Just add Number
            oneOp = false
            if integerNum == 0 {
                if totalText == "0" {
                    totalText  = inputNumber
                } else {
                    totalText += inputNumber
                }
                calculationText = totalText
                
            } else if integerNum == 1 || integerNum == 2{
                integerNum++
                totalText += inputNumber
                calculationText = totalText
            }
        }
        else {
            //Calculate result
            oneOp = false
            calculationText = calculationText + inputNumber
            totalText =  "\(calculator.calculateTotal(calculationText))"
        }
    }
    
    func operatorPressed(operatorPressed:String){
        if !oneOp {
            //totalText = lastTotal
            calculating = operatorPressed
            calculationText =  calculationText  + operatorPressed
        }
        oneOp = true
        oneDot = false
    }
    
    func hasDot(total:String) -> Bool{
        var hasdot : Bool = false
        for t in total.characters {
            if t == "." {
                hasdot = true
            }
            if calculator.isOp(t){
                hasdot = false
            }
            
        }
        return hasdot
    }
}
