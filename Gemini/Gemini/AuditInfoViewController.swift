//
//  AuditInfoViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/26/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit

class AuditInfoViewController: UIViewController {

    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var modelNumberTextField: UITextField!
    @IBOutlet weak var productionLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var productionTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    var feature = ""
    
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
    
    func is_energy_star(model_number: String, company: String, file_name: String) -> Bool {
        let rows = open_csv(filename: file_name)
        
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
        
        productionLabel.isHidden = true
        
        sizeLabel.isHidden = true
        
        productionTextField.isHidden = true
        
        sizeTextField.isHidden = true
        
        doneButton.isHidden = true

    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    
    }
    
    @IBAction func searchForModel(_ sender: Any) {
        
        //suspend control
        
        let found = is_energy_star(model_number: modelNumberTextField.text!, company: companyTextField.text!, file_name: feature_references[feature]!)
        
        if found {
            
            //add type here to room class
            //calculate retrofit
            
            performSegue(withIdentifier: "backToFeatures", sender: self)
            
        } else {
            
            productionLabel.isHidden = false
            
            sizeLabel.isHidden = false
            
            productionTextField.isHidden = false
            
            sizeTextField.isHidden = false
            
            doneButton.isHidden = false
            
            //add to room
            
            //calculate retrofit
        }
        
    }
    
    @IBAction func donePressed(_ sender: Any) {
        
        if productionTextField.text?.isEmpty || sizeTextField.text?.isEmpty {
            
            let alert_controller = UIAlertController(title: "Empty value(s)", message: "Please provide values", preferredStyle: UIAlertControllerStyle.alert)
            
            alert_controller.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                
                self.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert_controller, animated: true, completion: nil)
            
        } else {
            
            //add to room
            
            //calculate retrofit
            
            performSegue(withIdentifier: "backToFeatures", sender: self)
            
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
