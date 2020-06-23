//
//  HomeController.swift
//  iWeather
//
//  Created by Annisa Nabila Nasution on 19/06/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit
import CoreLocation

class HomeController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var citiesTableView: UITableView!
    
    var cities : [CityModel]?
    var currentCity : CityModel?
    var url: String?
    var cityName:String?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cities = DataStore().retrieve()
        loadTableView()
        checkLocation()
    }
    
    func loadTableView(){
        citiesTableView.delegate = self
        citiesTableView.dataSource = self
        citiesTableView.register(UINib(nibName: "TempViewCell", bundle: nil), forCellReuseIdentifier: "tempCell")
        citiesTableView.register(UINib(nibName: "CitiesListCell", bundle: nil), forCellReuseIdentifier: "cityCell")
        citiesTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        DispatchQueue.main.async {
            self.citiesTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "goToDetail" {
               if let ViewController = segue.destination as? WeatherController {
                       ViewController.JSONurl = url
                       ViewController.cityName = cityName
               }
           }
    }
    
    func checkLocation(){
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations.last!
        var distance : Double = 100000
        for city in cities! {
            guard let url = URL(string: city.url!) else {return}
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                      error == nil else {
                      print(error?.localizedDescription ?? "Response Error")
                      return }
                do{
                    //here dataResponse received from a network request
                   if let jsonResponse = try JSONSerialization.jsonObject(with:
                        dataResponse, options: []) as? [String : Any]
                    {
                       
                        if let coord = jsonResponse["coord"]! as? [String : Any] {
                            let lon = coord["lon"] as? Double
                            let lat = coord["lat"] as? Double
                            let coordinate = CLLocation(latitude: lat!, longitude: lon!)
                            if(location.distance(from: coordinate) < distance){
                                print(distance)
                                distance = location.distance(from: coordinate)
                                UserDefaults.standard.set(city.name, forKey: "currentCity")
                                if let temp = jsonResponse["main"]! as? [String : Any] {
                                    var tempMain = temp["temp"] as? Double
                                    DispatchQueue.main.async {
                                        tempMain = tempMain! - 273.15
                                        let string = String(format: "%.1f", tempMain ?? 0)
                                        UserDefaults.standard.set(string, forKey: "currentTemp")
                                    }
                                }
                                                       
                                if let weather = (jsonResponse["weather"]! as! NSArray).mutableCopy() as? NSMutableArray {
                                    let item = weather[0] as? [String : Any]
                                    let main = item!["main"] as? String
                                    UserDefaults.standard.set(main, forKey: "currentWeather")
                                }
                            }
                        }
                        
                   }
                    
                     //Response result
                 } catch let parsingError {
                    print("Error", parsingError)
               }
            }
            task.resume()
        }
        
        //locationManager stops updating location
        locationManager.stopUpdatingLocation()
           
           
    }
    
}

extension HomeController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities!.count + 1
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
            cellTemp?.selectionStyle = .none
            cellTemp?.cityLabel.text = UserDefaults.standard.string(forKey: "currentCity")
            cellTemp?.tempLabel.text = UserDefaults.standard.string(forKey: "currentTemp")
            cellTemp?.weatherLabel.text = UserDefaults.standard.string(forKey: "currentWeather")
            return cellTemp!
        }
            let cell  = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as? CitiesListCell
            cell?.accessoryType = .disclosureIndicator
            cell?.cityLabel.text = cities?[indexPath.row - 1].name
            return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            self.cityName = cities![indexPath.row - 1].name
            self.url = cities![indexPath.row - 1].url
            performSegue(withIdentifier: "goToDetail", sender: nil)
        }
    }
    
}
