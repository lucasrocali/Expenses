//
//  AddExpenseViewController.swift
//  Expenses
//
//  Created by Lucas Rocali on 6/18/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit

class AddExpenseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBAction func addCategorieOrSubCategorie(sender: AnyObject) {
        var alert = UIAlertView()
        if category {
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
            if category {
                data.append(textField!.text)
            } else {
                subdata.append(textField!.text)
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
    var selectedIndex: Int?
    var category = true
    var calculatorNumbers = ["7","8","9","/","4","5","6","x","1","2","3","-","0",".","C","+"]
    var data = ["a","b","c","d","e","f","g","h","i"]
    var subdata = ["sa","sb","sc","sd","se"]
    var integer = 0
    @IBAction func backToCategories(sender: AnyObject) {
        //println("back to categorie")
        category = true
        selectedIndex = nil
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
            if category {
                
                count = data.count
            } else {
                count = subdata.count
            }
            return count
        }
        return calculatorNumbers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView === self.cvCategory {
            // var cellidentifier : String = "categoryCell"
            let cell : CategoryCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("categorieCell", forIndexPath: indexPath) as! CategoryCollectionViewCell
            //cell.backgroundColor = UIColor.whiteColor()
            //cell.layer.borderColor = UIColor.blackColor().CGColor
            cell.layer.borderWidth = 0.5
            cell.backgroundColor = UIColor.grayColor()
            if selectedIndex == indexPath.row && !category {
                cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            }
            //cell.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
            //cell.frame.size.width = screenWidth / 3
            //cell.frame.size.height = screenWidth / 3
            if category{
                cell.lblName.text = data[indexPath.row]
            } else {
                cell.lblName.text = subdata[indexPath.row]
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
            cell.lblNumber.text = calculatorNumbers[indexPath.row]
            return cell
        }
        
    }
    func getNumberWhitoutDot(str: String) -> String {
        var t : String = ""
        for s in str{
            if s == "."{
                break
            }
            t = t + "\(s)"
        }
        return t
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if collectionView === self.cvCategory {
            if selectedIndex != nil {
                var lastIndexPath : NSIndexPath = NSIndexPath(forRow: selectedIndex!, inSection: 0)
                var celll = collectionView.cellForItemAtIndexPath(lastIndexPath)
                if !category {
                    celll!.backgroundColor = UIColor.clearColor()
                }
            }
            
            println("Cell \(indexPath.row) selected")
            var cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell!.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            if !category {
                selectedIndex = indexPath.row
            }
            category = false
            self.cvCategory.reloadData()
        } else {
            if calculatorNumbers[indexPath.row] == "C" {
                lblTotal.text = "0"
                lblCalculation.text = "0"
                integer = 0
            }
            if (indexPath.row + 1)%4 != 0 && indexPath.row != 14{
                if indexPath.row == 13 {
                    integer = 1
                } else {
                    var lastTotal : String = lblTotal.text! as String
                    var total = "0"
                    if integer == 0 {
                        if lastTotal == "0" {
                            total = calculatorNumbers[indexPath.row] + ".00"
                        } else {
                            total = getNumberWhitoutDot(lastTotal) + calculatorNumbers[indexPath.row] + ".00"
                        }
                        lblTotal.text = total
                        lblCalculation.text = total
                        println("Pressed \(calculatorNumbers[indexPath.row]) at \(indexPath.row)")
                    } else if integer == 1{
                        integer = 2
                        total = getNumberWhitoutDot(lastTotal) + "." + calculatorNumbers[indexPath.row] + "0"
                         lblTotal.text = total
                        lblCalculation.text = total
                       println("PRIMEIRO DECIMAL")
                    }
                    else if integer == 2{
                        
                        total = lastTotal.substringToIndex(lastTotal.endIndex.predecessor()) + calculatorNumbers[indexPath.row]
                        lblTotal.text = total
                        lblCalculation.text = total
                        println("SEGUNDO DECIMAL")
                        integer = 3
                    }
                }
            } else {
                
            }
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
