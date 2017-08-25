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
    
    let gas_structures = Array<String>()
    let electric_structures = Array<String>()
    let utility_companies = ["PG&E", "SMUD", "CPAU"]
    let facility_types = Array<String>()
    var activeDetail = ""
    var selectedIndexPath = IndexPath()
    var selectedValueFromPicker = ""
    
    
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if activeDetail == "rate_structure_gas" {
            
            selectedValueFromPicker = gas_structures[row]
            
        } else if activeDetail == "rate_structure_electric" {
            
            selectedValueFromPicker = electric_structures[row]
            
        } else if activeDetail == "utility_company" {
            
            selectedValueFromPicker = utility_companies[row]
            
        } else if activeDetail == "facility_type" {
            
            selectedValueFromPicker = facility_types[row]
            
        }
        
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
    
    var validInput = false
    @IBAction func donePressed(_ sender: Any) {
        
        if !textField.isHidden {
            
            if !(textField.text?.isEmpty)! {
                
                validInput = true
                
                audit.outputs[activeDetail] = textField.text
                
            }
            
        } else if !datePicker.isHidden {
            
            validInput = true
            
            audit.outputs[activeDetail] = datePicker.description
            
        } else {
            
            if !selectedValueFromPicker.isEmpty {
                
                validInput = true
                
                audit.outputs[activeDetail] = selectedValueFromPicker
                
            }
            
        }
        
        performSegue(withIdentifier: "backToPreaudit", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "backToPreaudit" {
            
            if validInput {
                
                filledRows.append(selectedIndexPath.row)
                
            }
            
        }
        
    }
    
    func open_csv(filename:String) -> Array<Dictionary<String, String>>! {
        
        var output_file_string = ""
        
        do {
            
            guard let path = Bundle.main.path(forResource: filename, ofType: "txt")
                
            else {
                
                print("Can't find file")
                
                return nil
                
            }
                
                print(path)
                
                output_file_string = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            
        } catch {
            
            print("There was an error")
            
            return nil
            
        }
        
        let csv = CSwiftV(with: output_file_string)
        
        return csv.keyedRows!
        
    }
    
    func loadPickerValues() {
        
        let x = open_csv(filename: "SpaceType")
        print(x)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPickerValues()
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
        
        pickerView.reloadAllComponents()
        selectedValueFromPicker = ""
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
