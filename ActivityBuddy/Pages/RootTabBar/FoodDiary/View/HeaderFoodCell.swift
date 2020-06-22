//
//  HeaderFoodCell.swift
//  ActivityBuddy
//
//  Created by Annisa Nabila Nasution on 22/06/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit

class HeaderFoodCell: UITableViewCell {

    @IBOutlet weak var targetCaloriesLabel: UILabel!
    @IBOutlet weak var foodCaloriesLabel: UILabel!
    
    @IBOutlet weak var exerciseCaloriesLabel: UILabel!
    
    @IBOutlet weak var remainsCaloriesLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
