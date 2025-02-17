//
//  ActivityController.swift
//  iWeather
//
//  Created by Annisa Nabila Nasution on 20/06/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit
import HealthKit

class ActivityController: UIViewController {

    @IBOutlet weak var caloriesLabel: UILabel!
    
    @IBOutlet weak var activityTableView: UITableView!
    
    @IBOutlet weak var stepsLabel: UILabel!
    var data : [ActivityModel]?
    var calories : Int? = 0
    
    var selectedData : ActivityModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.data = ActivityStore().retrieve()
        self.loadTableView()
    
        HealthKitManager().getStepDataAfterRequestAuthorization { (result) in
            self.stepsLabel.text = "\(result)"
        }
        //stepsLabel.text = "0"
        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = false
        
        
    }
    
    func loadTodayCalories(){
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let nowString = formatter.string(from: now)
    
    
        for oneData in data! {
            let dateActivity = formatter.string(from: oneData.date)
            if  dateActivity  == nowString {
                calories! += oneData.calories
            }
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calories = 0
        
        self.data = ActivityStore().retrieve()
        loadTodayCalories()
        activityTableView.reloadData()
        caloriesLabel.text = "\(calories ?? 0)"
    }
    
    func loadTableView(){
        activityTableView.delegate = self
        activityTableView.dataSource = self
        activityTableView.register(UINib(nibName: "DataListCell", bundle: nil), forCellReuseIdentifier: "dataCell")
        activityTableView.reloadData()
        activityTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: activityTableView.frame.size.width, height: 1))
    }
    
    @IBAction func showDataIsTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToStepData", sender: nil)
    }
    
    @IBAction func writeIsTapped(_ sender: Any) {
        print("button write is tapped")
        performSegue(withIdentifier: "goToWritePost", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailActivity" {
            let destinationVC = segue.destination as! DetailController
            destinationVC.activityData = selectedData
        }
    }
    
    @objc func reloadTable() {
          DispatchQueue.main.async { //please do all interface updates in main thread only
          self.activityTableView.reloadData()
          self.viewWillAppear(true)
    } }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ActivityController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as? DataListCell
        cell?.activityLabel.text = data?[indexPath.row].title
        
        let formatter = DateFormatter()
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let date = formatter.string(from: (data?[indexPath.row].date)!)

        cell?.delegate = self
        cell?.cellNumber = indexPath.row
        
        cell?.dateLabel.text = date
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            ActivityStore().delete(indexPath.row)
            data?.remove(at: indexPath.row)
            self.activityTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.bottom)
            self.perform(#selector(reloadTable), with: nil, afterDelay: 0.5)
        }
    }
    
    
}

extension ActivityController : CellProtocol {
    func goToDetails(cellNumber: Int) {
        print("button tapped")
        self.selectedData = data?[cellNumber]
        performSegue(withIdentifier: "goToDetailActivity", sender: nil)
    }
    
}

