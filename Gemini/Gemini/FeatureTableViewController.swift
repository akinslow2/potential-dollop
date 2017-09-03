//
//  FeatureTableViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/26/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit

class FeatureTableViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    var curr_spec: String?
    var space_type: String?
    var filledRows = Array<Int>()
    var curr_row = -1
    
    @IBAction func saveRoom(_ sender: Any) {
        
        if filledRows.count < (room?.general_values_keys.count)! {
            
            let alert_controller = UIAlertController(title: "Incomplete Fields", message: "Please fill all required fields for this zone", preferredStyle: UIAlertControllerStyle.alert)
            
            alert_controller.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                
                alert_controller.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert_controller, animated: true, completion: nil)
            
        } else {
            
            //room.save_room()
            
            performSegue(withIdentifier: "saveRoom", sender: self)
            
        }
        
    }
    
    /*
     
     Function: addFeature
     -----------------------
     Dictates segues. 
     
     SEGUE~ to Selecting Feature View Controller
     IF zone is of type "room"
     
     SEGUE~ to Audit Info View Controller
     ELSE
     
     */
    @IBAction func addFeature(_ sender: Any) {
        
        print(space_type)
        
        if space_type == "Room" {
            
            performSegue(withIdentifier: "selectFeature", sender: self)
            
        } else {
            
            performSegue(withIdentifier: "toFeatureSpecs", sender: self)
            
        }
        
    }


    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        table.reloadData()
        
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
     according to the array, curr_features
     
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (room?.feature_table_keys.count)!
        
    }

    /*
     
     Function: cellForRowAt
     ----------------------------
     Sets text to indexed element of the array curr_features per row
     
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "FeaturesCell")

        cell.textLabel?.text = room?.feature_table_keys[indexPath.row]
        
        if filledRows.contains(indexPath.row) || indexPath.row >= (room?.general_values_keys.count)! {
            
            cell.accessoryType = .checkmark
            
        }

        return cell
    }
    
    /*
     
     Function: didSelectRow
     -------------------------------------
     SEGUE~ to Zone Specs View Controller
     
     */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //if zone spec, if indexPath.row < room?.general_values_keys.count
        
        if indexPath.row < (room?.general_values_keys.count)! {
        
            curr_spec = room?.general_values_keys[indexPath.row]
            
            curr_row = indexPath.row
            
            performSegue(withIdentifier: "toZoneSpecs", sender: self)
        }
        
    }
    
    /*
     
     Function: prepare for segue
     ------------------------------------
     Modifies Zone Specs View Controller
     
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toZoneSpecs" {
        
            let zoneSpecsViewController = segue.destination as! ZoneSpecsViewController
            
            zoneSpecsViewController.spec = curr_spec!
            
            zoneSpecsViewController.filledRows = filledRows
            
            zoneSpecsViewController.curr_row = curr_row
            
            zoneSpecsViewController.spaceType = space_type
            
        } else if segue.identifier == "toFeatureSpecs" {
            
            let auditInfoViewController = segue.destination as! AuditInfoViewController
            
            if space_type == "HVAC zone" {
            
                auditInfoViewController.feature = "HVAC"
                
            } else {
                
                auditInfoViewController.feature = "Lighting"
                
            }
            
            auditInfoViewController.filledRows = filledRows
            
            
        } else if segue.identifier == "selectFeature" {
            
            let selectingFeatureViewController = segue.destination as! SelectingFeatureViewController
            
            selectingFeatureViewController.filledRows = filledRows
            
            selectingFeatureViewController.space_type = space_type!
        
                        
        }
 
    }
}
