//
//  DataStore.swift
//  iWeather
//
//  Created by Annisa Nabila Nasution on 19/06/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import CoreData
import UIKit

struct CityModel {
    var name : String?
    var id: String?
    var url: String?
}

class DataStore {
    var cityList : [CityModel] = [CityModel(name: "Jakarta", id: "1642911", url: "http://api.openweathermap.org/data/2.5/weather?id=1642911&appid=825f0e675124787e49a7681ba18b9fba"), CityModel(name: "Bandung", id: "1650357", url: "http://api.openweathermap.org/data/2.5/weather?id=1650357&appid=825f0e675124787e49a7681ba18b9fba"), CityModel(name: "Serang", id: "1627549", url: "http://api.openweathermap.org/data/2.5/weather?id=1627549&appid=825f0e675124787e49a7681ba18b9fba"),
        CityModel(name: "Semarang", id: "1627896", url: "http://api.openweathermap.org/data/2.5/weather?id=1627896&appid=825f0e675124787e49a7681ba18b9fba"),
        CityModel(name: "Tangerang", id: "1625084", url: "http://api.openweathermap.org/data/2.5/weather?id=1625084&appid=825f0e675124787e49a7681ba18b9fba"),
        CityModel(name: "Bekasi", id: "1649378", url: "http://api.openweathermap.org/data/2.5/weather?id=1649378&appid=825f0e675124787e49a7681ba18b9fba"),
        CityModel(name: "Jogjakarta", id: "1621177", url: "http://api.openweathermap.org/data/2.5/weather?id=1621177&appid=825f0e675124787e49a7681ba18b9fba"),
        CityModel(name: "Surabaya", id: "1625822", url: "http://api.openweathermap.org/data/2.5/weather?id=1625822&appid=825f0e675124787e49a7681ba18b9fba"),
        CityModel(name: "Bogor", id: "1648473", url: "http://api.openweathermap.org/data/2.5/weather?id=1648473&appid=825f0e675124787e49a7681ba18b9fba"),
        CityModel(name: "Depok", id: "8144495", url: "http://api.openweathermap.org/data/2.5/weather?id=8144495&appid=825f0e675124787e49a7681ba18b9fba")
    ]
    
    func loadData(){
        for city in cityList {
            create(city.name!,city.id!,city.url!)
        }
    }
    
    // fungsi tambah data
    func create(_ name:String, _ id:String, _ url:String){
        
        // referensi ke AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // refensi entity yang telah dibuat sebelumnya
        let entity = NSEntityDescription.entity(forEntityName: "City", in: managedContext)
        
        // entity body
        let insert = NSManagedObject(entity: entity!, insertInto: managedContext)
        insert.setValue(name, forKey: "name")
        insert.setValue(id, forKey: "id")
        insert.setValue(url, forKey: "url")
        
        do{
            // save data ke entity user core data
            try managedContext.save()
        }catch let err{
            print(err)
        }
        
    }
    
    // fungsi refrieve semua data
    func retrieve() -> [CityModel]{
        
        var cities = [CityModel]()
        
        // referensi ke AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // fetch data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        
        do{
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            result.forEach{ city in
                cities.append(
                    CityModel(
                        name: city.value(forKey: "name") as! String, id: city.value(forKey: "id") as! String, url: city.value(forKey: "url") as! String)
                )
            }
        } catch let err{
            print(err)
        }
        
        return cities
        
    }

//    func delete(_ row: Int){
//
//        // referensi ke AppDelegate
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//
//        // managed context
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        // fetch data to delete
//        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Activity")
//        //fetchRequest.predicate = NSPredicate(format: "email = %@", email)
//
//        do{
//            let dataToDelete = try managedContext.fetch(fetchRequest)[row] as! NSManagedObject
//            managedContext.delete(dataToDelete)
//
//            try managedContext.save()
//        }catch let err{
//            print(err)
//        }
//    }
}
