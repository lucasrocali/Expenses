//
//  AddExpenseViewController.swift
//  Expenses
//
//  Created by Lucas Rocali on 6/18/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit

class AddTransactionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var model = Model.sharedInstance
    var transactionType = TransactionType()
    var transactionValue = TransactionValue()
    
    //let date = NSDate()
    
    
    @IBAction func addCategorieOrSubCategorie(sender: AnyObject) {
        let alert = UIAlertView()
        if transactionType.category {
            alert.title = "Enter new \(transactionType.type) category"
        } else {
            alert.title = "Enter new \(transactionType.type) subcategory"
        }
        alert.addButtonWithTitle("Add")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alert.addButtonWithTitle("Cancel")
        alert.delegate = self
        alert.show()
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let buttonTitle = alertView.buttonTitleAtIndex(buttonIndex)
        ////println("\(buttonTitle) pressed")
        if buttonTitle == "Add" {
            let textField = alertView.textFieldAtIndex(0)
            print("ADD"+textField!.text!, terminator: "")
            if transactionType.category {
                transactionType.saveCategory(textField!.text!)
                transactionType.getCategories()               //
            } else {
                transactionType.saveSubCategory(textField!.text!)
                transactionType.getCategories()
                transactionType.getSubCategories()
               
            }
            cvCategory.reloadData()
            
        } else {
            print("Cancel pressed")
        }
    }
    
    
    @IBAction func saveTransaction(sender: AnyObject) {
        if (transactionType.selectedIndexCat != nil && transactionType.selectedIndexSubCat != nil) {
            print("Save Transactio\n category : \(transactionType.selectedIndexCat!) \n subcategory \(transactionType.selectedIndexSubCat!) \n Total \(lblTotal.text!)")
            
            model.saveTransaction(transactionType.type,value:(lblTotal.text! as NSString).floatValue,subcategory:transactionType.getSelectedSubCategory())
        }
    }
    @IBAction func swpRight(sender: AnyObject) {
        
        
    }
    @IBOutlet var swpRight: UISwipeGestureRecognizer!
    @IBOutlet var lblCalculation: UILabel!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var cvCalculator: UICollectionView!
    @IBOutlet weak var cvCategory: UICollectionView!
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    let tapRec = UITapGestureRecognizer()
    
    @IBAction func expenseIncomeAction(sender: AnyObject) {
        transactionType.switchType()
        let btnExpenseIncome : UIButton = sender as! UIButton
        btnExpenseIncome.setTitle(transactionType.type, forState: .Normal)
        transactionType.backToCategories()
        self.cvCategory.reloadData()
    }
    @IBAction func backToCategories(sender: AnyObject) {
        //println("back to categorie")
        transactionType.backToCategories()
                self.cvCategory.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        self.cvCategory.allowsMultipleSelection = true
        self.cvCategory.delaysContentTouches = false
        
        cvCategory.backgroundColor = UIColor.grayColor()
        
        self.cvCalculator.allowsMultipleSelection = true
        self.cvCalculator.delaysContentTouches = false
        
        cvCalculator.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        lblTotal.text = "0"
        lblCalculation.text = "0"
        
        tapRec.addTarget(self, action: "labelTapped")
        lblTotal.addGestureRecognizer(tapRec)
    
    }
    
    func labelTapped(){
        print("labelTapped")
        transactionValue.resetInput()
        lblTotal.text = "0"
        lblCalculation.text = "0"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if collectionView === self.cvCategory {
            if transactionType.category {
                
                count = transactionType.categories.count
            } else {
                count = transactionType.subcategories.count
            }
            return count
        }
        return transactionValue.calculatorNumbers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView === self.cvCategory {
            // var cellidentifier : String = "categoryCell"
            let cell : CategoryCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("categorieCell", forIndexPath: indexPath) as! CategoryCollectionViewCell
            //cell.backgroundColor = UIColor.whiteColor()
            //cell.layer.borderColor = UIColor.blackColor().CGColor
            cell.layer.borderWidth = 0.5
            cell.backgroundColor = UIColor.grayColor()
            if transactionType.selectedIndexSubCat == indexPath.row && !transactionType.category {
                cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            }
            //cell.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
            //cell.frame.size.width = screenWidth / 3
            //cell.frame.size.height = screenWidth / 3
            if transactionType.category{
                cell.lblName.text = transactionType.categories[indexPath.row].name
            } else {
                cell.lblName.text = transactionType.subcategories[indexPath.row].name
            }
            return cell
        } else {
            let cell : CalculatorCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("calculatorCell", forIndexPath: indexPath) as! CalculatorCollectionViewCell
            //cell.backgroundColor = UIColor.whiteColor()
            //cell.layer.borderColor = UIColor.blackColor().CGColor
            cell.layer.borderWidth = 0.5
            
            if indexPath.row % 5 == 0 {     //non calculator part
                cell.backgroundColor = UIColor.grayColor()
                if (indexPath.row == 0){    //date
                    cell.lblNumber.text = "\(model.getDay()) \(model.getMonth())"
                } else { //others
                    cell.lblNumber.text = transactionValue.calculatorNumbers[indexPath.row]
                }
            } else {    //calculator part
                cell.backgroundColor = UIColor.whiteColor()
                cell.lblNumber.text = transactionValue.calculatorNumbers[indexPath.row]
            }
            
            //cell.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
            //cell.frame.size.width = screenWidth / 3
            //cell.frame.size.height = screenWidth / 3
            
            //cell.lblNumber.text = String(indexPath.row)   //get index of collection view calculator
            return cell
        }
        
    }
    
    func tappedCollectionView(collectionView: UICollectionView, indexPath: NSIndexPath) {
        
        if collectionView === self.cvCategory {
            if transactionType.selectedIndexSubCat != nil {
                let lastIndexPath : NSIndexPath = NSIndexPath(forRow: transactionType.selectedIndexSubCat!, inSection: 0)
                let celll = collectionView.cellForItemAtIndexPath(lastIndexPath)
                if !transactionType.category {
                    celll!.backgroundColor = UIColor.clearColor()
                }
            }
            
            print("Cell \(indexPath.row) selected")
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell!.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            if !transactionType.category {
                transactionType.selectedIndexSubCat = indexPath.row
            } else {
                transactionType.selectedIndexCat = indexPath.row
                transactionType.getSubCategories()
            }
            transactionType.category = false
            
            self.cvCategory.reloadData()
        } else {
            
            if indexPath.row % 5 == 0 { //Its not part of calculator
                print("Non calculator part")
                
            } else {    //calculator part
                (lblTotal.text!,lblCalculation.text!) = transactionValue.getTotalAndCalculation(indexPath.row)
                
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        tappedCollectionView(collectionView,indexPath:indexPath)
        
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        tappedCollectionView(collectionView,indexPath:indexPath)
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout:UICollectionViewLayout!,sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        if collectionView === self.cvCategory {
            return CGSize(width: screenWidth/3, height: screenWidth/6)
        }
        return CGSize(width: screenWidth/5, height: 250/4)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        //println("ip = \(indexPath.item)")
        if collectionView === self.cvCategory {
            let supplementaryView = cvCategory.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier:"cvHeader", forIndexPath: indexPath)
            return supplementaryView
        } else {
            let supplementaryView = cvCalculator.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier:"cvCalculatorHeader", forIndexPath: indexPath)
            //supplementaryView.backgroundColor = UIColor.blueColor()
            return supplementaryView
        }
        
    }
}
