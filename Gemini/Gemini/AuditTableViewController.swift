//
//  AuditTableViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/26/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit

class AuditTableViewController: UITableViewController {
    
    var items = ["Select type of zone"]
    let feature_types = ["Lighting", "Heating", "Ventilation", "Air Conditioning", "Convection Oven", "TV"] //Add more values here!
    var selectedValue = ""
    @IBOutlet var table: UITableView!
    let lighting_items = ["Measured Lux", "Room Type", "Room Area", "Units in Lumens?"]
    //let hvac_items = []
    //let room_items = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print(selectedValue)
        
        if selectedValue == "Lighting zone" {
                        
            items = lighting_items
            
        } else if selectedValue == "HVAC zone" {
            
            //items = hvac_items
            
        } else {
            
            //items = room_items
            
        }
        
        table.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = items[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toAuditDetail", sender: self)
        
    }
    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if items.count > 1 {
            
            if segue.identifier == "toAuditDetail" {
                
                let auditDetailViewController = segue.destination as! AuditDetailViewController
                
                auditDetailViewController.items = feature_types
                
            }
            
        }
        
    }
}
