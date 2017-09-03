//
//  TableViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/22/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var output = Dictionary<String, String>()
    var preaudit_inputs = Dictionary<String, String>()
    var activeDetail = ""
    var filledRows = Array<Int>()
    
    let preaudit_entries = ["Business Name", "Business Address", "Client Interviewed Name", "Client Interviewed Position", "Main Client Name", "Main Client Position", "Main Client Email", "Main Client Phone Number", "Number of Days Operating", "Number of Hours Open Daily", "Total Square Footage", "Facility Type", "Age Of Building", "Age Of Lighting", "Age Of Lighting Controls", "Age Of HVAC", "Age Of HVAC Controls", "Age Of Kitchen Equipment", "Lighting Maintenance Interval", "HVAC Maintenance Interval", "Kitchen Equipment Maintenance Interval", "Upgrades Budget", "Expected ROI", "Utility Company", "Rate Structure Electric", "Rate Structure Gas", "Date Of Interview", "Auditors Names", "Notes"]
    
    
    /*
     
     Function: viewDidLoad
     -------------------------
     Loads view and calls define_preaudit_inputs()
     
     
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
     
     Function: numberOfSections
     ----------------------------
     Returns the number of columns in the table
     
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    /*
     
     Function: numberOfRowsInSection
     --------------------------------
     Returns the size of the number of inputs, 
     according to the array, preaudit_entries
     
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return preaudit_entries.count
        
    }

    /*
     
     Function: cellForRowAt
     ----------------------------
     Sets text to indexed element of the array
     preaudit_entries per row and adds a checkmark
     if the input was valid.
     
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = "\(preaudit_entries[indexPath.row])"
        
        if filledRows.count > 0 {
            
            if filledRows.contains(indexPath.row) {
            
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
                
            }
            
        }

        return cell
    }
    
    /*
     
     Function: didSelectRowAt
     ----------------------------
     Sets activeDetail to the selected row
     
     SEGUE~ to Preaudit Detail View Controller
     
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        activeDetail = preaudit_entries[indexPath.row]
        
        performSegue(withIdentifier: "toPreauditDetail", sender: nil)
        
    }
    
    /*
     
     Function: save
     ----------------
     Writes all preaudit inputs to audit.outputs, 
     saves audit.outputs to memory
     
     SEGUE~ to initial view controller
     
     */
    @IBAction func save(_ sender: Any) {
                
        for entry in preaudit_inputs.keys {
                
            audit.outputs[entry] = preaudit_inputs[entry]
            
        }
        
        audit.save_data()
        
        performSegue(withIdentifier: "toBeginning", sender: nil)
        
    }
    
    /*
     
     Function: prepare for segue
     ----------------------------
     Sets activeDetail for PreauditDetail
     as well as indexPath
     
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPreauditDetail" {
            
            let detailViewController = segue.destination as! PreauditDetailViewController
            
            detailViewController.activeDetail = activeDetail
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                detailViewController.selectedIndexPath = indexPath
                
            }
            
            detailViewController.filledRows = filledRows
            
            detailViewController.entries = preaudit_inputs
                        
        }
        
    }

}
