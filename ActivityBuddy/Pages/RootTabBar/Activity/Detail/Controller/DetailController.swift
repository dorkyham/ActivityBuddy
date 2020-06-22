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
    
    let datePicker = UIDatePicker()
    var pickerToolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableView()
        
        navigationItem.title = activityData?.title
        titleLabel.text = activityData?.title
        
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.edit))
        
        self.navigationItem.rightBarButtonItem  = editButton
        // Do any additional setup after loading the view.
        
    }
    
    
    
    @objc func edit(){
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.save))
        
        self.navigationItem.rightBarButtonItem  = saveButton
        
        guard let durationCell = detailTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ActivityDetailCell, let timeCell =  detailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ActivityDetailCell, let caloriesCell =  detailTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? ActivityDetailCell else {return}
        
        durationCell.detailTF.isEnabled = true
        timeCell.detailTF.isEnabled = true
        caloriesCell.detailTF.isEnabled = true
        
        //set form
        durationCell.detailTF.keyboardType = .asciiCapableNumberPad
        caloriesCell.detailTF.keyboardType = .asciiCapableNumberPad
        self.datePicker.datePickerMode = .dateAndTime
        self.datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        self.datePicker.maximumDate = Date()
        timeCell.detailTF.inputView = self.datePicker
        timeCell.detailTF.inputAccessoryView = self.pickerToolBar
        pickerToolBar = UIToolbar()
        pickerToolBar.isTranslucent = true
        pickerToolBar.sizeToFit()
    }
    
    @objc func save(){
        guard let durationCell = self.detailTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ActivityDetailCell, let timeCell =  self.detailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ActivityDetailCell, let caloriesCell =  self.detailTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? ActivityDetailCell else {return}
        
        //disable tf
        durationCell.detailTF.isEnabled = false
        timeCell.detailTF.isEnabled = false
        caloriesCell.detailTF.isEnabled = false
        
        let alert = UIAlertController(title: "Save Data", message: "Save the changed data?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action) -> Void in
            let successAlert = UIAlertController(title: "Data Saved", message: "Data has been saved", preferredStyle: UIAlertController.Style.alert)
            successAlert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(successAlert, animated: true, completion:nil)
            //save the data
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM y hh:mm aa"
            let date = dateFormatter.date(from: timeCell.detailTF.text!)
            let duration : Int = Int(durationCell.detailTF.text!) ?? 0
            let calories : Int = Int(caloriesCell.detailTF.text!) ?? 0
            
            ActivityStore().update(duration, date!, calories, id: self.activityData!.id)
            
            self.activityData?.date = date!
            self.activityData?.calories = calories
            self.activityData?.duration = duration
            
            self.detailTableView.reloadData()
            
            let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.edit))
            
            self.navigationItem.rightBarButtonItem  = editButton
        }
        let noAction = UIAlertAction(title: "No", style: .default) { (action) -> Void in
            let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.edit))
            
            self.detailTableView.reloadData()
            self.navigationItem.rightBarButtonItem  = editButton
        }
        alert.addAction(okAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion:nil)
        
    }
    
    func loadTableView(){
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.register(UINib(nibName: "ActivityDetailCell", bundle: nil), forCellReuseIdentifier: "detailCell")
        detailTableView.reloadData()
        
        detailTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: detailTableView.frame.size.width, height: 1))
    }

    @objc func dateChanged (datePicker : UIDatePicker, activeTF : UITextField) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM y hh:mm aa"
        activeTF.text = dateFormatter.string(from:datePicker.date)
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
            cell?.detailTF.isEnabled = false
        }
                   
        else if indexPath.row == 1{
            let formatter = DateFormatter()
            //then again set the date format whhich type of output you need
            formatter.dateFormat = "dd MMM y hh:mm aa"
            // again convert your date to string
            let date = formatter.string(from: activityData!.date)
            cell?.titleLabel.text = "Exercise Time"
            cell?.detailTF.text = date
            
            cell?.detailTF.isEnabled = false
        }
               
        else if indexPath.row == 2{
            cell?.titleLabel.text = "Calories Burned"
            cell?.detailTF.text = "\(activityData?.calories ?? 0)"
            
            cell?.detailTF.isEnabled = false
        }
        
        return cell!
    }
    
    
}
