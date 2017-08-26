//
//  ViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/21/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit

var audit = Audit()

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func preauditButtonPressed(_ sender: Any) {
        
        if (textField.text?.isEmpty)! {
            
            let alert_controller = UIAlertController(title: "Empty name", message: "Please provide the identifying name", preferredStyle: UIAlertControllerStyle.alert)
            
            alert_controller.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                
                self.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert_controller, animated: true, completion: nil)
            
        } else {
        
            audit.outputs["filename"] = textField.text!
            
            audit.set_name(audit_name_param: textField.text!)
            
            //Reload old inputs if they exist
        
            performSegue(withIdentifier: "toPreaudit", sender: nil)
            
        }
        
    }
    
    @IBAction func auditButtonPressed(_ sender: Any) {
        
        if (textField.text?.isEmpty)! {
            
            let alert_controller = UIAlertController(title: "Empty name", message: "Please provide the identifying name", preferredStyle: UIAlertControllerStyle.alert)
            
            alert_controller.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                
                self.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert_controller, animated: true, completion: nil)
            
        } else {
            
            audit.set_name(audit_name_param: textField.text!)
        
            audit.retrieve_data()
            
            //Uncomment this when saving actually works
            
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
            //}
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

