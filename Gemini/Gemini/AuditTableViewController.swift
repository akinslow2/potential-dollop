//
//  AuditTableViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/26/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit

class AuditTableViewController: UITableViewController, save_room {
    
    var items = Array<String>()
    var new_room_sent: String?
    @IBOutlet var table: UITableView!
    
    
    
    /*
     
     Function: viewDidLoad
     -------------------------
     Loads view
     
     */
    override func viewDidLoad() {
        super.viewDidLoad()
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
 
    Function: viewDidAppear
    -------------------------------------
    Gets called every time the view controller loads
 
    */
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
     according to the array, items
     
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        
    }

    /*
     
     Function: cellForRowAt
     ----------------------------
     Sets text to indexed element of the array items per row
     
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = items[indexPath.row]

        return cell
        
    }
    
    /*
 
    Function: add_room
    ------------------------------------
    Conforms to protocol save_room
    Adds room to table
 
    */
    func add_room(room_name: String) {
        
        items.append(room_name)
        
    }
    
}
