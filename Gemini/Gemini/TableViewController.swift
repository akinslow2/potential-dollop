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
    var preaudit_inputs = Array<Dictionary<String, String>>()

    override func viewDidLoad() {
        super.viewDidLoad()
        define_preaudit_inputs()
        
    }
    
    func define_preaudit_inputs() {
        
        let preaudit_entries = ["business_name", "business_address", "client_interviewed_name", "client_interviewed_position", "main_client_name", "main_client_position", "main_client_email", "main_client_phone number", "total_square_footage", "facility_type", "age_of_building", "age_of_lighting", "age_of_lighting_controls", "age_of_hvac", "age_of_hvac_controls", "age_of_kitchen_equipment", "lighting_maintenance_interval", "hvac_maintenance_interval", "kitchen_equipment_maintenance_interval", "upgrades_budget", "expected_roi", "utility_company", "rate_structure_electric", "rate_structure_gas", "date_of_interview", "auditors_names", "evacuation_map_image", "notes"]
        
        var i = 0
        for entry in preaudit_entries {
            
            var new_entry = Dictionary<String, String>()
            new_entry[entry] = ""
            preaudit_inputs.append(new_entry)
            i += 1
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return preaudit_inputs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = "\(Array(preaudit_inputs[indexPath.row].keys)[0])" //This should be the name of the key

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toPreauditDetail", sender: nil)
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
