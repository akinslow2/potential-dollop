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
    
    @IBAction func addFeature(_ sender: Any) {
        
        if selectedFeature == "" {
            
            let alert_controller = UIAlertController(title: "No feature selected", message: "Please provide a feature", preferredStyle: UIAlertControllerStyle.alert)
            
            alert_controller.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                
                self.dismiss(animated: true, completion: nil)
                
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
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return feature_references.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return Array(feature_references.keys)[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedFeature = Array(feature_references.keys)[row]
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSpecs" {
            
            let auditInfoViewController = segue.destination as! AuditInfoViewController
            
            auditInfoViewController.feature = selectedFeature
            
            print(selectedFeature)
            
        } else if segue.identifier == "toZoneSpecs" {
            
            let zoneSpecsViewController = segue.destination as! ZoneSpecsViewController
            
            zoneSpecsViewController.spec = selectedFeature
            
        }
        
    }

}
