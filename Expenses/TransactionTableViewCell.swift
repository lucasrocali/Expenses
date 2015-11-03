//
//  TransactionTableViewCell.swift
//  Expenses
//
//  Created by Lucas Rocali on 11/2/15.
//  Copyright © 2015 Lucas Rocali. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblSubCategory: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
