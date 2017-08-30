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
    
    let gas_structures = Array<String>() //will be var with data
    let electric_structures = Array<String>() //will be var with data
    var facility_types = Array<String>()
    let utility_companies = ["PG&E", "SMUD", "CPAU"] //hard coded for now, can easily be changed
    
    var activeDetail = ""
    var selectedIndexPath = IndexPath()
    var selectedValueFromPicker = ""
    var filledRows = Array<Int>()
    var entries = Dictionary<String, String>()
    
    
    /*
    
    Picker View Start
 
    */
    
    /*
     
     Function: numberOfComponents
     ------------------------------
     Essentially returns the number of columns in the
     picker view.
    
    */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    /*
     
     Function: constructor, numberOfRowsInComponent
     ---------------------------------------------------
     Sets the number of rows in each column in the picker
     view. Returns the size of the Array relevant to the 
     selected category.
     
     */
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
    
    /*
     
     Function: constructor, titleForRow
     ---------------------------------------
     Indexes through the corresponding Array
     and sets the titles sequentially
     
     */
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
     
     Function: constructor, didSelectRow
     -------------------------------------
     Saves the value of the component selected
     
     */
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

    
    /*
     
     Picker View End
     
     */
    
    /*
     
     Keyboard Controls Start
     
     */
    
    /*
     
     Function: touchesBegan
     -------------------------
     Returns normal control to the view after
     a touch outside of the displayed keyboard
     
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    /*
     
     Function: textFieldShouldReturn
     --------------------------------
     Returns normal control to the view a user
     presses "return" on the keyboard
     
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    /*
     
     Keyboard Controls End
     
     */
    
    /*
     
     Function: donePressed
     -------------------------
     Determines which field is not hidden, 
     and checks if its input is empty, and
     sets a boolean for a valid input if
     there is an input.
     
     SEGUE~to TableViewController
     
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
    
    /*
     
     Function: prepare for segue
     ----------------------------
     Appends the most recent entry to the 
     global variable, filledRows, if valid
     
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "backToPreaudit" {
            
            if validInput {
                
                filledRows.append(selectedIndexPath.row)
                
                let tableViewController = segue.destination as! TableViewController
                
                tableViewController.filledRows = filledRows
                
                tableViewController.preaudit_inputs = entries
                
            }
            
        }
        
    }
    
    /*
     
     Function: open_csv
     --------------------
     Returns an Optional(Array<Dictionary<String, String>>)
     of the elements in a csv with the first column as
     the keys in the array, and the subsequent columns 
     are the values, corresponding to their shared row.
     
     For example:
     Category, Space Type
     A, Classroom
     B, Armory
     ->
     [{A : Classroom}, {B : Armory}]
     
     ***
     
     In order to input a file:
     
     1. Download as a .txt with \t separated values
     2. Open in Word and save as a .txt with UTF-8 encoding 
        and LF only
     3. In Xcode, File -> Add Files to ... -> *Select file and add to "CSVs" folder*
     
     ***
     
     @param file's name in folder, String
     
     Example: (for CSVs/space_type.csv), filename = "space_type"
     
     */
    func open_csv(filename:String) -> Array<Dictionary<String, String>>! {
        
        var output_file_string = ""
        
        do {
            
            guard let path = Bundle.main.path(forResource: "CSVs/" + filename, ofType: "txt")
                
            else { return nil }
            
            output_file_string = try String(contentsOfFile: path).replacingOccurrences(of: "\t", with: ",")
            
        } catch {
            
            print("There was an error in opening the csv")
            
            return nil
            
        }
        
        let csv = CSwiftV(with: output_file_string)
        
        
        return csv.keyedRows!
        
    }
    
    /*
     
     Function: loadPickerValues
     -------------------------
     Extracts items for facility_type
     option
     
     */
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
    
    /*
     
     Function: viewDidLoad
     -------------------------
     Loads view, sets all fields
     to hidden, sets delegates
     and dataSource for picker
     
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        pickerView.dataSource = self
        
        pickerView.delegate = self
        
        textField.isHidden = true
        
        pickerView.isHidden = true
        
        datePicker.isHidden = true
        
        self.navigationItem.hidesBackButton = true

        
    }
    
    /*
     
     Function: viewDidAppear
     -------------------------
     Called every time the view
     controller is refreshed. 
     
     Sets keyboard types, pickerView,
     or datePicker for all inputs.
     
     */
    override func viewDidAppear(_ animated: Bool) {
        
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
    
    /*
     
     Function: didReceiveMemoryWarning
     -----------------------------------
     Memory warning. Should clear storage here.
     
     */
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }

}
