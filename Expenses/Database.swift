//
//  Database.swift
//  Expenses
//
//  Created by Lucas Rocali on 10/17/15.
//  Copyright © 2015 Lucas Rocali. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Database : InfoManager {
    var nextInfo : InfoManager? = DefaultInfo()
    var managedContext : NSManagedObjectContext {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    }
    
    func getCategories(type:String) -> [Category] {
        let fetchRequest = NSFetchRequest(entityName: "Category")
        let predicate = NSPredicate(format: "type == %@",type)
        fetchRequest.predicate = predicate
         let fetchResults = try! managedContext.executeFetchRequest(fetchRequest) as? [Category]
        var tempCategories :[Category] = []
        if let results = fetchResults {
            if (results.count > 0){
                //print(results)
                for result : Category in results {
                    tempCategories.append(result)
                }
                print("Categories fetched from DB")
                return tempCategories
            } else {
                print("Could not fetch categories from DB lets take from Default Model")
                return (nextInfo?.getCategories(type))!
            }
        } else {
            print("Could not fetch categories from DB lets take from Default Model")
            return (nextInfo?.getCategories(type))!
        }
    }
    
    func getSubCategories(belongs:Category) -> [SubCategory] {
        let fetchRequest = NSFetchRequest(entityName: "SubCategory")
        let predicate = NSPredicate(format: "belongs == %@",belongs)
        fetchRequest.predicate = predicate
        //let error : NSError
        let fetchResults = try! managedContext.executeFetchRequest(fetchRequest) as? [SubCategory]
        //subCategories.removeAll(keepCapacity: false)
        var tempSubCategories :[SubCategory] = []
        if let results = fetchResults {
        for result : SubCategory in results {
                tempSubCategories.append(result)
            }
            print("SubCategories fetched from DB")
            return tempSubCategories
            
        } else {
            print("Could not fetch subcategories from DB lets take from Default Model")
            return (nextInfo?.getSubCategories(belongs))!
        }
       
    }

    
    
    
    
    func saveCategoryToDB(type:String,name:String,subcategories:[String]) {
        let category : Category =  NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: managedContext) as! Category
        category.name = name
        category.type = type
        for subcategory in subcategories {
            saveSubCategoryToDB(category, name: subcategory)
        }
        //category.subcategories = tempsubcategories
        //categories.append(category)
        var error : NSError?
        do {
            try managedContext.save()
        } catch let error1 as NSError {
            error = error1
        }
        
    }
    func saveSubCategoryToDB(belongs:Category,name:String) {
        let subCategory : SubCategory =  NSEntityDescription.insertNewObjectForEntityForName("SubCategory", inManagedObjectContext: managedContext) as! SubCategory
        subCategory.belongs = belongs
        subCategory.name = name
        var error : NSError?
        do {
            try managedContext.save()
        } catch let error1 as NSError {
            error = error1
        }
    }
    
    
    func saveTransactionToDB(transactionInfo:TransactionInfo) {
        let transaction : Transaction =  NSEntityDescription.insertNewObjectForEntityForName("Transaction", inManagedObjectContext: managedContext) as! Transaction
        
        transaction.type = transactionInfo.getType()
        transaction.value = transactionInfo.getValue()
        transaction.subcategory = transactionInfo.getSubCategory()
        transaction.date = transactionInfo.getDate()
        transaction.id = transactionInfo.getId()
        
        
        //expense.subcategory = subcategories[selectedIndexSubCat!]
        //expenses.append(expense)
        fetchTransactions()
        var error : NSError?
        do {
            try managedContext.save()
        } catch let error1 as NSError {
            error = error1
        }
        //CORE DATA NOT SAVING
    }
    
    func updateTransactionToDB(transactionInfo:TransactionInfo) {
        //var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        //var context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Transaction")
        fetchRequest.predicate = NSPredicate(format: "id = %@", transactionInfo.getId())
        
        if let fetchResults = try! managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
            if fetchResults.count != 0{
                
                let managedObject = fetchResults[0]
                managedObject.setValue(transactionInfo.getType(), forKey: "type")
                managedObject.setValue(transactionInfo.getValue(), forKey: "value")
                managedObject.setValue(transactionInfo.getSubCategory(), forKey: "subcategory")
                managedObject.setValue(transactionInfo.getDate(), forKey: "date")
                
                try! managedContext.save()
            }
        }
        /*let transaction : Transaction =  NSEntityDescription.insertNewObjectForEntityForName("Transaction", inManagedObjectContext: managedContext) as! Transaction
        
        
        transaction.type = transactionInfo.getType()
        transaction.value = transactionInfo.getValue()
        transaction.subcategory = transactionInfo.getSubCategory()
        transaction.date = transactionInfo.getDate()
        
        
        
        //expense.subcategory = subcategories[selectedIndexSubCat!]
        //expenses.append(expense)
        fetchTransactions()
        var error : NSError?
        do {
            try managedContext.save()
        } catch let error1 as NSError {
            error = error1
        }*/
        //CORE DATA NOT SAVING
    }
    
    func deleteTransaction(transaction:Transaction){
        managedContext.deleteObject(transaction)
        var error : NSError?
        do {
            try managedContext.save()
        } catch let error1 as NSError {
            error = error1
        }
         //fetchTransactions()
    }
    /*
    func fetchCategories() -> [Category]{
    //subcategories.removeAll(keepCapacity: false)
    //let belongs : Category = categories[selectedIndexCat!]
    //print(selectedIndexCat, terminator: "")
    //print(belongs, terminator: "")
    let fetchRequest = NSFetchRequest(entityName: "Category")
    // let predicate = NSPredicate(format: "belongs == %@",belongs)
    //fetchRequest.predicate = predicate
    //let error : NSError
    let fetchResults = try! managedContext.executeFetchRequest(fetchRequest) as? [Category]
    //subCategories.removeAll(keepCapacity: false)
    var tempCategories :[Category] = []
    if let results = fetchResults {
    print(results)
    for result : Category in results {
    tempCategories.append(result)
    }
    } else {
    print("Could not fetch")
    }
    return tempCategories
    }*/
    
    /*
    func fetchSubCategories(belongs:Category) -> [SubCategory]{
    //subcategories.removeAll(keepCapacity: false)
    //let belongs : Category = categories[selectedIndexCat!]
    //print(selectedIndexCat, terminator: "")
    //print(belongs, terminator: "")
    let fetchRequest = NSFetchRequest(entityName: "SubCategory")
    let predicate = NSPredicate(format: "belongs == %@",belongs)
    fetchRequest.predicate = predicate
    //let error : NSError
    let fetchResults = try! managedContext.executeFetchRequest(fetchRequest) as? [SubCategory]
    //subCategories.removeAll(keepCapacity: false)
    var tempSubCategories :[SubCategory] = []
    if let results = fetchResults {
    //print(results)
    for result : SubCategory in results {
    tempSubCategories.append(result)
    }
    } else {
    print("Could not fetch")
    }
    return tempSubCategories
    }*/
    
    
    func fetchTransactions() -> [Transaction] {
        var tempTransactions : [Transaction] = []
        let fetchRequest = NSFetchRequest(entityName: "Transaction")
        //let error : NSError?
        let fetchResults = try! managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        if let results = fetchResults {
            for result in results {
                tempTransactions.append(result as! Transaction)
            }
        } else {
            print("Could not fetch")
        }
        return tempTransactions
    }
    
    
    
}