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
    
    @IBAction func addFeature(_ sender: Any) {
        
        if curr_features == room_features {
            
            performSegue(withIdentifier: "selectFeature", sender: self)
            
        } else {
            
            performSegue(withIdentifier: "toFeatureSpecs", sender: self)
            
        }
        
    }
    let hvac_features = ["Room type", "Area"] //there will be more
    let lighting_features = ["Room type", "Area", "Units"] //there will be more
    let room_features = ["Room type", "Area", "Lighting Units", "Number of Outlets"] //These are purely for example
    var curr_features = Array<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return curr_features.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "FeaturesCell")

        cell.textLabel?.text = curr_features[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toZoneSpecs", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toZoneSpecs" {
        
            //let
        
        }
 
    }
}
