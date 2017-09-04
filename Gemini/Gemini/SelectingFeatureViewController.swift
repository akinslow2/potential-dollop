//
//  SelectingFeatureViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/26/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit

class SelectingFeatureViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    var selectedFeature = ""
    var filledRows = Array<Int>()
    var space_type = ""
    
    /*
     
     Function: addFeature
     ------------------------------------
     
     Checks to see that selectedFeature is not empty and then
     
     SEGUE~ to AuditInfoViewController
     
     */
    @IBAction func addFeature(_ sender: Any) {
        
        if selectedFeature == "" {
            
            let alert_controller = UIAlertController(title: "No feature selected", message: "Please provide a feature", preferredStyle: UIAlertControllerStyle.alert)
            
            alert_controller.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                
                alert_controller.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert_controller, animated: true, completion: nil)
            
        } else {
            
            performSegue(withIdentifier: "toSpecs", sender: self)
            
        }
        
    }

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
        
        return feature_references.count
        
    }
    
    /*
     
     Function: constructor, titleForRow
     ---------------------------------------
     Indexes through the corresponding Array
     and sets the titles sequentially
     
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return Array(feature_references.keys)[row]
        
    }
    
    /*
     
     Function: didSelectRow
     -------------------------------------
     Saves the value of the component selected in selectedFeature
 
    */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedFeature = Array(feature_references.keys)[row]
        
    }

    /*
     
     Function: prepare for segue
     ------------------------------------
     Sets filledRows, space_type, and selectedFeature
     IF going to AuditInfoViewController
     
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSpecs" {
            
            let auditInfoViewController = segue.destination as! AuditInfoViewController
            
            auditInfoViewController.feature = selectedFeature
            
            auditInfoViewController.filledRows = filledRows
            
            auditInfoViewController.space_type = space_type
                        
        }
        
    }

}
