//
//  StepDataListController.swift
//  iWeather
//
//  Created by Annisa Nabila Nasution on 22/06/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit

class StepDataListController: UIViewController {

    var steps: [Step]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HealthKitManager().getAllStepsData { (steps) in
            self.steps = steps
            print(steps)
        }
        navigationController?.title = "Data"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
