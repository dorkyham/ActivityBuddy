//
//  FoodDiaryController.swift
//  ActivityBuddy
//
//  Created by Annisa Nabila Nasution on 22/06/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit

class FoodDiaryController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var foods : [FoodModel]?
    var breakfast, lunch, dinner: [FoodModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        loadTableView()
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        let now = Date()
        // get the user's calendar
        let calendar = Calendar.current

        // choose which date and time components are needed
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day
        ]

        // get the components
        let dateTimeComponents = calendar.dateComponents(requestedComponents, from: now)
        
        foods = FoodManager().retrieve()
        for food in foods! {
            let foodDateTimeComponents = calendar.dateComponents(requestedComponents, from: food.date!)
            if foodDateTimeComponents == dateTimeComponents {
                switch food.foodType {
                case 0: breakfast?.append(food)
                    break
                case 1: lunch?.append(food)
                    break
                case 2: dinner?.append(food)
                    break
                default:
                    break
                }
            }
        }
    }
    
    func loadTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HeaderFoodCell", bundle: nil), forCellReuseIdentifier: "headerCell")
        tableView.register(UINib(nibName: "FoodListViewCell", bundle: nil), forCellReuseIdentifier: "foodCell")
        tableView.reloadData()
           
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
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
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != 0 {
            return 60
        }
        
        return 90
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3 {
            return 0
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 1){
            return "Breakfast"
        }
        else if(section == 2){
            return "Lunch"
        }
        else if(section == 3){
            return "Dinner"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
             let cell  = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as? HeaderFoodCell
             return cell!
        }
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as? FoodListViewCell
        
        return cell!
    }
    
    
}
