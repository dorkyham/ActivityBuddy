//
//  AddFoodCell.swift
//  ActivityBuddy
//
//  Created by Annisa Nabila Nasution on 22/06/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit

protocol FoodCellProtocol {
    func addFood()
}

class AddFoodCell: UITableViewCell {
    var delegate:FoodCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addNewFood(_ sender: Any) {
        delegate?.addFood()
    }
}
