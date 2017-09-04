//
//  ZoneViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/26/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit

class ZoneViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var zonePicked: UIPickerView!
    
    var selectedRow = -1
    
    let zones = ["Lighting zone", "HVAC zone", "Room"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return zones.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return zones[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedRow = row
            
        performSegue(withIdentifier: "toAuditDetail", sender: self)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.zonePicked.dataSource = self
        self.zonePicked.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addZone" {
            
            let auditTableViewController = segue.destination as! AuditTableViewController
            
            auditTableViewController.selectedValue = zones[selectedRow]
            
        }
        
    }
 

}
