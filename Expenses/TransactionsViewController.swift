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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
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
        transactionsTableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        model.getTransactions()
        transactionsTableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.transactions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("expenseCell", forIndexPath: indexPath)
            
        
        cell.textLabel!.text = "\(model.transactions[indexPath.row].value)"
        //cell.detailTextLabel!.text = model.transactions[indexPath.row].subcategory.name + "type :" + model.transactions[indexPath.row].type

        cell.detailTextLabel!.text = "\(model.transactions[indexPath.row].date)"
        return cell
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
