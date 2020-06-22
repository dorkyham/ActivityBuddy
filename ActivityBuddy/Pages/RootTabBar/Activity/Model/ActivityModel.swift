//
//  ActivityModel.swift
//  iWeather
//
//  Created by Annisa Nabila Nasution on 20/06/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit
import CoreData

struct ActivityModel{
    var title: String
    var duration: Int
    var date : Date
    var calories : Int
    var id:String
}

class ActivityStore {
    // fungsi tambah data
    func create(_ title:String, _ duration:Int, _ date:Date, _ calories: Int,  _ id: String){
        
        // referensi ke AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // refensi entity yang telah dibuat sebelumnya
        let entity = NSEntityDescription.entity(forEntityName: "Activity", in: managedContext)
        
        // entity body
        let insert = NSManagedObject(entity: entity!, insertInto: managedContext)
        insert.setValue(title, forKey: "title")
        insert.setValue(duration, forKey: "duration")
        insert.setValue(date, forKey: "date")
        insert.setValue(calories, forKey: "calories")
        insert.setValue(id, forKey: "id")
        
        do{
            // save data ke entity user core data
            try managedContext.save()
        }catch let err{
            print(err)
        }
        
    }
    
    // fungsi refrieve semua data
    func retrieve() -> [ActivityModel]{
        
        var activities = [ActivityModel]()
        
        // referensi ke AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // fetch data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        
        do{
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            result.forEach{ activity in
                activities.append(
                    ActivityModel(
                        title: activity.value(forKey: "title") as! String, duration: activity.value(forKey: "duration") as! Int, date: activity.value(forKey: "date") as! Date, calories: activity.value(forKey: "calories") as! Int,
                        id: activity.value(forKey: "id") as? String ?? "")
                )
            }
        }catch let err{
            print(err)
        }
        
        return activities
        
    }
    
    func delete(_ row: Int){

        // referensi ke AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        // managed context
        let managedContext = appDelegate.persistentContainer.viewContext

        // fetch data to delete
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Activity")
        //fetchRequest.predicate = NSPredicate(format: "email = %@", email)

        do{
            let dataToDelete = try managedContext.fetch(fetchRequest)[row] as! NSManagedObject
            managedContext.delete(dataToDelete)

            try managedContext.save()
        }catch let err{
            print(err)
        }
    }
    
    
    func update(_ duration:Int, _ date:Date, _ calories: Int, id:String){
    
        // referensi ke AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
        // managed context
        let managedContext = appDelegate.persistentContainer.viewContext
    
        // fetch data to delete
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Activity")
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            print(id)
        do{
            let fetch = try managedContext.fetch(fetchRequest)
            let dataToUpdate = fetch[0] as! NSManagedObject
            dataToUpdate.setValue(duration, forKey: "duration")
            dataToUpdate.setValue(date, forKey: "date")
            dataToUpdate.setValue(calories, forKey: "calories")
            
            try managedContext.save()
            print("saved")
        }catch let err{
                print(err)
        }
    
    }
    
}
