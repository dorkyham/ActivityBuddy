//
//  FoodModel.swift
//  ActivityBuddy
//
//  Created by Annisa Nabila Nasution on 22/06/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit
import CoreData

struct FoodModel {
    var name:String?
    var calories:Int?
    var date:Date?
}

struct FoodManager {
    // fungsi tambah data
    func create(_ title:String, _ date:Date, _ calories: Int){
        
        // referensi ke AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // refensi entity yang telah dibuat sebelumnya
        let entity = NSEntityDescription.entity(forEntityName: "Food", in: managedContext)
        
        // entity body
        let insert = NSManagedObject(entity: entity!, insertInto: managedContext)
        insert.setValue(title, forKey: "name")
        insert.setValue(date, forKey: "date")
        insert.setValue(calories, forKey: "calories")
        
        do{
            // save data ke entity user core data
            try managedContext.save()
        }catch let err{
            print(err)
        }
        
    }

    // fungsi refrieve semua data
    func retrieve() -> [FoodModel]{
        
        var foods = [FoodModel]()
        
        // referensi ke AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // fetch data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
        
        do{
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            result.forEach{ food in
                foods.append(
                    FoodModel(name: (food.value(forKey: "name") as! String), calories: (food.value(forKey: "calories") as! Int), date: (food.value(forKey: "date") as! Date))
                )
            }
        }catch let err{
            print(err)
        }
        
        return foods
        
    }

    func delete(_ row: Int){

        // referensi ke AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        // managed context
        let managedContext = appDelegate.persistentContainer.viewContext

        // fetch data to delete
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Food")
        //fetchRequest.predicate = NSPredicate(format: "email = %@", email)

        do{
            let dataToDelete = try managedContext.fetch(fetchRequest)[row] as! NSManagedObject
            managedContext.delete(dataToDelete)

            try managedContext.save()
        }catch let err{
            print(err)
        }
    }
    
    func deleteAllData(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }


}
