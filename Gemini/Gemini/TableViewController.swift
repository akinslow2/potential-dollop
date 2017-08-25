//
//  TableViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/22/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit

var filledRows = Array<Int>()

class TableViewController: UITableViewController {
    
    var output = Dictionary<String, String>()
    var preaudit_inputs = Array<Dictionary<String, String>>()
    let preaudit_entries = ["Business Name", "Business Address", "Client Interviewed Name", "Client Interviewed Position", "Main Client Name", "Main Client Position", "Main Client Email", "Main Client Phone Number", "Total Square Footage", "Facility Type", "Age Of Building", "Age Of Lighting", "Age Of Lighting Controls", "Age Of HVAC", "Age Of HVAC Controls", "Age Of Kitchen Equipment", "Lighting Maintenance Interval", "HVAC Maintenance Interval", "Kitchen Equipment Maintenance Interval", "Upgrades Budget", "Expected ROI", "Utility Company", "Rate Structure Electric", "Rate Structure Gas", "Date Of Interview", "Auditors Names", "Notes"]
    var activeDetail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        define_preaudit_inputs()
        
    }
    
    func define_preaudit_inputs() {
        
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


    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return preaudit_inputs.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = "\(Array(preaudit_inputs[indexPath.row].keys)[0])"
        
        if filledRows.contains(indexPath.row) {
            
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        activeDetail = preaudit_entries[indexPath.row]
        
        performSegue(withIdentifier: "toPreauditDetail", sender: nil)
        
    }
            
    @IBAction func save(_ sender: Any) {
        
        for dict in preaudit_inputs {
            
            if dict.count > 0 {
                
                audit.outputs[(dict.first?.key)!] = dict[(dict.first?.key)!]
            
            }
            
        }
        
        audit.save_data()
        
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPreauditDetail" {
            
            let detailViewController = segue.destination as! PreauditDetailViewController
            
            detailViewController.activeDetail = activeDetail
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                detailViewController.selectedIndexPath = indexPath
                
            }
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(filledRows)
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
