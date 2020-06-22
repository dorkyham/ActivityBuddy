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
    var todayFoods: [FoodModel]?
    var totalCalories : Int? = 0
    var targetCalories : Int? = 1500
    var totalBurnedCalories : Int? = 0
    var activityData: [ActivityModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foods = FoodManager().retrieve()
        loadData()
        loadTableView()
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let nowString = formatter.string(from: now)
        
        print(foods!)
        for food in foods! {
            let dateFood = formatter.string(from: food.date!)
            if  dateFood  == nowString {
                self.todayFoods?.append(food)
                self.totalCalories = totalCalories! + food.calories!
            }
        }
        
        
        self.activityData = ActivityStore().retrieve()
        
        for activity in activityData! {
            let date = formatter.string(from: activity.date)
            if  date == nowString {
                totalBurnedCalories = totalBurnedCalories! + activity.calories
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
            FoodManager().create(nameTxt!, Date(), calories!)
            
            self.foods!.append(FoodModel(name: nameTxt, calories: calories, date: Date()))
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: self.foods!.count-1, section: 1)], with: .automatic)
            self.tableView.endUpdates()

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
    

    func clearData(){
        FoodManager().deleteAllData()
        foods = []
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

extension FoodDiaryController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return foods?.count ?? 0
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
            
        cell?.foodLabel.text = self.foods?[indexPath.row].name
        cell?.caloriesLabel.text = "\(self.foods?[indexPath.row].calories ?? 0)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            FoodManager().delete(indexPath.row)
            
            self.totalCalories = self.totalCalories! - foods![indexPath.row].calories!
            foods?.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.bottom)
            
            self.perform(#selector(reloadTable), with: nil, afterDelay: 0.5)
        }
    }
    
}
