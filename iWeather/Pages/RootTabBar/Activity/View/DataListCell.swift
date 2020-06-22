//
//  DataListCell.swift
//  iWeather
//
//  Created by Annisa Nabila Nasution on 20/06/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit

protocol CellProtocol {
    func goToDetails(cellNumber:Int)
}
class DataListCell: UITableViewCell {

    @IBOutlet weak var activityLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    var cellNumber: Int?
    var delegate: CellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func detailButtonIsTapped(_ sender: Any) {
        delegate?.goToDetails(cellNumber: cellNumber!)
    }
}
