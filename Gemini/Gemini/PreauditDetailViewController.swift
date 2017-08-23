//
//  PreauditDetailViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/22/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit

class PreauditDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var label: UILabel!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    @IBAction func donePressed(_ sender: Any) {
        
        if textField.alpha == 1 {
            
            //Store text
            
        } else if datePicker.alpha == 1 {
            
            //Store date
            
        } else {
            
            //Store selected item
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        label.text = "Please enter \(activeDetail)"
        
        if activeDetail == "date_of_interview" {
            
            datePicker.alpha = 1
            textField.alpha = 0
            pickerView.alpha = 0
            
        } else if activeDetail == "rate_structure_gas" || activeDetail == "rate_structure_electric" || activeDetail == "utility_company" || activeDetail == "facility_type" {
            
            datePicker.alpha = 0
            textField.alpha = 0
            pickerView.alpha = 1
            
            //Going to have to set the picker values here...
            
        } else if activeDetail == "business_name" || activeDetail == "business_address" || activeDetail == "client_interviewed_name" || activeDetail == "client_interviewed_position" || activeDetail == "main_client_name" || activeDetail == "main_client_position" || activeDetail == "auditors_names" || activeDetail == "notes" {
            
            datePicker.alpha = 0
            textField.alpha = 1
            pickerView.alpha = 0
            textField.keyboardType = UIKeyboardType.default
            
        } else if activeDetail == "main_client_email" {
            
            datePicker.alpha = 0
            textField.alpha = 1
            pickerView.alpha = 0
            textField.keyboardType = UIKeyboardType.emailAddress
            
        } else {
            
            datePicker.alpha = 0
            textField.alpha = 1
            pickerView.alpha = 0
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
    }

}
