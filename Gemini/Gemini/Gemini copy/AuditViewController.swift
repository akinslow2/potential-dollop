//
//  AuditViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/23/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit

class AuditViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var selectedValue = ""
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var addRoomButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    /* 
    
    Image Import Start
 
    */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.image = image
            
            addImageButton.isHidden = true
            
        } else {
            
            print("Something went wrong")
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: false, completion: nil)
        
    }
    
    /*
     
     Image Import End
     
     */
    
    /*
 
    Path Start
 
    */
    
    let path = UIBezierPath()
    var lastPoint = CGPoint()
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            lastPoint = (touch.location(in: self.imageView))
            path.move(to: lastPoint)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            lastPoint = (touch.location(in: self.imageView))
            path.addLine(to: lastPoint)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            lastPoint = (touch.location(in: self.imageView))
            
            path.close()
            
            let layer = CAShapeLayer()
            
            layer.path = path.cgPath
            
            layer.strokeColor = UIColor.red.cgColor
            
            layer.fillColor = UIColor.clear.cgColor
            
            self.imageView.layer.addSublayer(layer)

            addRoomButton.isHidden = false
            
            cancelButton.isHidden = false
        }
    }
    
    /*
     
     Path End
     
     */

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addRoomButton.isHidden = true
        
        cancelButton.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        addRoomButton.isHidden = true
        
        cancelButton.isHidden = true
        
    }

}
