//
//  StepDataListController.swift
//  iWeather
//
//  Created by Annisa Nabila Nasution on 22/06/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit
import HealthKit

class StepDataListController: UIViewController {

    var hkManager: HealthKitManager = HealthKitManager()
    var hkStats: [HKStatistics]?
    var totalStepsDouble: Double = 0
    
    @IBOutlet weak var totalSteps: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        hkManager.getAllStepsDataStatisticInMonth { (stats) in
            self.hkStats = stats
            self.loadTableView()
            DispatchQueue.main.async {
                for stat in stats! {
                    if let sum = stat.sumQuantity() {
                        var resultCount = 0.0
                        // Get steps (they are of double type)
                        resultCount = sum.doubleValue(for: HKUnit.count())
                        self.totalStepsDouble = self.totalStepsDouble + resultCount
                    }
                }
                self.totalSteps.text = "\(Int(self.totalStepsDouble))"
            }
        }
        navigationItem.title = "All Data"
        // Do any additional setup after loading the view.
    }
    
    func loadTableView(){
        DispatchQueue.main.async {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.register(UINib(nibName: "DataListCell", bundle: nil), forCellReuseIdentifier: "dataCell")
            self.tableView.reloadData()
            self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 1))
        }
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

extension StepDataListController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hkStats?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as? DataListCell
        
        if let sum = hkStats![(hkStats!.count - 1) - indexPath.row].sumQuantity() {
                var resultCount = 0.0
                // Get steps (they are of double type)
                resultCount = sum.doubleValue(for: HKUnit.count())
                cell?.activityLabel.text = "\(Int(resultCount)) steps"
        }
        cell?.detailButton.isHidden = true
        cell?.detailButton.isEnabled = false
        let formatter = DateFormatter()
               //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
               // again convert your date to string
        let startDate = formatter.string(from: (hkStats![(hkStats!.count - 1) - indexPath.row].startDate))
        cell?.dateLabel.text = startDate
        return cell!
    }
    
    
    
}
