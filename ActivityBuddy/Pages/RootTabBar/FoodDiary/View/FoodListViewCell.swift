//
//  FoodListViewCell.swift
//  ActivityBuddy
//
//  Created by Annisa Nabila Nasution on 22/06/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit

class FoodListViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var caloriesLabel: UILabel!
    
    @IBOutlet weak var foodLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
