//
//  AddExpenseViewController.swift
//  Expenses
//
//  Created by Lucas Rocali on 6/18/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit
import CollectionViewWaterfallLayout

class AddTransactionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var model = Model.sharedInstance
   
    
    //let date = NSDate()
    
    
    @IBAction func addCategorieOrSubCategorie(sender: AnyObject) {
        let alert = UIAlertView()
        if model.transactionInfoManager.category {
            alert.title = "Enter new \(model.transactionInfoManager.transactionInfo.getType()) category"
        } else {
            alert.title = "Enter new \(model.transactionInfoManager.transactionInfo.getType()) subcategory"
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
            if model.transactionInfoManager.category {
                model.transactionInfoManager.saveCategory(textField!.text!)
                model.transactionInfoManager.getCategories()               //
            } else {
                model.transactionInfoManager.saveSubCategory(textField!.text!)
                model.transactionInfoManager.getCategories()
                model.transactionInfoManager.getSubCategories()
               
            }
            cvCategory.reloadData()
            
        } else {
            print("Cancel pressed")
        }
    }
    
    
    @IBAction func saveTransaction(sender: AnyObject) {
        if (model.transactionInfoManager.selectedIndexCat != nil && model.transactionInfoManager.selectedIndexSubCat != nil) {
            print("Save Transactio\n category : \(model.transactionInfoManager.selectedIndexCat!) \n subcategory \(model.transactionInfoManager.selectedIndexSubCat!) \n Total \(lblTotal.text!)")
            model.transactionInfoManager.saveTransaction()
            
            model.transactionInfoManager.defaultTransactionInfo()
           
            self.cvCategory.reloadData()
            lblTotal.text = "0"
            lblCalculation.text = "0"
           
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
    let lblTotalTapRec = UITapGestureRecognizer()
    
    @IBOutlet weak var btnBacktToCategories: UIButton!
    //@IBOutlet weak var btnType: UIButton!
    @IBAction func typeAction(sender: AnyObject) {
        /*
        let updateType = UIButton()
        /*updateType.textColor = monthLabel.textColor
        updateType.font = monthLabel.font
        updateType.textAlignment = .Center
        updateType.text = date.globalDescription
        updateType.sizeToFit()
        updateType.alpha = 0
        updateType.center = self.monthLabel.center*/
        
        let offset = CGFloat(48)
        updateType.transform = CGAffineTransformMakeTranslation(0, offset)
        updateType.transform = CGAffineTransformMakeScale(1, 0.1)
        
        UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.animationFinished = false
            self.monthLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
            self.monthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
            self.monthLabel.alpha = 0
            
            updateType.alpha = 1
            updateType.transform = CGAffineTransformIdentity
            
            }) { _ in
                
                self.animationFinished = true
                self.monthLabel.frame = updateType.frame
                self.monthLabel.text = updateType.text
                self.monthLabel.transform = CGAffineTransformIdentity
                self.monthLabel.alpha = 1
                updateType.removeFromSuperview()
        }
        
        self.view.insertSubview(updateType, aboveSubview: self.monthLabel)*/
        
        model.transactionInfoManager.switchType()
        let btnExpenseIncome : UIButton = sender as! UIButton
        btnExpenseIncome.setTitle(model.transactionInfoManager.transactionInfo.getType(), forState: .Normal)
        model.transactionInfoManager.backToCategories()
        self.cvCategory.reloadData()
    }
    @IBAction func backToCategories(sender: AnyObject) {
        //println("back to categorie")
        model.transactionInfoManager.backToCategories()
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
        
        lblTotal.font = normalFont
        lblCalculation.font = smallDetailFont
        
        
        
        //dequeueReusableCellWithReuseIdentifier("categorieCell", forIndexPath: indexPath) as! CategoryCollectionViewCell
        lblTotalTapRec.addTarget(self, action: "lblTotalTapped")
        lblTotal.addGestureRecognizer(lblTotalTapRec)
    
    }
    override func viewDidAppear(animated: Bool) {
        cvCalculator.reloadData()
    }
    
    func lblTotalTapped(){
        print("lblTotalTapped")
        model.transactionInfoManager.resetInput()
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
            if model.transactionInfoManager.category {
                
                count = model.transactionInfoManager.categories.count
            } else {
                count = model.transactionInfoManager.subcategories.count
            }
            return count
        }
        return model.transactionInfoManager.calculatorNumbers.count
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView === self.cvCategory {
            // var cellidentifier : String = "categoryCell"
            let cell : CategoryCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("categorieCell", forIndexPath: indexPath) as! CategoryCollectionViewCell
            //cell.backgroundColor = UIColor.whiteColor()
            //cell.layer.borderColor = UIColor.blackColor().CGColor
            cell.layer.borderWidth = 0.5
            cell.backgroundColor = UIColor.grayColor()
            if model.transactionInfoManager.selectedIndexSubCat == indexPath.row && !model.transactionInfoManager.category {
                cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
                model.transactionInfoManager.setSubCategory()
            }
            //cell.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
            //cell.frame.size.width = screenWidth / 3
            //cell.frame.size.height = screenWidth / 3
            cell.lblName.font = normalFont
            if model.transactionInfoManager.category{
                cell.lblName.text = model.transactionInfoManager.categories[indexPath.row].name
            } else {
                cell.lblName.text = model.transactionInfoManager.subcategories[indexPath.row].name
            }
            
            return cell
        } else {
            let cell : CalculatorCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("calculatorCell", forIndexPath: indexPath) as! CalculatorCollectionViewCell
            //cell.backgroundColor = UIColor.whiteColor()
            //cell.layer.borderColor = UIColor.blackColor().CGColor
            cell.layer.borderWidth = 0.5
            cell.lblNumber.font = normalFont
            if indexPath.row % 5 == 0 {     //non calculator part
                cell.backgroundColor = UIColor.grayColor()
                if (indexPath.row == 0){    //date
                    cell.lblNumber.text = model.getDateString(model.transactionInfoManager.transactionInfo.getDate())
                } else { //others
                    cell.lblNumber.text = model.transactionInfoManager.calculatorNumbers[indexPath.row]
                }
            } else {    //calculator part
                cell.backgroundColor = UIColor.whiteColor()
                cell.lblNumber.text = model.transactionInfoManager.calculatorNumbers[indexPath.row]
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
            if model.transactionInfoManager.selectedIndexSubCat != nil {
                let lastIndexPath : NSIndexPath = NSIndexPath(forRow: model.transactionInfoManager.selectedIndexSubCat!, inSection: 0)
                let celll = collectionView.cellForItemAtIndexPath(lastIndexPath)
                if !model.transactionInfoManager.category {
                    celll!.backgroundColor = UIColor.clearColor()
                }
            }
            
            print("Cell \(indexPath.row) selected")
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell!.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            if !model.transactionInfoManager.category {
                model.transactionInfoManager.selectedIndexSubCat = indexPath.row
            } else {
                model.transactionInfoManager.selectedIndexCat = indexPath.row
                model.transactionInfoManager.getSubCategories()
            }
            model.transactionInfoManager.category = false
            
            self.cvCategory.reloadData()
        } else {
            
            if indexPath.row % 5 == 0 { //Its not part of calculator
                print("Non calculator part")
                if indexPath.row == 0{
                    var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    var vc: UIViewController = storyboard.instantiateViewControllerWithIdentifier("CalendarViewController") as! UIViewController
                    
                    //var vc: NewViewController = storyboard.instantiateViewControllerWithIdentifier("newView") as NewViewController
                    
                    self.presentViewController(vc, animated: true, completion: nil)
                }
                
            } else {    //calculator part
                (lblTotal.text!,lblCalculation.text!) = model.transactionInfoManager.getTotalAndCalculation(indexPath.row)
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
