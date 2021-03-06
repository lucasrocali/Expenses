//
//  ExpensesViewController.swift
//  Expenses
//
//  Created by Lucas Rocali on 6/18/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var model = Model.sharedInstance

    @IBOutlet weak var transactionsTableView: UITableView!
    @IBOutlet weak var lblTotalBalance: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        var nib = UINib(nibName: "TransactionCell", bundle: nil)
        transactionsTableView.registerNib(nib, forCellReuseIdentifier: "transactionCell")
        
        //self.transactionsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        lblTotalBalance.font = normalFont

                // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        self.view.endEditing(true)
        print("selected \(indexPath.row)")
        performSegueWithIdentifier("listToTransaction", sender: indexPath)
        //transactionsTableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        model.balanceManager.getTransactions()
        refreshTotalBalance()
        transactionsTableView.reloadData()
    }
   func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.balanceManager.transactions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell : TransactionTableViewCell = tableView.dequeueReusableCellWithIdentifier("transactionCell", forIndexPath: indexPath) as! TransactionTableViewCell
            
        let transaction : Transaction = model.balanceManager.transactions[indexPath.row]
        
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

        cell.detailTextLabel!.text = "\(transaction.subcategory.name) at \(model.getDateString(transaction.date))"*/
        return cell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        print("delete")
        model.transactionInfoManager.deleteTransaction(model.balanceManager.transactions[indexPath.row])
        model.balanceManager.getTransactions()
        transactionsTableView.reloadData()
        refreshTotalBalance()
    }

    func refreshTotalBalance(){
        lblTotalBalance.text = "\(model.balanceManager.getTotalBalance())"
        if(model.balanceManager.getTotalBalance() > 0){
            lblTotalBalance.textColor = greenColor
        } else {
            lblTotalBalance.textColor = redColor
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        if segue.identifier == "listToTransaction"
        {
            //print("LIST TO TRANSACTION")
            
            let indexPath : NSIndexPath = sender as! NSIndexPath

            let editTransaction = segue.destinationViewController as! AddTransactionViewController
            editTransaction.transactionIndex = indexPath.row
            editTransaction.transactionState = 1
            /*let indexPath : NSIndexPath = sender as! NSIndexPath
            //println("bora editar indexpahtrow: \(indexPath.row)")
            //println("Cell n: \(indexPath.row)")
            var editBill = segue.destinationViewController as! AddBillViewController
            editBill.billCellIndex = indexPath.row
            editBill.billState = 1
            
        } else {
            var editBill = segue.destinationViewController as! AddBillViewController
            editBill.billState = 0
            */
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
