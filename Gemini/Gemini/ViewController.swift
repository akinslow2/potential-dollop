//
//  ViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/21/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit

protocol ViewControllerDelegate {
    
    func save_dict_to_audit(key: String, value: String)
    
    func save_dictionary()
    
}

class ViewController: UIViewController, UITextFieldDelegate, ViewControllerDelegate {
    
    @IBOutlet weak var textField: UITextField!
    var audit: Audit?
    
    
    /*
    
     Delegate protocols
    
    */
    func save_dict_to_audit(key: String, value: String) {
        
        audit?.outputs[key] = value
        
    }
    
    func save_dictionary() {
        
        audit?.save_data()
        
    }
    
    /*
     
     Function: preauditButtonPressed
     -----------------------------
     When "preaudit" pressed, checks to ensure
     name is not empty, loads old inputs for the
     preaudit if they exist
     
     SEGUE~ to Table View Controller
     
     */
    @IBAction func preauditButtonPressed(_ sender: Any) {
        
        if (textField.text?.isEmpty)! {
            
            let alert_controller = UIAlertController(title: "Empty name", message: "Please provide the identifying name", preferredStyle: UIAlertControllerStyle.alert)
            
            alert_controller.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                
                self.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert_controller, animated: true, completion: nil)
            
        } else {
            
            audit = Audit(audit_name_param: textField.text!)
        
            audit?.outputs["filename"] = textField.text!
            
            //Reload old inputs if they exist
        
            performSegue(withIdentifier: "toPreaudit", sender: nil)
            
        }
        
    }
    
    /*
     
     Function: auditButtonPressed
     -----------------------------
     When "audit" pressed, checks to ensure
     name is not empty and record exists of preaudit
     
     SEGUE~ to Audit Table View Controller
     
     */
    @IBAction func auditButtonPressed(_ sender: Any) {
        
        if (textField.text?.isEmpty)! {
            
            let alert_controller = UIAlertController(title: "Empty name", message: "Please provide the identifying name", preferredStyle: UIAlertControllerStyle.alert)
            
            alert_controller.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                
                self.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert_controller, animated: true, completion: nil)
            
        } else {
            
            audit = Audit(audit_name_param: textField.text!)
            
            audit?.retrieve_data()
            
            /* Uncomment this when saving actually works */
            
//            if audit.outputs.count == 0 {
//                
//                let alert_controller = UIAlertController(title: "Audit not found", message: "Please provide the audit identifier used in the pre-audit", preferredStyle: UIAlertControllerStyle.alert)
//                
//                alert_controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                    
//                    self.dismiss(animated: true, completion: nil)
//                    
//                }))
//                
//                self.present(alert_controller, animated: true, completion: nil)
//                
//            } else {
            
                performSegue(withIdentifier: "toAudit", sender: nil)
//            }
            
        }
        
    }
    
    /*
     
     Function: touchesBegan
     -------------------------
     Returns normal control to the view after
     a touch outside of the displayed keyboard
     
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    
    /*
     
     Function: textFieldShouldReturn
     --------------------------------
     Returns normal control to the view a user
     presses "return" on the keyboard
     
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
        if segue.identifier == "toPreaudit" {
            
            let destinationNavController = segue.destination as! UINavigationController
            
            let tableViewController = destinationNavController.topViewController as! TableViewController
            
            tableViewController.delegate = self
                        
        }
        
    }
    
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

}

