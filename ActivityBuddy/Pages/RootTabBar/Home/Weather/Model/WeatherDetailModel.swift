//
//  WeatherDetailModel.swift
//  iWeather
//
//  Created by Annisa Nabila Nasution on 19/06/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit

struct WeatherDetailModel {
    var main : String?
    var desc : String?
    var temp : String?
    var humidity: Int?
    var sunrise : String?
    var sunset: String?
    var speed:Double?
    var feels_like:String?
    var pressure:Int?
    var icon:String?
}

struct WeatherReader {
    
    func loadImage(url:String, completionHandler: @escaping (UIImage) -> ()) {
        let url = URL(string: url)
        var image : UIImage?
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async() {    // execute on main thread
                image = UIImage(data: data)
                completionHandler(image!)
            }
        }
        task.resume()
    }
    
    func readData(stringUrl:String?, completionHandler: @escaping ((WeatherDetailModel) -> ())){
        guard let url = URL(string: stringUrl!) else {return}
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
                    //print(jsonResponse)
                    let weather = (jsonResponse["weather"]! as! NSArray).mutableCopy() as? NSMutableArray
                    let item = weather?[0] as? [String : Any]
                    let desc = item!["description"] as? String
                    let main = item!["main"] as? String
                    let icon = item!["icon"] as? String
                    let iconURL = "http://openweathermap.org/img/wn/\(icon ?? "")@2x.png"
                    var sunrise:String?
                    var sunset:String?
                    var windSpeed: Double?
                    
                    if let sys = jsonResponse["sys"]! as? [String : Any] {
                        sunrise = self.getClock(timeSinceEpochInSec: Int((sys["sunrise"] as? Int)!))
                        sunset = self.getClock(timeSinceEpochInSec: Int((sys["sunset"] as? Int)!))
                    }
                    
                    if let wind = jsonResponse["wind"]! as? [String : Any] {
                        windSpeed = wind["speed"] as? Double
                        print(windSpeed)
                    }
                    
                    let temp = jsonResponse["main"]! as? [String : Any]
                    
                    var tempMain = temp!["temp"] as? Double
                    let pressure = temp!["pressure"] as? Int
                    let humidity = temp!["humidity"] as? Int
                    var tempFeelsLike = temp!["feels_like"] as? Double
                        DispatchQueue.main.async {
                            tempMain = tempMain! - 273.15
                            tempFeelsLike = tempFeelsLike! - 273.15
                            let string = String(format: "%.1f", tempMain ?? 0)
                            let feelsLikeString = String(format: "%.1f", tempFeelsLike ?? 0)
                            
        
                            completionHandler(WeatherDetailModel(main:main, desc:desc, temp: string, humidity: humidity, sunrise: sunrise, sunset: sunset, speed: windSpeed, feels_like: feelsLikeString, pressure: pressure, icon:iconURL))
                        }
                        
                    
               }
                
                 //Response result
             } catch let parsingError {
                print("Error", parsingError)
           }
        }
        task.resume()
    }
    
    func getClock(timeSinceEpochInSec:Int) -> String{
        let time : Date = NSDate(timeIntervalSince1970: TimeInterval(timeSinceEpochInSec)) as Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: time)
    }
}
