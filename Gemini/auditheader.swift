//
//  auditheader.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/22/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//  A class that represents an individual audit process

import Foundation
import CoreData
import UIKit

//import ast, os.path

class Audit {
    
    var outputs = Dictionary<String, Dictionary<String, String>>()
    var audit_name = ""
    
    
    //Constructor: this should load the outputs if they exist or create a saved place for them if they don't
    init (audit_name_param: String) {
        
        //Initialization
        audit_name = audit_name_param
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate //This and the one below allow saving to permanent storage
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Audits") //This is what we're looking for, generally
        
        request.predicate = NSPredicate(format: "saved_outputs = %@", audit_name)//This is what we're looking for, specifically
        
        request.returnsObjectsAsFaults = false
        
        var exists = false
        
        do {
            
            let result = try context.fetch(request)
            
            if result.count > 0 {
        
                exists = true
                
            }
            
        } catch { print("No results or other error") }
        
        if !exists {
        
            let new_audit = NSEntityDescription.insertNewObject(forEntityName: "Audits", into: context)
            
            new_audit.setValue(outputs.description, forKey: "outputs")
            
            new_audit.setValue(audit_name, forKey: "saved_outputs")
            
            do {
        
                try context.save()
                
                print("Saved")
                
            } catch { print("There was an error in saving new data") }
            
        } else {
            
            let new_request = NSFetchRequest<NSFetchRequestResult>(entityName: "Audits")
            
            new_request.returnsObjectsAsFaults = false
            
            do {
                
                let results = try context.fetch(new_request)
                
                for result in results as! [NSManagedObject] {
                    
                    if let output = result.value(forKey: "outputs") as? String {
                        
                        let NSOutput = NSString(string: output)
                        
                        if NSOutput.contains(audit_name) {
                            
                            
                            
                        }
                        
                    }
                    
                }
                
            } catch { print("There was an error in getting data that should exist") }
        }
        
    }

}
//        try:
//        abs_path = filename.resolve() # Tries to complete the path name
//
//        except FileNotFoundError:
//        abs_path = ""
//
//        if abs_path != "":
//        __load_saved_outputs()
//        else:
//        abs_path = "%s/%s" % (os.path.dirname(os.path.realpath(__file__)), filename)
//
//        return
//    }
//    
//    
//    def save():
//    with open(abs_path, "w") as file:
//    file.write(str(outputs))
//    
//    
//    def retrieve():
//    __load_saved_outputs()
//    
//    
//    def __load_saved_outputs(): # There is no such thing as private methods :/ so this my way of making it different/unlikely to be called
//    with open(abs_path, "r") as saved_file:
//    saved_outputs = saved_file.read()
//    outputs = ast.literal_evals(saved_outputs)
//    
//    def return_outputs():
//    return outputs
//}
