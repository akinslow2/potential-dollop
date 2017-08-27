//
//  AuditDetailViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/26/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit

class AuditDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var nameField: UITextField!
    var items = ["Lighting zone", "HVAC zone", "Room"]
    var selectedValue = "Lighting zone"
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
       
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        let name = nameField.text!
        
        if name == "" && identifier == "toFeatures" {
            
            let alert_controller = UIAlertController(title: "Empty name", message: "Please provide the identifying name", preferredStyle: UIAlertControllerStyle.alert)
            
            alert_controller.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                
                self.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert_controller, animated: true, completion: nil)
            
            return false
            
        }
        
        return true
    
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toFeatures" {
            
//            let auditTableViewController = segue.destination as! AuditTableViewController
//            
//            auditTableViewController.items.append(nameField.text! + " " + selectedValue)
            
            let featureTableViewController = segue.destination as! FeatureTableViewController
            
            if selectedValue == "Lighting zone" {
            
                featureTableViewController.curr_features = featureTableViewController.lighting_features
            
            } else if selectedValue == "HVAC zone" {
                
                featureTableViewController.curr_features = featureTableViewController.hvac_features
                
            } else {
                
                featureTableViewController.curr_features = featureTableViewController.room_features
                
            }
        
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return items.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return items[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedValue = items[row]
                
    }
    

}
