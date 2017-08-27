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
                
                //set values for input
                
            }
            
        }
        
    }
}

//
//  AuditViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/23/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

//    import UIKit
//
//    class AuditViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//
//        var selectedValue = ""
//
//        @IBOutlet weak var imageView: UIImageView!
//        @IBOutlet weak var addImageButton: UIButton!
//        @IBOutlet weak var addRoomButton: UIButton!
//        @IBOutlet weak var cancelButton: UIButton!
//
//
//        /*
//
//         Image Import Start
//
//         */
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//
//            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//
//                imageView.image = image
//
//                addImageButton.isHidden = true
//
//            } else {
//
//                print("Something went wrong")
//
//            }
//
//            self.dismiss(animated: true, completion: nil)
//
//        }
//
//        @IBAction func addImage(_ sender: Any) {
//
//            let imagePickerController = UIImagePickerController()
//
//            imagePickerController.delegate = self
//
//            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
//
//            imagePickerController.allowsEditing = true
//
//            self.present(imagePickerController, animated: false, completion: nil)
//
//        }
//
//        /*
//
//         Image Import End
//
//         */
//
//        /*
//
//         Path Start
//
//         */
//
//        let path = UIBezierPath()
//        var lastPoint = CGPoint()
//
//
//
//        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//            if let touch = touches.first {
//                lastPoint = (touch.location(in: self.imageView))
//                path.move(to: lastPoint)
//            }
//
//        }
//
//        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//            if let touch = touches.first {
//                lastPoint = (touch.location(in: self.imageView))
//                path.addLine(to: lastPoint)
//            }
//        }
//
//        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//            if let touch = touches.first {
//
//                lastPoint = (touch.location(in: self.imageView))
//
//                path.close()
//
//                let layer = CAShapeLayer()
//
//                layer.path = path.cgPath
//
//                layer.strokeColor = UIColor.red.cgColor
//
//                layer.fillColor = UIColor.clear.cgColor
//
//                self.imageView.layer.addSublayer(layer)
//
//                addRoomButton.isHidden = false
//
//                cancelButton.isHidden = false
//            }
//        }
//
//        /*
//
//         Path End
//
//         */
//
//        override func viewDidAppear(_ animated: Bool) {
//
//            addRoomButton.isHidden = true
//
//            cancelButton.isHidden = true
//
//        }
//
//    }
//
//
//}
