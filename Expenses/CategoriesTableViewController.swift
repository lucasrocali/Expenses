//
//  CategoriesTableViewController.swift
//  Expenses
//
//  Created by Lucas Rocali on 2/1/16.
//  Copyright © 2016 Lucas Rocali. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {

    var model = Model.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nib = UINib(nibName: "CategoryCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "categoryCell")


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return model.categoryManager.transacationsByCategory.count
        return 9
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func viewDidAppear(animated: Bool) {
        model.categoryManager.getTransactions()
        model.categoryManager.getTransactionsByCategory()
        self.tableView.reloadData()
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell : CategoryTableViewCell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath) as! CategoryTableViewCell
        
       // let transaction : Transaction = model.categoryManager.transacationsByCategory[indexPath.row]
        
        let index = indexPath.row
        
        var description = "Description"
        var value : Float = 0.0
        switch index {
        case 0:
            description = "Month Expense"
            value = -model.balanceManager.getTotalMonthExpense()
        case 1:
            description = "Month Income"
            value = model.balanceManager.getTotalMonthIncome()
        case 2:
            description = "Month Balance"
            value = model.balanceManager.getTotalMonthBalance()
        case 3:
            description = "Avarage Day Expense"
            value = -model.balanceManager.getAvarageDayExpense()
        case 4:
            description = "Avarage Day Income"
            value = model.balanceManager.getAvarageDayIncome()
        case 5:
            description = "Avarage Day Balance"
            value = model.balanceManager.getAvarageDayBalance()
        case 6:
            description = "Projected Month Expense"
            value = -model.balanceManager.getProjectedMonthExpense()
        case 7:
            description = "Projected Month Income"
            value = model.balanceManager.getProjectedMonthIncome()
        case 8:
            description = "Projected Month Balance"
            value = model.balanceManager.getProjectedMonthBalance()
        default:
            description = "Gasto mês"
            value = model.balanceManager.getTotalMonthBalance()
        }
        
        if(value > 0){
            cell.lblTotal.textColor = greenColor
        } else {
            cell.lblTotal.textColor = redColor
        }
        cell.lblNEntries.text = ""
        cell.lblCategory.text = description
        cell.lblTotal.text = "\(value)"
        
        if index % 3 == 0 || index % 3 == 1  {
            cell.backgroundColor = lightGrayColor
        } else {
            cell.backgroundColor = mediumGrayColor
        }
        
        cell.lblNEntries.font = normalFont
        cell.lblCategory.font = normalFont
        cell.lblTotal.font = normalFont
        
        //cell.lblCategory = transaction.
        
        // WORK HERE
        
        // CREATE A LOGIC TO MANAGE THE GROUP OF CATEGORIES , N OF ENTRIES AND TOTAL ON CATEGORY MANAGER
        
        
        
        
        
        
        
        /*
        let color : UIColor?
        if transaction.type == "Expense" {
            color = redColor
            
        } else {
            color = greenColor
        }
        //cell.backgroundColor = color!
        
        cell.lblCategory.text = transaction.subcategory.belongs.name
        cell.lblSubCategory.text = transaction.subcategory.name
        cell.lblValue.text = "\(transaction.value)"
        cell.lblDate.text = model.getDateString(transaction.date)
        
        cell.lblValue.textColor = color!
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = lightGrayColor
        } else {
            cell.backgroundColor = mediumGrayColor
        }
        
        cell.lblCategory.font = normalFont
        cell.lblSubCategory.font = detailFont
        cell.lblValue.font = normalFont
        cell.lblDate.font = smallDetailFont
        /*
        cell.textLabel!.text = "\(transaction.value)"
        //cell.detailTextLabel!.text = model.transactions[indexPath.row].subcategory.name + "type :" + model.transactions[indexPath.row].type
        
        cell.detailTextLabel!.text = "\(transaction.subcategory.name) at \(model.getDateString(transaction.date))"*/*/
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
