//
//  SettingViewController.swift
//  Expenses
//
//  Created by Lucas Rocali on 2/11/16.
//  Copyright © 2016 Lucas Rocali. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
   
    var model = Model.sharedInstance
  
    @IBOutlet weak var lblCurrentMonth: UILabel!
    @IBOutlet weak var txtFldCurrentMonth: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let keyboardTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(keyboardTap)
        self.lblCurrentMonth.font = normalFont
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func insrtCurrentMonth(sender: AnyObject) {
        model.balanceManager.setCurrentMonth(Int(txtFldCurrentMonth.text!)!)
    }

    func dismissKeyboard() {
        view.endEditing(true)
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
