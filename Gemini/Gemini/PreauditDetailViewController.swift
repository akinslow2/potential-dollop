//
//  PreauditDetailViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/22/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit

class PreauditDetailViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var label: UILabel!
    
    let gas_structures = ["A", "B", "C", "D"]
    let electric_structures = ["E", "F", "G"]
    let utility_companies = ["PG&E", "SMUD", "Other"]
    let facility_types = ["Auditorium"]
    
    
    /*
    
    Picker View Start
 
    */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if activeDetail == "rate_structure_gas" {
            
            return gas_structures.count
            
        } else if activeDetail == "rate_structure_electric" {
            
            return electric_structures.count
            
        } else if activeDetail == "utility_company" {
            
            return utility_companies.count
            
        } else if activeDetail == "facility_type" {
            
            return facility_types.count
            
        }
        
        return 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if activeDetail == "rate_structure_gas" {
            
            return gas_structures[row]
            
        } else if activeDetail == "rate_structure_electric" {
            
            return electric_structures[row]
            
        } else if activeDetail == "utility_company" {
            
            return utility_companies[row]
            
        } else if activeDetail == "facility_type" {
            
            return facility_types[row]
            
        }
        
        return ""
        
    }
    
    /*
     
     Picker View End
     
     */
    
    /*
     
     Keyboard Controls Start
     
     */
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    /*
     
     Keyboard Controls End
     
     */
    
    @IBAction func donePressed(_ sender: Any) {
        
        if !textField.isHidden {
            
            //Store text
            
        } else if !datePicker.isHidden {
            
            //Store date
            
        } else {
            
            //Store selected item
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        textField.isHidden = true
        pickerView.isHidden = true
        datePicker.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        textField.isHidden = true
        pickerView.isHidden = true
        datePicker.isHidden = true
        
        label.text = "\(activeDetail)"
        
        if activeDetail == "date_of_interview" {
            
            datePicker.isHidden = false
            
        } else if activeDetail == "rate_structure_gas" || activeDetail == "rate_structure_electric" || activeDetail == "utility_company" || activeDetail == "facility_type" {

            pickerView.isHidden = false
            
            pickerView.reloadAllComponents()
            
        } else if activeDetail == "business_name" || activeDetail == "business_address" || activeDetail == "client_interviewed_name" || activeDetail == "client_interviewed_position" || activeDetail == "main_client_name" || activeDetail == "main_client_position" || activeDetail == "auditors_names" || activeDetail == "notes" {
            
            textField.isHidden = false
            textField.keyboardType = UIKeyboardType.default
            
        } else if activeDetail == "main_client_email" {
            
            textField.isHidden = false
            textField.keyboardType = UIKeyboardType.emailAddress
            
        } else {
            
            textField.isHidden = false
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
    }

}
