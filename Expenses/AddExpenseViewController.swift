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
    
    @IBAction func addCategorieOrSubCategorie(sender: AnyObject) {
        var alert = UIAlertView()
        if model.category {
            alert.title = "Enter new category"
        } else {
            alert.title = "Enter new sub category"
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
            print(textField!.text)
            if model.category {
                model.data.append(textField!.text)
            } else {
                model.subdata.append(textField!.text)
            }
            cvCategory.reloadData()
            
        } else {
            println("Cancel pressed")
        }
    }
    
    @IBOutlet var lblCalculation: UILabel!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var cvCalculator: UICollectionView!
    @IBOutlet weak var cvCategory: UICollectionView!
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
        @IBAction func backToCategories(sender: AnyObject) {
        //println("back to categorie")
        model.category = true
        model.selectedIndex = nil
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if collectionView === self.cvCategory {
            if model.category {
                
                count = model.data.count
            } else {
                count = model.subdata.count
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
            if model.selectedIndex == indexPath.row && !model.category {
                cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            }
            //cell.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
            //cell.frame.size.width = screenWidth / 3
            //cell.frame.size.height = screenWidth / 3
            if model.category{
                cell.lblName.text = model.data[indexPath.row]
            } else {
                cell.lblName.text = model.subdata[indexPath.row]
            }
            return cell
        } else {
            let cell : CalculatorCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("calculatorCell", forIndexPath: indexPath) as! CalculatorCollectionViewCell
            //cell.backgroundColor = UIColor.whiteColor()
            //cell.layer.borderColor = UIColor.blackColor().CGColor
            cell.layer.borderWidth = 0.5
            cell.backgroundColor = UIColor.whiteColor()
            //cell.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
            //cell.frame.size.width = screenWidth / 3
            //cell.frame.size.height = screenWidth / 3
            cell.lblNumber.text = model.calculatorNumbers[indexPath.row]
            return cell
        }
        
    }
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView === self.cvCategory {
            if model.selectedIndex != nil {
                var lastIndexPath : NSIndexPath = NSIndexPath(forRow: model.selectedIndex!, inSection: 0)
                var celll = collectionView.cellForItemAtIndexPath(lastIndexPath)
                if !model.category {
                    celll!.backgroundColor = UIColor.clearColor()
                }
            }
            
            println("Cell \(indexPath.row) selected")
            var cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell!.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            if !model.category {
                model.selectedIndex = indexPath.row
            }
            model.category = false
            self.cvCategory.reloadData()
        } else {
            println("Ihuu")
            (lblTotal.text!,lblCalculation.text!) = model.getTotalAndCalculation(indexPath.row, lastTotal: lblTotal.text!)
        }
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if collectionView === self.cvCategory {
            if model.selectedIndex != nil {
                var lastIndexPath : NSIndexPath = NSIndexPath(forRow: model.selectedIndex!, inSection: 0)
                var celll = collectionView.cellForItemAtIndexPath(lastIndexPath)
                if !model.category {
                    celll!.backgroundColor = UIColor.clearColor()
                }
            }
            
            println("Cell \(indexPath.row) selected")
            var cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell!.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            if !model.category {
                model.selectedIndex = indexPath.row
            }
            model.category = false
            self.cvCategory.reloadData()
        } else {
            println("Ihuu")
            (lblTotal.text!,lblCalculation.text!) = model.getTotalAndCalculation(indexPath.row, lastTotal: lblTotal.text!)
        }
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout:UICollectionViewLayout!,sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        if collectionView === self.cvCategory {
            return CGSize(width: screenWidth/6, height: screenWidth/6)
        }
        return CGSize(width: screenWidth/4, height: 250/4)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        //println("ip = \(indexPath.item)")
        if collectionView === self.cvCategory {
            var supplementaryView = cvCategory.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier:"cvHeader", forIndexPath: indexPath) as! UICollectionReusableView
            return supplementaryView
        } else {
            var supplementaryView = cvCalculator.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier:"cvCalculatorHeader", forIndexPath: indexPath) as! UICollectionReusableView
            //supplementaryView.backgroundColor = UIColor.blueColor()
            return supplementaryView
        }
        
    }
}
