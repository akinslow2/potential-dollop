//
//  AuditInfoViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/26/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit

class AuditInfoViewController: UIViewController {

    @IBOutlet weak var modelNumberTextField: UITextField!
    @IBOutlet weak var productionLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var productionTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    var feature = ""
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        productionLabel.isHidden = true
        
        sizeLabel.isHidden = true
        
        productionTextField.isHidden = true
        
        sizeTextField.isHidden = true
        
        doneButton.isHidden = true

    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func searchForModel(_ sender: Any) {
        
        //if found, 
        //add to map/diction/room
        //calculate retrofit? (it found, it is ideal?)
        //performSegue
        //
        //else
        //unhide features
        //add to map
        //calculate retrofit
        //wait for other button (save) to segue
        
    }
    
    @IBAction func donePressed(_ sender: Any) {
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
