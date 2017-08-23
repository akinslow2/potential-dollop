//
//  ViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/21/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit

var output = Dictionary<String, String>()

class ViewController: UIViewController {
    
    var audit = Audit()
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func preauditButtonPressed(_ sender: Any) {
        
        output["filename"] = textField.text!
        
        performSegue(withIdentifier: "toPreaudit", sender: nil)
        
    }

    @IBAction func auditButtonPressed(_ sender: Any) {
        
        audit.retrieve_data()
        
        performSegue(withIdentifier: "toAudit", sender: nil)
        
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

