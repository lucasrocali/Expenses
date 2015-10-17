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
    
    func saveExpenseToDB(value: Float) {
        let expense : Expense =  NSEntityDescription.insertNewObjectForEntityForName("Expense", inManagedObjectContext: managedContext) as! Expense
        
        expense.value = value
        //expense.subcategory = subcategories[selectedIndexSubCat!]
        //expenses.append(expense)
        fetchExpenses()
        var error : NSError?
        do {
            try managedContext.save()
        } catch let error1 as NSError {
            error = error1
        }
        //CORE DATA NOT SAVING
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
    
    
    func fetchExpenses() -> [Expense] {
        var tempExpenses : [Expense] = []
        let fetchRequest = NSFetchRequest(entityName: "Expense")
        //let error : NSError?
        let fetchResults = try! managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        if let results = fetchResults {
            for result in results {
                tempExpenses.append(result as! Expense)
            }
        } else {
            print("Could not fetch")
        }
        return tempExpenses
    }
    
    
    
}