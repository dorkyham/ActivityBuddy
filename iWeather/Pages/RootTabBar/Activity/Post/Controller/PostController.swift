//
//  PostController.swift
//  iWeather
//
//  Created by Annisa Nabila Nasution on 20/06/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit

class PostController: UIViewController {

    
    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var durationTF: UITextField!
    
    
    @IBOutlet weak var caloriesTF: UITextField!
    
    @IBOutlet weak var exerciseTF: UITextField!
    
    let datePicker = UIDatePicker()
    var date : Date?
    var pickerToolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldConfig()
        // Do any additional setup after loading the view.
    }

    func setTextFieldConfig(){
        durationTF.attributedPlaceholder = NSAttributedString(string: "Duration", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        caloriesTF.attributedPlaceholder = NSAttributedString(string: "Estimated burned calories", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        exerciseTF.attributedPlaceholder = NSAttributedString(string: "Exercise time", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        titleTF.attributedPlaceholder = NSAttributedString(string: "Name of activity", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        durationTF.keyboardType = .asciiCapableNumberPad
        caloriesTF.keyboardType = .asciiCapableNumberPad
        self.datePicker.datePickerMode = .dateAndTime
        self.datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        self.datePicker.maximumDate = Date()
        exerciseTF.inputView = self.datePicker
        exerciseTF.inputAccessoryView = self.pickerToolBar
        pickerToolBar = UIToolbar()
        pickerToolBar.isTranslucent = true
        pickerToolBar.sizeToFit()
    }
    
    @IBAction func doneIsTapped(_ sender: Any) {
        if titleTF.text == "" || durationTF.text == "" || exerciseTF.text == "" || caloriesTF.text == "" {
            let alert = UIAlertController(title: "Empty Field", message: "Make sure to fill all fields", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let duration:Int? = Int(durationTF!.text!)
            let calories:Int? = Int(caloriesTF!.text!)
            let id:String? = generatePostID(length: 10)
            ActivityStore().create(titleTF.text!, duration!, date!, calories!, id!)
            print("data saved")
            let alert = UIAlertController(title: "Data Saved", message: "Your activity has been saved", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) -> Void in
                
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Activity", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "activity") as! ActivityController
                
                self.navigationController?.pushViewController(vc, animated: true)

            }
            alert.addAction(action)
            self.present(alert, animated: true, completion:nil)
        }
    }
    
    func generatePostID(length:Int) -> String{
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    @objc func dateChanged (datePicker : UIDatePicker, activeTF : UITextField) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM y hh:mm aa"
        exerciseTF.text = dateFormatter.string(from:datePicker.date)
        date = datePicker.date
    }

}
