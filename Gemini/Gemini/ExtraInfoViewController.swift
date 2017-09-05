//
//  ExtraInfoViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 9/3/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit

class ExtraInfoViewController: UIViewController {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField2: UITextField!
    
    var feature = ""
    var generalFeature = ""
    var foundFeature: Bool?
    var filledRows = Array<Int>()
    var space_type = ""
    
    /*
     
     Function: open_csv_rows
     --------------------
     Returns an Optional(Array<Dictionary<String, String>>)
     of the elements in a csv with the first column as
     the keys in the array, and the subsequent columns
     are the values, corresponding to their shared row.
     
     For example:
     Category, Space Type
     A, Classroom
     B, Armory
     ->
     [["Category", "Space Type"], ["A", "Classroom"], ["B", "Armory"]]
     
     ***
     
     In order to input a file:
     
     1. Download as a .txt with \t separated values
     2. Open in Word and save as a .txt with UTF-8 encoding
     and LF only
     3. In Xcode, File -> Add Files to ... -> *Select file and add to "CSVs" folder*
     
     ***
     
     @param file's name in folder, String
     
     Example: (for CSVs/space_type.csv), filename = "space_type"
     
     */
    func open_csv_rows(filename: String) -> [[String]]! {
        
        let full_filename = "CSVs/" + filename
        
        var output_file_string = ""
        
        do {
            
            guard let path = Bundle.main.path(forResource: full_filename, ofType: "txt")
                
                else { return nil }
            
            output_file_string = try String(contentsOfFile: path).replacingOccurrences(of: "\t", with: ",")
            
        } catch {
            
            print("There was an error")
            
            return nil
            
        }
        
        let csv = CSwiftV(with: output_file_string)
        
        return csv.rows
        
    }
    
    // feature = value(index), value(index)...
    
//    convection= size2, capacity3, fuel type4
//    ice maker = energy use rate5, ice harvest4, ice type3, machine type1
//    freezer/fridge = total volume, product type, volume,
//    hot food cabinets = size, idle energy rate, cabinet volume
//    fryer = shortening capacity, production capacity, vat width, fuel type
//    steam cookers = water use, production capacity, fuel type, pan capacity, steamer type
//    griddle = fuel type, nominal width, surface area, single or double sided
    
    
    /*
     
     Function: donePressed
     --------------------------------
     Adds values to a dictionary, augments those
     values to the room class, and 
     
     SEGUE~ to Feature Table View Controller
     
     BUGGY
     
     */
    @IBAction func donePressed(_ sender: Any) {
        
        var dict = Dictionary<String, String>()
        
        if feature == "Convection Oven" {
            
            dict["size"] = textField1.text
            dict["capacity"] = textField2.text
            dict["fuel type"] = textField3.text
            
        } else if feature == "Ice Maker" {
            
            dict["machine type"] = textField1.text
            dict["ice type"] = textField2.text
            dict["ice harvest"] = textField3.text
            dict["energy use rate"] = textField4.text
            
        } else if feature.contains("fridge") || feature.contains("reezer") {
            
            //load appropriate entries
            
        } else if feature == "Hot Food Cabinet" {
            
            //load appropriate entries
            
        } else if feature == "Fryer" {
            
            //load appropriate entries
            
        } else if feature == "Steam Cooker" {
            
            //load appropriate entries
            
        } else if feature == "Griddle" {
            
            //load appropriate entries
            
        }
        
        room?.augment(values: dict)
        
        performSegue(withIdentifier: "fromExtra", sender: self)
        
    }
    
