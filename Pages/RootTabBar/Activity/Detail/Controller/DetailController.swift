//
//  DetailController.swift
//  iWeather
//
//  Created by Annisa Nabila Nasution on 20/06/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    
    var activityData : ActivityModel?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableView()
        titleLabel.text = activityData?.title
        // Do any additional setup after loading the view.
    }
    
    func loadTableView(){
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.register(UINib(nibName: "ActivityDetailCell", bundle: nil), forCellReuseIdentifier: "detailCell")
        detailTableView.reloadData()
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

extension DetailController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? ActivityDetailCell
        
        if indexPath.row == 0 {
            cell?.titleLabel.text = "Minutes Performed"
            cell?.detailTF.text = "\(activityData?.duration ?? 0)"
        }
                   
        else if indexPath.row == 1{
            let formatter = DateFormatter()
            //then again set the date format whhich type of output you need
            formatter.dateFormat = "hh:mm aa"
            // again convert your date to string
            let date = formatter.string(from: activityData!.date)
            cell?.titleLabel.text = "Exercise Time"
            cell?.detailTF.text = date
        }
               
        else if indexPath.row == 2{
            cell?.titleLabel.text = "Calories Burned"
            cell?.detailTF.text = "\(activityData?.calories ?? 0)"
        }
        
        return cell!
    }
    
    
}
