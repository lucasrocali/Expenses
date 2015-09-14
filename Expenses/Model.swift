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
    
    var integerNum = 0
    var calculating = "0"
    var calculator : Float = 0.00
    var selectedIndexCat : Int?
    var selectedIndexSubCat : Int?
    var category = true
    var calculatorNumbers =
    ["Photo","7","8","9","/","Date","4","5","6","x","Note","1","2","3","-","Location","0",".","=","+"]
    //["1"]
    var defaultData = [
        "General":["General1","General2","General3"],
        "House":["House1","House2","House3"],
        "Food":["Food1","Food2","Food3"],
        "Groceries":["Groceries1","Groceries2","Groceries3"],
        "Payments":["Payments1","Payments2","Payments3"],
        "Transport":["Transport1","Transport2","Transport3"],
        "Utilities":["Utilities1","Utilities2","Utilities3"],
        "Car":["Car1","Car2","Car3"],
        "Personal":["Personal1","Personal2","Personal3"]
    ]
    var categories : [Category] = []
    var subcategories : [SubCategory] = []
    var calculationText = ""
    var oneDot : Bool = false
    var oneOp : Bool = false
    
    //let appDelegate : AppDelegate
    
    var managedContext : NSManagedObjectContext {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    }
    
    var expenses : [Expense] = []
    
    func resetInput() {
        integerNum = 0
        calculating = "0"
        calculator = 0.00
        oneDot = false
        oneOp = false
    }
    
    init() {
        println("criando classe")
        //appDelegate = UIApplication().delegate as! AppDelegate
        //managedContext = appDelegate.managedObjectContext!
    }

    func createDefaultCategories() {
        for (data,subdata) in defaultData {
            saveCategory(data, subcategories: subdata)
            
        }
        
        //self.fetchCategories()
    }
    /*
    func fetchCategories(){
        let fetchRequest = NSFetchRequest(entityName: "Category")
        var error : NSError?
        let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [Category]
        if let results = fetchResults {
            println(results)
            for result in results {
                categories.append(result)
            }
        } else {
            println("Could not fetch \(error)")
        }
    }
*/
    /*
    func fetchSubCategories() {
        var belongs : Category = categories[selectedIndexCat!]
        print(selectedIndexCat)
        print(belongs)
        let fetchRequest = NSFetchRequest(entityName: "SubCategory")
        let predicate = NSPredicate(format: "belongs == %@",belongs)
        fetchRequest.predicate = predicate
        var error : NSError?
        let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [SubCategory]
        //subCategories.removeAll(keepCapacity: false)
        if let results = fetchResults {
            println(results)
            for result in results {
                //subCategories.append(result)
            }
        } else {
            println("Could not fetch \(error)")
        }

    }
    */
    func saveCategory(name:String,subcategories:[String]) {
        let category : Category =  NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: managedContext) as! Category
        category.name = name
        for subcategory in subcategories {
            saveSubCategory(category, name: subcategory)
        }
        //category.subcategories = tempsubcategories
        categories.append(category)
        var error : NSError?
        managedContext.save(&error)
        
    }
    
    /*
    func saveSubCategories(belongs:String,subCategories:[String]) {
        for category in subCategories {
            saveSubCategory(belongs, name: category)
        }
    }
    */
    func saveSubCategory(belongs:Category,name:String) {
        let subCategory : SubCategory =  NSEntityDescription.insertNewObjectForEntityForName("SubCategory", inManagedObjectContext: managedContext) as! SubCategory
        subCategory.belongs = belongs
        subCategory.name = name
    }

    func getCategory(name:String) -> Category? {
        for category in categories {
            if category.name == name {
                return category
            }
        }
        return nil
        
    }
    
    func getSubCategories() {
        subcategories.removeAll(keepCapacity: false)
        var belongs : Category = categories[selectedIndexCat!]
        print(selectedIndexCat)
        print(belongs)
        let fetchRequest = NSFetchRequest(entityName: "SubCategory")
        let predicate = NSPredicate(format: "belongs == %@",belongs)
        fetchRequest.predicate = predicate
        var error : NSError?
        let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [SubCategory]
        //subCategories.removeAll(keepCapacity: false)
        if let results = fetchResults {
            println(results)
            for result in results {
                subcategories.append(result)
            }
        } else {
            println("Could not fetch \(error)")
        }
    }
    
    
    func fetchExpenses() {
       
        let fetchRequest = NSFetchRequest(entityName: "Expense")
        var error : NSError?
        let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        if let results = fetchResults {
            expenses.removeAll(keepCapacity: false)
            for result in results {
                expenses.append(result as! Expense)
            }
        } else {
            println("Could not fetch \(error)")
        }
    }
    
    func saveExpense(value: Float) {
        let expense : Expense =  NSEntityDescription.insertNewObjectForEntityForName("Expense", inManagedObjectContext: managedContext) as! Expense

        expense.value = value
        expense.subcategory = subcategories[selectedIndexSubCat!]
        //expenses.append(expense)
        fetchExpenses()
        var error : NSError?
        managedContext.save(&error)
        //CORE DATA NOT SAVING
    }
    
    func getTotalAndCalculation(indexPressed:Int, lastTotal:String) -> (String,String) {
        var keyPressed = calculatorNumbers[indexPressed]
        var totalText = lastTotal
        if keyPressed == "=" {
            totalText = lastTotal
            calculationText = lastTotal
            calculating = "0"
            return (totalText,calculationText)
        }
        if (indexPressed + 1)%5 != 0 && indexPressed != 17{ //Number or point
            if indexPressed == 17 {         //.
                println("DOT")
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
                println("AKI >>> \(calculationText)")
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
        for s in str {
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
        for t in total {
            
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
        println("STR ==== " + str)
        var n : [Float] = []
        var o : [String] = []
        var tempChar : String = ""
        var op : String = ""
        var numOrOp : Int // 0 for num 1 for op
        numOrOp = 0
        var strLength = count(str)
        var cnt = 0
        for currentChar in str {
            cnt++
            // if isNum(s){
            if numOrOp == 0 && isNum(currentChar){
                tempChar = tempChar + "\(currentChar)"
            }
            if numOrOp == 0 && isOp(currentChar) {
                var floatNum : Float = (tempChar as NSString).floatValue
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
                var floatNum : Float = (tempChar as NSString).floatValue
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
        println(n)
        println(o)
        if o.count > 0 {
            var empty = false
            var hasPreference : Bool = keepPreference(o)
            
            while !empty {
                for i in 0 ... o.count {
                    if hasPreference {
                        if o[i] == "x" {
                            var res = n[i]*n[i+1]
                            n[i] = res
                            n.removeAtIndex(i+1)
                            o.removeAtIndex(i)
                            hasPreference = keepPreference(o)
                            break
                        } else if o[i] == "/" {
                            var res = n[i]/n[i+1]
                            n[i] = res
                            n.removeAtIndex(i+1)
                            o.removeAtIndex(i)
                            hasPreference = keepPreference(o)
                            break
                        }
                    } else {
                        println("\(i)")
                        if o[i] == "+" {
                            println("+")
                            var res = n[i]+n[i+1]
                            n[i] = res
                            n.removeAtIndex(i+1)
                            o.removeAtIndex(i)
                            break
                        }
                        if o[i] == "-" {
                            var res = n[i]-n[i+1]
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
        println(n)
        return n[0]
    }
    
    
}