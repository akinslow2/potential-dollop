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
    let features = ["Lighting", "Rack Oven", "Combination Oven", "Convection Oven", "Conveyor Oven", "Ice Maker", "Freezer", "Glass Door Refrigerator", "Solid Door Refrigerator", "Hot Food Cabinet", "Fryer", "Steam Cooker", "Griddle", "TV", "A/C", "Motor", "Lamp", "Walk-in Refrigeration Fan"]
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
        
        return features.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return features[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedFeature = features[row]
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSpecs" {
            
            let auditInfoViewController = segue.destination as! AuditInfoViewController
            
            auditInfoViewController.feature = selectedFeature
            
        }
        
    }

}
