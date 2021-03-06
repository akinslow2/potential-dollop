//
//  AuditInfoViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/26/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit

class AuditInfoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var modelNumberTextField: UITextField!
    @IBOutlet weak var productionLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var productionTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var productionAllowedValsLabel: UILabel!
    @IBOutlet weak var sizeAllowedValsLabel: UILabel!
    
    var feature = ""
    var generalFeature = ""
    var foundFeature: Bool?
    var filledRows = Array<Int>()
    var space_type = ""
    
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
    func open_csv(filename: String) -> Array<Dictionary<String, String>>! {
        
        let full_filename = "CSVs/" + filename
        
        var output_file_string = ""
        
        do {
            
            guard let path = Bundle.main.path(forResource: full_filename, ofType: "txt")
                
                else { return nil }
            
            output_file_string = try String(contentsOfFile: path).replacingOccurrences(of: "\t", with: ",")
            
        } catch {
            
            print("There was an error")
            
            return nil
            
        }
        
        let csv = CSwiftV(with: output_file_string)
        
        return csv.keyedRows!
        
    }
    
    /*
     
     Function: open_csv_rows
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
     [["Category", "Space Type"], ["A", "Classroom"], ["B", "Armory"]]
     
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
    func open_csv_rows(filename: String) -> [[String]]! {
        
        let full_filename = "CSVs/" + filename
        
        var output_file_string = ""
        
        do {
            
            guard let path = Bundle.main.path(forResource: full_filename, ofType: "txt")
                
                else { return nil }
            
            output_file_string = try String(contentsOfFile: path).replacingOccurrences(of: "\t", with: ",")
            
        } catch {
            
            print("There was an error")
            
            return nil
            
        }
        
        let csv = CSwiftV(with: output_file_string)
        
        return csv.rows
        
    }
    
    /*
     
     Function: is_energy_star
     --------------------------------
     True if the model is an energy star rated appliance
     False otherwise
     
     */
    func is_energy_star(model_number: String, company: String, file_name: String) -> Bool {
        
        let reference = feature_references[feature]!
        
        let rows = open_csv(filename: reference)
        
        for row in rows! {
            
            if row["company"] != company {
                
                continue
            }
            
            if row["model_number"] != model_number { //model_number must be revised. Not sure what it should be
                
                continue
                
            }
            
            return true
            
        }
        
        return false
    }
    
    /*
     
     Function: viewDidLoad
     -------------------------
     Loads view, sets delegates
     and dataSource for textfields, and hides
     back button
     
     
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        sizeTextField.delegate = self
        
        productionTextField.delegate = self
        
        companyTextField.delegate = self
        
        modelNumberTextField.delegate = self
        
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
     
     Function: searchForModel
     --------------------------------
     Checks to see that all necessary values are 
     provided. 
     
     If so, checks if specific appliance exists in the reference
     
     If so, calls new_feature
     
     If not, either segues to ask for additional values or asks for them
     on screen. 
     
     BUGGY
     
     */
    @IBAction func searchForModel(_ sender: Any) {
        
        if !(modelNumberTextField.text?.isEmpty)! && !(companyTextField.text?.isEmpty)! {
            
            room?.feature_table_keys.append(feature + " " + modelNumberTextField.text!)
            
            let found = is_energy_star(model_number: modelNumberTextField.text!, company: companyTextField.text!, file_name: feature_references[feature]!)
            
            foundFeature = found
            
            if found {
                
                room?.new_feature(feature_type: feature, values: retrieveValues(feature: feature))
                
                //calculate retrofit
                
                performSegue(withIdentifier: "backToFeatures", sender: self)
                
            } else {
                
                if feature == "Conveyor Oven" || feature == "Combination Oven" || feature == "Rack Oven" {
                    
                    change_display()
                    
                    var a = Array<String>()
                    var b = Array<String>()
                    
                    var aIndex = -1
                    var bIndex = -1
                    
                    if feature == "Rack Oven" {
                        
                        aIndex = 4
                        bIndex = 7
                        sizeLabel.text = "Size"
                        productionLabel.text = "Production Capacity"
                        
                    } else if feature == "Combination Oven" {
                        
                        aIndex = 4
                        bIndex = 8
                        sizeLabel.text = "Size"
                        productionLabel.text = "Fuel Type"
                        
                    } else if feature == "Conveyor Oven" {
                        
                        aIndex = 3
                        bIndex = 8
                        sizeLabel.text = "Oven Length"
                        productionLabel.text = "Conveyor Width"
                        
                    }
                    
                    if aIndex != -1 && bIndex != -1 {
                        
                        let csv = open_csv_rows(filename: feature_references[feature]!)
                        
                        for row in csv! {
                            
                            if row[0] == "Company" {
                                
                                continue
                                
                            }
                            
                            if !a.contains(row[aIndex]) {
                                
                                a.append(row[aIndex])
                                
                            }
                            
                            if !b.contains(row[bIndex]) {
                                
                                b.append(row[bIndex])
                                
                            }
                            
                        }
                        
                    }
                    
                    sizeAllowedValsLabel.text = "Possible values: " + a.description.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
                    sizeAllowedValsLabel.font = sizeAllowedValsLabel.font.withSize(10)
                    
                    productionAllowedValsLabel.text = "Possible values: " + b.description.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
                    productionAllowedValsLabel.font = productionAllowedValsLabel.font.withSize(10)
                    
                } else {
                    
                    performSegue(withIdentifier: "toExtra", sender: self)
                    
                }
                
            }
                
        }
        
    }
    
    /*
     
     Function: change_display
     --------------------------------
     Sets the display to unhidden in the case
     that the given appliance was not found in 
     the reference CSV.
     
     */
    func change_display() {
        
        productionLabel.isHidden = false
        
        sizeLabel.isHidden = false
        
        productionTextField.isHidden = false
        
        sizeTextField.isHidden = false
        
        doneButton.isHidden = false
        
        searchButton.isHidden = true
        
    }
    
    
    
    
    /*
     
     Function: retrieveValues
     --------------------------------
     Adds all the given values to a dictionary and then
     passes the dictionary on to the room class
     
     */
    func retrieveValues(feature: String) -> Dictionary<String, String> {
        
        var dict = Dictionary<String, String>()
        
        dict["model_number"] = modelNumberTextField.text
        
        if generalFeature == "Kitchen equipment" {
            
            dict["company"] = companyTextField.text
            
            if !foundFeature! {
                
                if feature == "Conveyor Oven" {
                    
                    dict["oven_length"] = sizeTextField.text!
                    
                    dict["conveyor_width"] = productionTextField.text!
                    
                } else if feature == "Combination Oven" {
                    
                    dict["fuel type"] = productionTextField.text!
                    
                    dict["size"] = sizeTextField.text!
                    
                } else if feature == "Rack Oven" {
                    
                    dict["size"] = sizeTextField.text
                    
                    dict["production_capacity"] = productionTextField.text
                    
                }
                
            }
            
        } else if generalFeature == "HVAC" {
            
            //nothing for now
            
        } else if generalFeature == "Lighting" {
            
            dict["num_lamps"] = companyTextField.text
            
            dict["test_hours"] = sizeTextField.text
            
            dict["hours_on"] = productionTextField.text
            
        } else {
            
            //plug load
            
        }
        
        return dict
        
    }
    
    /*
     
     Function: donePressed
     --------------------------------
     If all values are entered, then it augments the proper data,
     adds the new feature, and
     
     SEGUE~ to FeatureTableViewController
     
     */
    @IBAction func donePressed(_ sender: Any) {
        
        if (productionTextField.text?.isEmpty)! || (sizeTextField.text?.isEmpty)! {
            
            let alert_controller = UIAlertController(title: "Empty value(s)", message: "Please provide values", preferredStyle: UIAlertControllerStyle.alert)
            
            alert_controller.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                
                alert_controller.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert_controller, animated: true, completion: nil)
            
        } else {
            
            room?.augment(values: retrieveValues(feature: feature))
            
            if feature == "Lighting" {
                
                room?.feature_table_keys.append(feature + " " + modelNumberTextField.text!)
                
            }
            
            room?.new_feature(feature_type: feature, values: retrieveValues(feature: feature))
            
            performSegue(withIdentifier: "backToFeatures", sender: self)
            
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
     
     Function: viewDidAppear
     --------------------------------
     Sets all textfields and labels to the appropriate
     type of data to be entered
     
     */
    override func viewDidAppear(_ animated: Bool) {
        
        print(feature)
        
        if feature != "Lighting" && feature != "HVAC" {
            
            generalFeature = "Kitchen equipment" //or plug load but we don't have any yet
            
            productionLabel.isHidden = true
            
            sizeLabel.isHidden = true
            
            productionTextField.isHidden = true
            
            sizeTextField.isHidden = true
            
            doneButton.isHidden = true
            
        } else if feature == "Lighting" {
            
            generalFeature = feature
            
            companyLabel.text = "Number of lamps"
            
            companyTextField.keyboardType = UIKeyboardType.numberPad
            
            sizeTextField.keyboardType = UIKeyboardType.numberPad
            
            productionTextField.keyboardType = UIKeyboardType.numberPad
            
            sizeLabel.text = "Test hours"
            
            productionLabel.text = "Hours on"
            
            sizeLabel.isHidden = false
            
            productionLabel.isHidden = false
            
            sizeTextField.isHidden = false
            
            productionTextField.isHidden = false
            
            searchButton.isHidden = true
            
        } else {
            
            generalFeature = feature
            
        }
        
    }
    
    /*
     
     Function: prepare for segue
     --------------------------------
     If segue to FeatureTableViewController
     THEN sets filledRows and space_type
     
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "backToFeatures" {
            
            let featureTableViewController = segue.destination as! FeatureTableViewController
            
            featureTableViewController.filledRows = filledRows
            
            featureTableViewController.space_type = space_type
            
        } else if segue.identifier == "toExtra" {
            
            let extraInfoViewController = segue.destination as! ExtraInfoViewController
            
            extraInfoViewController.filledRows = filledRows
            
            extraInfoViewController.feature = feature
            
            extraInfoViewController.generalFeature = generalFeature
            
            extraInfoViewController.foundFeature = foundFeature
            
            extraInfoViewController.space_type = space_type
            
        }
        
    }
    
}
