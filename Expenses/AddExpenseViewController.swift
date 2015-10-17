//
//  AddExpenseViewController.swift
//  Expenses
//
//  Created by Lucas Rocali on 6/18/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit

class AddExpenseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var model = Model.sharedInstance
    var balanceType = BalanceType()
    
    @IBAction func addCategorieOrSubCategorie(sender: AnyObject) {
        let alert = UIAlertView()
        if model.category {
            alert.title = "Enter new category"
        } else {
            alert.title = "Enter new subcategory"
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
            if model.category {
                model.saveCategory(textField!.text!)
                model.getCategories()               // model.categories.append(textField!.text)
                //SAVE CATEGORY .....
            } else {
                model.saveSubCategory(textField!.text!)
                model.getCategories()
                model.getSubCategories()
                //model.getSubCatecories()
                //model.subCategories.append(textField!.text)
            }
            cvCategory.reloadData()
            
        } else {
            print("Cancel pressed")
        }
    }
    
    @IBAction func saveExpense(sender: AnyObject) {
        if (model.selectedIndexCat != nil && model.selectedIndexSubCat != nil) {
            print("Save expense\n category : \(model.selectedIndexCat!) \n subcategory \(model.selectedIndexSubCat!) \n Total \(lblTotal.text!)")
            
            model.saveExpense((lblTotal.text! as NSString).floatValue)
        }
    }
    @IBAction func swpRight(sender: AnyObject) {
        print("Swipe Right")
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
        print("Expense/Income")
    }
    @IBAction func backToCategories(sender: AnyObject) {
        //println("back to categorie")
        model.category = true
        model.selectedIndexCat = nil
        model.selectedIndexSubCat = nil
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
        
        //model.getData()
        //model.createDefaultCategories()
    }
    
    func labelTapped(){
        print("labelTapped")
        model.resetInput()
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
            if model.category {
                
                count = model.categories.count
            } else {
                count = model.subcategories.count
            }
            return count
        }
        return model.calculatorNumbers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView === self.cvCategory {
            // var cellidentifier : String = "categoryCell"
            let cell : CategoryCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("categorieCell", forIndexPath: indexPath) as! CategoryCollectionViewCell
            //cell.backgroundColor = UIColor.whiteColor()
            //cell.layer.borderColor = UIColor.blackColor().CGColor
            cell.layer.borderWidth = 0.5
            cell.backgroundColor = UIColor.grayColor()
            if model.selectedIndexSubCat == indexPath.row && !model.category {
                cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            }
            //cell.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
            //cell.frame.size.width = screenWidth / 3
            //cell.frame.size.height = screenWidth / 3
            if model.category{
                cell.lblName.text = model.categories[indexPath.row].name
            } else {
                cell.lblName.text = model.subcategories[indexPath.row].name
            }
            return cell
        } else {
            let cell : CalculatorCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("calculatorCell", forIndexPath: indexPath) as! CalculatorCollectionViewCell
            //cell.backgroundColor = UIColor.whiteColor()
            //cell.layer.borderColor = UIColor.blackColor().CGColor
            cell.layer.borderWidth = 0.5
            
            if indexPath.row % 5 == 0 {     //non calculator part
                cell.backgroundColor = UIColor.grayColor()
            } else {    //calculator part
                cell.backgroundColor = UIColor.whiteColor()
            }
            
            //cell.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
            //cell.frame.size.width = screenWidth / 3
            //cell.frame.size.height = screenWidth / 3
            cell.lblNumber.text = model.calculatorNumbers[indexPath.row]
            //cell.lblNumber.text = String(indexPath.row)   //get index of collection view calculator
            return cell
        }
        
    }
    
    func tappedCollectionView(collectionView: UICollectionView, indexPath: NSIndexPath) {
        
        if collectionView === self.cvCategory {
            if model.selectedIndexSubCat != nil {
                let lastIndexPath : NSIndexPath = NSIndexPath(forRow: model.selectedIndexSubCat!, inSection: 0)
                let celll = collectionView.cellForItemAtIndexPath(lastIndexPath)
                if !model.category {
                    celll!.backgroundColor = UIColor.clearColor()
                }
            }
            
            print("Cell \(indexPath.row) selected")
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell!.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            if !model.category {
                model.selectedIndexSubCat = indexPath.row
            } else {
                model.selectedIndexCat = indexPath.row
                model.getSubCategories()
            }
            model.category = false
            
            self.cvCategory.reloadData()
        } else {
            
            if indexPath.row % 5 == 0 { //Its not part of calculator
                print("Non calculator part")
                
            } else {    //calculator part
                print("Calculator part")
                var unreadableString : String = ""
                var unusualTotal : String = ""
                (unusualTotal,unreadableString) = model.getTotalAndCalculation(indexPath.row, lastTotal: lblTotal.text!)
                lblCalculation.text! = model.getReadableString(unreadableString)
                //lblTotal.text! = unusualTotal
                print("OIA A MERDA \(model.getUsualTotal(unusualTotal))")
                lblTotal.text! = model.getUsualTotal(unusualTotal)
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
