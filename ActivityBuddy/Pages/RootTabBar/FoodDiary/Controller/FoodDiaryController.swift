//
//  FoodDiaryController.swift
//  ActivityBuddy
//
//  Created by Annisa Nabila Nasution on 22/06/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit

class FoodDiaryController: UIViewController, FoodCellProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    var foods : [FoodModel]?
    var todayFoods: [FoodModel] = []
    var totalCalories : Int? = 0
    var targetCalories : Int? = 1500
    var totalBurnedCalories : Int? = 0
    var activityData: [ActivityModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foods = FoodManager().retrieve()
        loadFoodData()
        loadTableView()
        // Do any additional setup after loading the view.
    }
    
    func generatePostID(length:Int) -> String{
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func loadFoodData(){
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let nowString = formatter.string(from: now)
        
        for food in foods! {
            let dateFood = formatter.string(from: food.date!)
            if  dateFood  == nowString {
                todayFoods.append(food)
                totalCalories = totalCalories! + food.calories!
            }
        }
        
    }
    
    func loadBurnedCalories() {
        totalBurnedCalories = 0
        self.activityData = ActivityStore().retrieve()
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let nowString = formatter.string(from: now)
        for activity in activityData! {
            let date = formatter.string(from: activity.date)
            if  date == nowString {
                totalBurnedCalories = totalBurnedCalories! + activity.calories
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        loadBurnedCalories()
        tableView.reloadData()
    }
    
    func addFood() {
        let alert = UIAlertController(title: "Add Food",
        message: "Insert food data",
        preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Food name"
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .asciiCapableNumberPad
            textField.placeholder = "Estimated Calories"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { (action) -> Void in
            // Get TextFields text
            let nameTxt = alert.textFields![0].text
            let calories = Int(alert.textFields![1].text!)
            let id = self.generatePostID(length: 10)
            FoodManager().create(id, nameTxt!, Date(), calories!)
            
            self.todayFoods.append(FoodModel(name: nameTxt, calories: calories, date: Date(), id:id))
            self.totalCalories = self.totalCalories! + calories!
            self.tableView.reloadData()
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        alert.addAction(addAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func loadTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HeaderFoodCell", bundle: nil), forCellReuseIdentifier: "headerCell")
        tableView.register(UINib(nibName: "FoodListViewCell", bundle: nil), forCellReuseIdentifier: "foodCell")
        tableView.register(UINib(nibName: "AddFoodCell", bundle: nil), forCellReuseIdentifier: "btnCell")
        tableView.reloadData()
           
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
       }
    
    @objc func reloadTable() {
          DispatchQueue.main.async { //please do all interface updates in main thread only
          self.tableView.reloadData()
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

extension FoodDiaryController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return todayFoods.count
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != 0 {
            return 60
        }
        
        return 90
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 1){
            return "Food List"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell  = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as? HeaderFoodCell
            cell?.targetCaloriesLabel.text = "\(targetCalories ?? 0)"
            cell?.foodCaloriesLabel.text = "\(totalCalories ?? 0)"
            cell?.exerciseCaloriesLabel.text = "\(totalBurnedCalories ?? 0)"
            cell?.remainsCaloriesLabel.text = "\(targetCalories! - totalCalories! + totalBurnedCalories!)"
             return cell!
        }
        
        else if(indexPath.section == 2){
            let cell  = tableView.dequeueReusableCell(withIdentifier: "btnCell", for: indexPath) as? AddFoodCell
            cell?.delegate = self
            return cell!
        }
            
        let cell  = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as? FoodListViewCell
            
        cell?.foodLabel.text = self.todayFoods[indexPath.row].name
        cell?.caloriesLabel.text = "\(self.todayFoods[indexPath.row].calories ?? 0)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.section == 1) {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if (editingStyle == .delete) {
                FoodManager().delete(todayFoods[indexPath.row].id!)
                self.totalCalories = self.totalCalories! - todayFoods[indexPath.row].calories!
                todayFoods.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.bottom)
                
                self.perform(#selector(reloadTable), with: nil, afterDelay: 0.5)
            }
            
            else if editingStyle == .insert {
                // Not used in our example, but if you were adding a new row, this is where you would do it.
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: self.todayFoods.count-1, section: 1)], with: .fade)
                self.tableView.endUpdates()
            }
        
    }
    
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
