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
    
    var transactionState = 0 //0 to create, 1 to edit
    var transactionIndex : Int?
   
    func addCategorieOrSubCategorie() {
        let alert = UIAlertView()
        if model.transactionInfoManager.selectCategoryState {
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
            if model.transactionInfoManager.selectCategoryState {
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
            if transactionState == 0 {  //create
                model.transactionInfoManager.saveTransaction()
            } else {    //save
                model.transactionInfoManager.updateTransaction()
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            
            
            model.transactionInfoManager.defaultTransactionInfo()
           
            self.cvCategory.reloadData()
            lblTotal.text = "0"
            lblCalculation.text = "0"
           
        }
    }
    @IBAction func swpRight(sender: AnyObject) {
        print("Swipe right")
        
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
    
    let btnType = UIButton()
    let btnBackToCategories = UIButton()
    let btnAddCategory = UIButton()
    
    func typePressed() {
        //print(sender.restorationIdentifier!!)
        setTypeName()
    }
    
    func setTypeName() {
        model.transactionInfoManager.switchType()
        //let btnExpenseIncome : UIButton = sender as! UIButton
        //btnExpenseIncome.
        //btnType.setTitle("x", forState: .Normal)
        model.transactionInfoManager.backToCategories()
        self.cvCategory.reloadData()
    }
    
    func backToCategories() {
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
        
        cvCategory.backgroundColor = whiteColor
        
        self.cvCalculator.allowsMultipleSelection = true
        self.cvCalculator.delaysContentTouches = false
        
        cvCalculator.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        //btnType.
        
        lblTotal.font = normalFont
        lblCalculation.font = smallDetailFont
        
        if transactionState == 0 {  //create
            lblTotal.text = "0"
            lblCalculation.text = "0"
        } else {
            print("Lets edit \(transactionIndex!)")
            model.transactionInfoManager.setTransactionInfo(model.balanceManager.transactions[transactionIndex!])
            lblTotal.text = "\(model.transactionInfoManager.transactionInfo.getValue())"
            lblCalculation.text = "\(model.transactionInfoManager.transactionInfo.getValue())"
            cvCategory.reloadData()
            
            //btnExpenseIncome.setTitle(model.transactionInfoManager.transactionInfo.getType(), forState: .Normal)
        }
        
        
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
            if model.transactionInfoManager.selectCategoryState {
                
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
            let cell : CategoryCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("categorieCell", forIndexPath: indexPath) as! CategoryCollectionViewCell
            cell.backgroundColor = whiteColor
            cell.lblName.textColor = blackColor
            //cell.layer.borderColor = UIColor.blackColor().CGColor
            cell.layer.borderWidth = 0.3
            //cell.backgroundColor = UIColor.grayColor()
            if model.transactionInfoManager.selectedIndexSubCat == indexPath.row && !model.transactionInfoManager.selectCategoryState {
                cell.backgroundColor = greenBaseColor
                cell.lblName.textColor = whiteColor
                model.transactionInfoManager.setSubCategory()
            }
            cell.layer.borderColor = darkGrayColor.CGColor
            //cell.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
            //cell.frame.size.width = screenWidth / 3
            //cell.frame.size.height = screenWidth / 3
            cell.lblName.font = normalFont
            if model.transactionInfoManager.selectCategoryState{
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
            cell.layer.borderColor = darkGrayColor.CGColor
            
           
            
           

           // cell.lblNumber.textColor = UIColor.blackColor()
            cell.lblNumber.font = normalFont
            if indexPath.row % 5 == 0 {     //non calculator part
                 cell.backgroundColor = mediumGrayColor
                if (indexPath.row == 0){    //date
                    cell.lblNumber.text = model.getDateString(model.transactionInfoManager.transactionInfo.getDate())
                } else { //others
                    cell.lblNumber.text = model.transactionInfoManager.calculatorNumbers[indexPath.row]
                }
            } else {    //calculator part
                //cell.backgroundColor = UIColor.whiteColor()
                cell.lblNumber.text = model.transactionInfoManager.calculatorNumbers[indexPath.row]
                 cell.backgroundColor = lightGrayColor
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
                if !model.transactionInfoManager.selectCategoryState {
                    celll!.backgroundColor = UIColor.clearColor()
                }
            }
            
            
            
            print("Cell \(indexPath.row) selected")
            let cell : CategoryCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! CategoryCollectionViewCell
            
           
            

            
            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            if !model.transactionInfoManager.selectCategoryState {
                model.transactionInfoManager.selectedIndexSubCat = indexPath.row
                /*(cell.lblName.transform = CGAffineTransformMakeScale(0.1, 0.1)
                UIView.animateWithDuration(1.0,
                    delay: 0,
                    usingSpringWithDamping: 0.2,
                    initialSpringVelocity: 4.0,
                    options: UIViewAnimationOptions.AllowUserInteraction,
                    animations: {
                        cell.lblName.transform = CGAffineTransformIdentity
                    }, completion: nil)*/

            } else {
                model.transactionInfoManager.selectedIndexCat = indexPath.row
                model.transactionInfoManager.getSubCategories()
            }
            model.transactionInfoManager.selectCategoryState = false
            
            self.cvCategory.reloadData()
        } else {
             let cell : CalculatorCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)  as! CalculatorCollectionViewCell
        
            cell.lblNumber.transform = CGAffineTransformMakeScale(0.1, 0.1)
            UIView.animateWithDuration(1.0,
                delay: 0,
                usingSpringWithDamping: 0.2,
                initialSpringVelocity: 4.0,
                options: UIViewAnimationOptions.AllowUserInteraction,
                animations: {
                     cell.lblNumber.transform = CGAffineTransformIdentity
                }, completion: nil)
            

            
            if indexPath.row % 5 == 0 { //Its not part of calculator
                print("Non calculator part")
                if indexPath.row == 0{
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let vc: UIViewController = storyboard.instantiateViewControllerWithIdentifier("CalendarViewController") 
                    
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
    
    var animationFinished = true
    
    
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
            
            btnType.setTitleColor(UIColor.blackColor(), forState: .Normal)
            btnType.frame = CGRectMake(screenWidth/2-50, 0, 100, 50)
            btnType.addTarget(self, action: "typePressed", forControlEvents: .TouchUpInside)
            btnType.setTitle(model.transactionInfoManager.transactionInfo.getType(), forState: .Normal)
            btnType.titleLabel?.font = boldFont
            supplementaryView.addSubview(btnType)
            
            /*
            btnType.transform = CGAffineTransformMakeScale(0.1, 0.1)
            UIView.animateWithDuration(1.0,
                delay: 0,
                usingSpringWithDamping: 0.2,
                initialSpringVelocity: 4.0,
                options: UIViewAnimationOptions.AllowUserInteraction,
                animations: {
                    self.btnType.transform = CGAffineTransformIdentity
                }, completion: nil)
            */
            
            btnBackToCategories.setTitleColor(UIColor.blackColor(), forState: .Normal)
            btnBackToCategories.frame = CGRectMake(5, 0, 50, 50)
            btnBackToCategories.addTarget(self, action: "backToCategories", forControlEvents: .TouchUpInside)
            btnBackToCategories.setTitle("<", forState: .Normal)
            btnBackToCategories.titleLabel?.font = normalFont
            if (model.transactionInfoManager.selectCategoryState) {
                btnBackToCategories.hidden = true
            } else {
                btnBackToCategories.hidden = false
            }
            supplementaryView.addSubview(btnBackToCategories)
            
            
            btnAddCategory.setTitleColor(UIColor.blackColor(), forState: .Normal)
            btnAddCategory.frame = CGRectMake(screenWidth - 50, 0, 50, 50)
            btnAddCategory.addTarget(self, action: "addCategorieOrSubCategorie", forControlEvents: .TouchUpInside)
            btnAddCategory.setTitle("+", forState: .Normal)
            btnAddCategory.titleLabel?.font = normalFont
            supplementaryView.addSubview(btnAddCategory)
            
            supplementaryView.backgroundColor = orangeBaseColor
            return supplementaryView
        } else {
            let supplementaryView = cvCalculator.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier:"cvCalculatorHeader", forIndexPath: indexPath)
            //supplementaryView.backgroundColor = UIColor.blueColor()
            return supplementaryView
        }
        
    }
}
