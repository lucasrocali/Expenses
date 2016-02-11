//
//  CategoryTableViewCell.swift
//  Expenses
//
//  Created by Lucas Rocali on 2/1/16.
//  Copyright © 2016 Lucas Rocali. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblNEntries: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
