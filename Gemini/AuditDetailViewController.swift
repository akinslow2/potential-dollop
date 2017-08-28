//
//  AuditDetailViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/26/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit

protocol save_room {
    
    func add_room(room_name:String)
    
}

class AuditDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var nameField: UITextField!
    var items = ["Lighting zone", "HVAC zone", "Room"]
    var selectedValue = "Lighting zone"
    var delegate: save_room?
    //var roomTable = AuditTableViewController()

    /*
     
     Function: viewDidLoad
     -------------------------
     Loads view, sets delegates
     and dataSource for picker
     
     
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        pickerView.dataSource = self
        
        pickerView.delegate = self
        
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
     
     Function: shouldPerformSegue
     ------------------------------
     Checks to see if the name field is empty
     before returning true that the segue should
     take place to input features
     
     */
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
    

    /*
     
     Function: prepare for segue
     ------------------------------
     Updates preview table for new Room
     
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toFeatures" {
            
            delegate?.add_room(room_name: nameField.text! + "-" + selectedValue)
            
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
        
        return items.count
        
    }
    
    /*
     
     Function: constructor, titleForRow
     ---------------------------------------
     Indexes through the corresponding Array
     and sets the titles sequentially
     
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return items[row]
        
    }
    
    /*
     
     Function: didSelectRow
     -------------------------------------
     Saves the value of the component selected in selectedValue
     
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedValue = items[row]
                
    }
    

}