    /*
     
     Function: viewDidLoad
     --------------------------------
     Loads view and hides all fields so they
     can be unhidden as needed.
     
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label1.isHidden = true
        textField1.isHidden = true
        
        label2.isHidden = true
        textField2.isHidden = true
        
        label3.isHidden = true
        textField3.isHidden = true
        
        label4.isHidden = true
        textField4.isHidden = true
        
        // Do any additional setup after loading the view.
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
     --------------------------------
     This sets the values for the text fields depending
     on what appliance is being entered (they all have different
     requirements, which is what makes this so gross).
     
     BUGGY/Incomplete
     
     */
    override func viewDidAppear(_ animated: Bool) {
        
        var a = Array<String>()
        var b = Array<String>()
        var c = Array<String>()
        var d = Array<String>()
        
        var aIndex = -1
        var bIndex = -1
        var cIndex = -1
        var dIndex = -1
        
        //set index of desired value and text in labels
        
        if feature == "Convection Oven" {
            
            aIndex = 2
            bIndex = 3
            cIndex = 4
            label1.text = "Size"
            label2.text = "Capacity"
            label3.text = "Fuel Type"
            
            label1.isHidden = false
            label2.isHidden = false
            label3.isHidden = false
            
            textField1.isHidden = false
            textField2.isHidden = false
            textField3.isHidden = false
            
        } else if feature == "Ice Maker" {
            
            aIndex = 1
            bIndex = 3
            cIndex = 4
            dIndex = 5
            
            label1.text = "Machine Type"
            label2.text = "Ice Type"
            label3.text = "Ice Harvest"
            label4.text = "Energy use rate"
            
            label1.isHidden = false
            label2.isHidden = false
            label3.isHidden = false
            label4.isHidden = false
            
            textField1.isHidden = false
            textField2.isHidden = false
            textField3.isHidden = false
            textField4.isHidden = false
            
        } else if feature.contains("fridge") || feature.contains("reezer") {
            
            //load appropriate entries
            
        } else if feature == "Hot Food Cabinet" {
            
            //load appropriate entries
            
        } else if feature == "Fryer" {
            
            //load appropriate entries
            
        } else if feature == "Steam Cooker" {
            
            //load appropriate entries
            
        } else if feature == "Griddle" {
            
            //load appropriate entries
            
        }
        
        //gather values into array
        
        if aIndex != -1 {
            
            let csv = open_csv_rows(filename: feature_references[feature]!)
            
            for row in csv! {
                
                if row[0] == "Company" {
                    
                    continue
                    
                }
                
                if !a.contains(row[aIndex]) {
                    
                    a.append(row[aIndex])
                    
                }
                
            }
        }
        
        if bIndex != -1 {
            
            let csv = open_csv_rows(filename: feature_references[feature]!)
            
            for row in csv! {
                
                if row[0] == "Company" {
                    
                    continue
                    
                }
                
                if !b.contains(row[aIndex]) {
                    
                    b.append(row[aIndex])
                    
                }
                
            }
        }
        
        if cIndex != -1 {
            
            let csv = open_csv_rows(filename: feature_references[feature]!)
            
            for row in csv! {
                
                if row[0] == "Company" {
                    
                    continue
                    
                }
                
                if !c.contains(row[aIndex]) {
                    
                    c.append(row[aIndex])
                    
                }
                
            }
        }
        
        if dIndex != -1 {
            
            let csv = open_csv_rows(filename: feature_references[feature]!)
            
            for row in csv! {
                
                if row[0] == "Company" {
                    
                    continue
                    
                }
                
                if !d.contains(row[aIndex]) {
                    
                    d.append(row[aIndex])
                    
                }
                
            }
            
        }
        
        //Set label text
        
        var text = label1.text
        
        if !label1.isHidden {
        label1.text = text! + ". Possible values: " + a.description.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        label1.font = label1.font.withSize(10)
        }
        
        if !label2.isHidden {
        text = label2.text
        label2.text = text! + ". Possible values: " + b.description.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        label2.font = label2.font.withSize(10)
        }
        if !label3.isHidden {
        text = label3.text
        label3.text = text! + ". Possible values: " + c.description.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        label3.font = label3.font.withSize(10)
        }
        if !label4.isHidden {
        text = label4.text
        label4.text = text! + ". Possible values: " + d.description.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        label4.font = label4.font.withSize(10)
        }
        
    }
    
    
    /*
     
     Function: prepare
     --------------------------------
     This resets the values of each variable when naviagting
     away from this view controller
     
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromExtra" {
            
            let auditInfoViewController = segue.destination as! AuditInfoViewController
            
            auditInfoViewController.filledRows = filledRows
            
            auditInfoViewController.generalFeature = generalFeature
            
            auditInfoViewController.foundFeature = foundFeature
            
            auditInfoViewController.space_type = space_type
            
            auditInfoViewController.feature = feature
        }
        
    }
    
    
}
