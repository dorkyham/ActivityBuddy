//
//  WeatherController.swift
//  iWeather
//
//  Created by Annisa Nabila Nasution on 19/06/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit

class WeatherController: UIViewController {
    var JSONurl : String?
    var data : WeatherDetailModel?
    var cityName: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = cityName
        WeatherReader().readData(stringUrl: JSONurl) { (data) in
            self.data = data
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadTableView()
        }
    }
    
    func loadTableView(){
        tableView.reloadData()
        tableView.register(UINib(nibName: "TempViewCell", bundle: nil), forCellReuseIdentifier: "tempCell")
        tableView.register(UINib(nibName: "WeatherDetailViewCell", bundle: nil), forCellReuseIdentifier: "weatherCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension WeatherController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 159
        }
        return 63
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        if indexPath.row == 0 {
            let cellTemp  = tableView.dequeueReusableCell(withIdentifier: "tempCell", for: indexPath) as? TempViewCell
            cellTemp?.tempLabel?.text = data?.temp
            cellTemp?.cityLabel.text = cityName
            cellTemp?.weatherLabel.text = data?.main
            
            return cellTemp!
        }

        else if indexPath.row == 1 {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherDetailViewCell
            cell?.titleLabel.text = "Description"
            cell?.dataLabel.text = data?.desc
            return cell!
        }
            
        else if indexPath.row == 2{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherDetailViewCell
            cell?.titleLabel.text = "Humidity"
            let humidity : String? = "\(String(data?.humidity ?? 0)) %"
            cell?.dataLabel.text = humidity
            return cell!
        }
        
        else if indexPath.row == 3{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherDetailViewCell
            cell?.titleLabel.text = "Sunrise"
            cell?.dataLabel.text = data?.sunrise
            return cell!
        }
            
        else if indexPath.row == 4{
                let cell  = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherDetailViewCell
                cell?.titleLabel.text = "Sunset"
                cell?.dataLabel.text =  data?.sunset
                return cell!
        }

        else if indexPath.row == 5{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherDetailViewCell
            cell?.titleLabel.text = "Wind Speed"
            let speedString = "\(String(data?.speed ?? 0)) miles/hour"
            cell?.dataLabel.text = speedString
            return cell!
        }
        
        else if indexPath.row == 6{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherDetailViewCell
            cell?.titleLabel.text = "Feels Like"
            cell?.dataLabel.text = data?.feels_like
            return cell!
        }
        
        else {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherDetailViewCell
            cell?.titleLabel.text = "Pressure"
            cell?.dataLabel.text = "\(data?.pressure ?? 0) hPa"
            return cell!
        }
        
        
        return UITableViewCell()
    }
    
}
