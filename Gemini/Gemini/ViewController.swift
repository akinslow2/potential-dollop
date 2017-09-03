//
//  ViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/21/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit
import Parse

var audit = Audit(audit_name_param: "NULL")
var auditObject = PFObject(className: "Audits")

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
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
            
            audit.set_name(audit_name_param: textField.text!)
        
            audit.outputs["filename"] = textField.text!
            
            
            
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
                
                alert_controller.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert_controller, animated: true, completion: nil)
            
        } else {
            
            audit.set_name(audit_name_param: textField.text!)
            
            audit.outputs["filename"] = textField.text!
            
            print(audit.outputs.count)
            
            if audit.outputs.count == 0 {
                
                let alert_controller = UIAlertController(title: "Audit not found", message: "Please provide the audit identifier used in the pre-audit", preferredStyle: UIAlertControllerStyle.alert)
                
                alert_controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }))
                
                self.present(alert_controller, animated: true, completion: nil)
                
            } else {
            
                performSegue(withIdentifier: "toAudit", sender: nil)
              }
            
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
    
    
    /*
     
     Function: viewDidLoad
     -------------------------
     Loads view and hides back button
     
     
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

}

