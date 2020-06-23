//
//  Alert.swift
//  ActivityBuddy
//
//  Created by Annisa Nabila Nasution on 23/06/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit

class ErrorAlert {
    var blankTextAlert : UIAlertController?
    
    init() {
        blankTextAlert = UIAlertController(title: "Blank Fields",
        message: "Please fill all fields",
        preferredStyle: .alert)
    }
    
    show(){
        present(alert, animated: true, completion: nil)
    }
}
