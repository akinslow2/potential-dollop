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
    var facility_types = Array<String>()
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
        
        if activeDetail == "Rate Structure Gas" {
            
            return gas_structures.count
            
        } else if activeDetail == "Rate Structure Electric" {
            
            return electric_structures.count
            
        } else if activeDetail == "Utility Company" {
            
            return utility_companies.count
            
        } else if activeDetail == "Facility Type" {
            
            return facility_types.count
            
        }
        
        return 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if activeDetail == "Rate Structure Gas" {
            
            selectedValueFromPicker = gas_structures[row]
            
        } else if activeDetail == "Rate Structure Electric" {
            
            selectedValueFromPicker = electric_structures[row]
            
        } else if activeDetail == "Utility Company" {
            
            selectedValueFromPicker = utility_companies[row]
            
        } else if activeDetail == "Facility Type" {
            
            selectedValueFromPicker = facility_types[row]
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if activeDetail == "Rate Structure Gas" {
            
            return gas_structures[row]
            
        } else if activeDetail == "Rate Structure Electric" {
            
            return electric_structures[row]
            
        } else if activeDetail == "Utility Company" {
            
            return utility_companies[row]
            
        } else if activeDetail == "Facility Type" {
            
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
        
        print(audit.outputs)
        
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
                
            else { return nil }
            
            output_file_string = try String(contentsOfFile: path).replacingOccurrences(of: "\t", with: ",")
            
        } catch {
            
            print("There was an error")
            
            return nil
            
        }
        
        let csv = CSwiftV(with: output_file_string)
        
        
        return csv.keyedRows!
        
    }
    
    func loadPickerValues() {
        
        if let x = open_csv(filename: "CSVs/space_type") {
        
            for i in x {
                
                var space = ""
            
                for (_, value) in i {
                    
                    space += value + " "
                    
                }
                
                facility_types.append(space)
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        super.viewDidLoad()
        textField.isHidden = true
        pickerView.isHidden = true
        datePicker.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print(activeDetail)
        selectedValueFromPicker = ""
        textField.isHidden = true
        pickerView.isHidden = true
        datePicker.isHidden = true
        
        label.text = "\(activeDetail)"
        
        if activeDetail == "Date Of Interview" {
            
            datePicker.isHidden = false
            
        } else if activeDetail == "Rate Structure Gas" || activeDetail == "Rate Structure Electric" || activeDetail == "Utility Company" || activeDetail == "Facility Type" {
            
            loadPickerValues()

            pickerView.isHidden = false
            
            pickerView.reloadAllComponents()
            
            print(pickerView.numberOfComponents)
            
        } else if activeDetail == "Business Name" || activeDetail == "Business Address" || activeDetail == "Client Interviewed Name" || activeDetail == "Clien Interviewed Position" || activeDetail == "Main Client Name" || activeDetail == "Main Client Position" || activeDetail == "Auditors Names" || activeDetail == "Notes" {
            
            textField.isHidden = false
            textField.keyboardType = UIKeyboardType.default
            
        } else if activeDetail == "Main Client Email" {
            
            textField.isHidden = false
            textField.keyboardType = UIKeyboardType.emailAddress
            
        } else {
            
            textField.isHidden = false
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
    }

}
