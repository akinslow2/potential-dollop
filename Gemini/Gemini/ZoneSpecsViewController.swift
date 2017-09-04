//
//  ZoneSpecsViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/26/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit

class ZoneSpecsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    var spec = ""
    var selectedValue = ""
    let unit_values = ["Lumens", "Footcandles"]
    let room_types = ["Armory", "Assembly", "Social activity", "Writing area", "Beauty parlor"] //should be csv data
    var picker_values =  Array<String>()
    var filledRows = Array<Int>()
    var curr_row = -1
    var spaceType: String?
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    
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
        
        return picker_values.count
        
    }
    
    /*
     
     Function: constructor, titleForRow
     ---------------------------------------
     Indexes through the corresponding Array
     and sets the titles sequentially
     
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return picker_values[row]
        
    }
    
    /*
     
     Function: didSelectRow
     -------------------------------------
     Saves the value of the component selected in selectedValue
     
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedValue = picker_values[row]
        
    }
    
    
    /*
     
     Function: donePressed
     ------------------------------------
     If all values are entered properly, appends them to room's
     general_values dictionary and
     
     SEGUE~ to FeatureTableViewController
     
     */
    @IBAction func donePressed(_ sender: Any) {
        
        if (textField.text?.isEmpty)! && !textField.isHidden ||  selectedValue == "" && textField.isHidden {
            
            let alert_controller = UIAlertController(title: "Empty name", message: "Please provide a value", preferredStyle: UIAlertControllerStyle.alert)
            
            alert_controller.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                
                alert_controller.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert_controller, animated: true, completion: nil)
            
        } else {
            
            filledRows.append(curr_row)
            
            var value = ""
            
            if textField.isHidden {
                
                value = selectedValue
                
            } else {
                
                value = textField.text!
                
            }
            
            room?.general_values[spec] = value
            
            performSegue(withIdentifier: "toFeatureTable", sender: self)
            
        }
        
    }
    
    /*
     
     Function: viewDidLoad
     -------------------------
     Loads view, sets delegates
     and dataSource for picker, and hides
     back button
     
     
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        pickerView.delegate = self
        
        pickerView.dataSource = self
        
        self.navigationItem.hidesBackButton = true
        
    }

    /*
     
     Function: didReceiveMemoryWarning
     --------------------------------
     Memory warning. Should clear storage here.
     
     */
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }

    /*
     
     Function: viewDidAppear
     --------------------------------
     Loads the appropriate vehicle for data
     entry depending on what field is being entered
     
     */
    override func viewDidAppear(_ animated: Bool) {
        
        label.text = spec
                
        if spec == "Units" {
            
            textField.isHidden = true
            
            picker_values = unit_values
            
            pickerView.reloadAllComponents()
            
            selectedValue = picker_values[0]
            
        } else if spec == "Space Type" {
            
            textField.isHidden = true
            
            picker_values = room_types
            
            pickerView.reloadAllComponents()
            
            selectedValue = picker_values[0]
            
        } else {
            
            pickerView.isHidden = true
            
            if spec == "Area" {
                
                textField.keyboardType = UIKeyboardType.numberPad
                
            }
            
        }
        
    }
    
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
     
     Function: prepare for segue
     ------------------------------------
     Sets filledRows, space_type
     IF going to FeatureTableViewController
     
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let featureTableViewController = segue.destination as! FeatureTableViewController
        
        featureTableViewController.filledRows = filledRows
        
        featureTableViewController.space_type = spaceType
        
    }
    

}
