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
    
    var feature = ""
    var generalFeature = ""
    var foundFeature: Bool?
    var filledRows = Array<Int>()
    
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
    
    func is_energy_star(model_number: String, company: String, file_name: String) -> Bool {
        
        print(feature)
        
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        sizeTextField.delegate = self
        
        productionTextField.delegate = self
        
        companyTextField.delegate = self
        
        modelNumberTextField.delegate = self
        
        self.navigationItem.hidesBackButton = true

    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    
    }
    
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
                
                productionLabel.isHidden = false
                
                sizeLabel.isHidden = false
                
                productionTextField.isHidden = false
                
                sizeTextField.isHidden = false
                
                doneButton.isHidden = false
                
                searchButton.isHidden = true

            }
            
        }
        
    }
    
    func retrieveValues(feature: String) -> Dictionary<String, String> {
        
        var dict = Dictionary<String, String>()
        
        dict["model_number"] = modelNumberTextField.text
        
        if generalFeature == "Kitchen equipment" {
            
            dict["company"] = companyTextField.text
            
            if !foundFeature! {
                
                dict["size"] = sizeTextField.text
                
                dict["production_capacity"] = productionTextField.text
                
            }
            
        } else if generalFeature == "HVAC" {
            
            //nothing for now
            
        } else if generalFeature == "Lighting" {
            
            dict["number_of_lamps"] = companyTextField.text
            
            dict["test_hours"] = sizeTextField.text
            
            dict["hours_on"] = productionTextField.text
            
        } else {
            
            //plug load
            
        }
        
        return dict
        
    }
    
    @IBAction func donePressed(_ sender: Any) {
        
        if (productionTextField.text?.isEmpty)! || (sizeTextField.text?.isEmpty)! {
            
            let alert_controller = UIAlertController(title: "Empty value(s)", message: "Please provide values", preferredStyle: UIAlertControllerStyle.alert)
            
            alert_controller.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                
                alert_controller.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert_controller, animated: true, completion: nil)
            
        } else {
            
            if feature == "Lighting" {
                
                room?.feature_table_keys.append(feature + " " + modelNumberTextField.text!)
                
            }
            
            room?.new_feature(feature_type: feature, values: retrieveValues(feature: feature))
            
            //calculate retrofit
            
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
    
    override func viewDidAppear(_ animated: Bool) {
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "backToFeatures" {
            
            let featureTableViewController = segue.destination as! FeatureTableViewController
            
            featureTableViewController.filledRows = filledRows
                        
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
