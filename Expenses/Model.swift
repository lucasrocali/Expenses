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
Create logic to manage expense/income






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
    
    var information : InfoManager = Database()
    
    var integerNum = 0
    var calculating = "0"
    var calculator : Float = 0.00
    var selectedIndexCat : Int?
    var selectedIndexSubCat : Int?
    var category = true
    var calculatorNumbers =
    ["Photo","7","8","9","/","Date","4","5","6","x","Note","1","2","3","-","Location","0",".","=","+"]
    var categories : [Category] = []
    var subcategories : [SubCategory] = []
    var calculationText = ""
    var oneDot : Bool = false
    var oneOp : Bool = false
    //let appDelegate : AppDelegate
    
    var expenses : [Expense] = []
    
    var database : Database = Database()
    
    func resetInput() {
        integerNum = 0
        calculating = "0"
        calculator = 0.00
        oneDot = false
        oneOp = false
    }
    
    init() {
        print("criando classe")
        categories = information.getCategories()
        //appDelegate = UIApplication().delegate as! AppDelegate
        //managedContext = appDelegate.managedObjectContext!
    }
    func getCategories(){
        categories = database.getCategories()
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
        subcategories = database.getSubCategories(categories[selectedIndexCat!])
         print("after \(subcategories.count)")
    }
    func getExpenses(){
        expenses = database.fetchExpenses()
    }
    func saveExpense(value:Float){
        database.saveExpenseToDB(value)
    }
    /*
    func getSelectedCategory() -> Category{
        return categories[selectedIndexCat!]
    }*/
    func getCategory(name:String) -> Category? {
        for category in categories {
            if category.name == name {
                return category
            }
        }
        return nil
        
    }
    
    
    
    
    func getTotalAndCalculation(indexPressed:Int, lastTotal:String) -> (String,String) {
        let keyPressed = calculatorNumbers[indexPressed]
        var totalText = lastTotal
        if keyPressed == "=" {
            totalText = lastTotal
            calculationText = lastTotal
            calculating = "0"
            return (totalText,calculationText)
        }
        if (indexPressed + 1)%5 != 0 && indexPressed != 17{ //Number or point
            if indexPressed == 17 {         //.
                print("DOT")
                integerNum = 1              //Its a point
                if !oneDot {                //Its a first dot
                    if calculating == "0" {
                         totalText = lastTotal + "."
                    }
                    calculationText += "."
                }
                oneDot = true
            } else if calculating == "0"{       //NUMBER
                oneOp = false
                var total = "0"
                if integerNum == 0 {
                    if lastTotal == "0" {
                        total = keyPressed
                    } else {
                        total = lastTotal + keyPressed
                    }
                    totalText = total
                    calculationText = total
                    //println("Pressed \(keyPressed) at \(indexPressed)")
                } else if integerNum == 1{
                    integerNum = 2
                    total = lastTotal + keyPressed
                    totalText = total
                    calculationText = total
                    //println("PRIMEIRO DECIMAL")
                }
                else if integerNum == 2{
                    total = lastTotal + keyPressed
                    totalText = total
                    calculationText = total
                    //println("SEGUNDO DECIMAL")
                    integerNum = 3
                }
            } else {        //OPERATION
                //println("OP 1")
                oneOp = false
                calculationText = calculationText + keyPressed
                print("AKI >>> \(calculationText)")
                totalText =  "\(calculateTotal(calculationText))"
            }
            
        } else {            //OPERATION
            if !oneOp {
                totalText = lastTotal
                calculating = keyPressed
                calculationText =  calculationText  + keyPressed
            }
            oneOp = true
            oneDot = false
       }
        return (totalText,calculationText)
    }
    
    
    
    func keepPreference (ops:[String]) -> Bool {
        var hasPreference = false
        for op in ops {
            if op == "x" || op == "/" {
                hasPreference = true
            }
        }
        return hasPreference
    }
    
    func isNum(c:Character) -> Bool{
        if c == "0" || c == "1" || c == "2" || c == "3" || c == "4" || c == "5" || c == "6" || c == "7" || c == "8" || c == "9" || c == "."{
            return true
        } else {
            return false
        }
    }
    func isOp(c:Character) -> Bool{
        if c == "+" || c == "-" || c == "/" || c == "x" {
            return true
        } else {
            return false
        }
    }
    
    func getReadableString(str:String) -> String {
        var newStr = ""
        for s in str.characters {
            if isOp(s) {
                newStr += " " + "\(s)" + " "
            }
            else {
                newStr += "\(s)"
            }
        }
        return newStr
    }
    
    func getUsualTotal(total:String) -> String {
        var newTotal : String = ""
        var twoStepsForward : Int = 0
        for t in total.characters {
            
            if twoStepsForward == 1 {
                newTotal += "\(t)"
                twoStepsForward = 2
            } else if twoStepsForward == 2 {
                newTotal += "\(t)"
                twoStepsForward = 3
            }
            if t == "." {
                newTotal += "\(t)"
                twoStepsForward = 1
            }
            if twoStepsForward == 0 {
                newTotal += "\(t)"
            }
        }
        return newTotal
    }
    
    func calculateTotal(str:String) -> Float {
        //var str = "6.00 / 3.00 - 18.00"
        print("STR ==== " + str)
        var n : [Float] = []
        var o : [String] = []
        var tempChar : String = ""
        var op : String = ""
        var numOrOp : Int // 0 for num 1 for op
        numOrOp = 0
        let strLength = str.characters.count
        var cnt = 0
        for currentChar in str.characters {
            cnt++
            // if isNum(s){
            if numOrOp == 0 && isNum(currentChar){
                tempChar = tempChar + "\(currentChar)"
            }
            if numOrOp == 0 && isOp(currentChar) {
                let floatNum : Float = (tempChar as NSString).floatValue
                n.append(floatNum)
                tempChar = "\(currentChar)"
                numOrOp = 1
            }
            if numOrOp == 1 && isNum(currentChar){
                o.append(tempChar)
                numOrOp = 0
                tempChar = "\(currentChar)"
            }
            
            if cnt == strLength{
                let floatNum : Float = (tempChar as NSString).floatValue
                n.append(floatNum)
                tempChar = "\(currentChar)"
                numOrOp = 1
            }
            
            //}
/*
            if s == " " {
                if numOrOp == 0 {
                    var floatNum : Float = (num as NSString).floatValue
                    n.append(floatNum)
                    num = ""
                    numOrOp = 1 }
                else {
                    o.append(num)
                    numOrOp = 0
                    num = ""
                }
            }*/
            
        }
        print(n)
        print(o)
        if o.count > 0 {
            var empty = false
            var hasPreference : Bool = keepPreference(o)
            
            while !empty {
                for i in 0 ... o.count {
                    if hasPreference {
                        if o[i] == "x" {
                            let res = n[i]*n[i+1]
                            n[i] = res
                            n.removeAtIndex(i+1)
                            o.removeAtIndex(i)
                            hasPreference = keepPreference(o)
                            break
                        } else if o[i] == "/" {
                            let res = n[i]/n[i+1]
                            n[i] = res
                            n.removeAtIndex(i+1)
                            o.removeAtIndex(i)
                            hasPreference = keepPreference(o)
                            break
                        }
                    } else {
                        print("\(i)")
                        if o[i] == "+" {
                            print("+")
                            let res = n[i]+n[i+1]
                            n[i] = res
                            n.removeAtIndex(i+1)
                            o.removeAtIndex(i)
                            break
                        }
                        if o[i] == "-" {
                            let res = n[i]-n[i+1]
                            n[i] = res
                            n.removeAtIndex(i+1)
                            o.removeAtIndex(i)
                            break
                        }
                    }
                }
                if o.count == 0 {
                    empty = true
                }
                
            }
        }
        print(n)
        return n[0]
    }
    
    
}