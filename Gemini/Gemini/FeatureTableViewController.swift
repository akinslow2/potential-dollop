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
    let hvac_features = ["Room type", "Area"] //there will be more
    let lighting_features = ["Room type", "Area", "Units"] // "
    let room_features = ["Room type", "Area", "Lighting Units", "Number of Outlets"] // "
    var curr_features = Array<String>()
    
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
        
        if curr_features == room_features {
            
            performSegue(withIdentifier: "selectFeature", sender: self)
            
        } else {
            
            performSegue(withIdentifier: "toFeatureSpecs", sender: self)
            
        }
        
    }


    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

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
     according to the array, curr_features
     
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return curr_features.count
        
    }

    /*
     
     Function: cellForRowAt
     ----------------------------
     Sets text to indexed element of the array curr_features per row
     
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "FeaturesCell")

        cell.textLabel?.text = curr_features[indexPath.row]

        return cell
    }
    
    /*
     
     Function: didSelectRow
     -------------------------------------
     SEGUE~ to Zone Specs View Controller
     
     */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toZoneSpecs", sender: self)
        
    }
    
    /*
     
     Function: prepare for segue
     ------------------------------------
     Modifies Zone Specs View Controller
     
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toZoneSpecs" {
        
            //let
        
        }
 
    }
}
