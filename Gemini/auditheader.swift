//
//  auditheader.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/22/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//  A class that represents an individual audit process

import Foundation
import UIKit

class Audit {
    
    var outputs = Dictionary<String, String>()
    var audit_name = ""
    var filename = ""
    
    
    //Constructor: this should load the outputs if they exist or create a saved place for them if they don't
    init (audit_name_param: String) {
        
        //Initialization
        audit_name = audit_name_param
        filename = audit_name + ".json"
    }
    
    func retrieve_data() {
        
        do {
            
            let path = Bundle.main.path(forResource: filename, ofType: "json")
            
            print(path!)
            
            let output_file_string = try String(contentsOfFile: path!)
            
            var data: Data = output_file_string.data(using: String.Encoding.utf8)!
            var error: NSError?
            
            let anyObj: AnyObject? = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
            
            print("Error: \(String(describing: error))")
            
            outputs = self.parse_json(anyObject: anyObj!)
            
        } catch { print("There was an error") }
        
    }
    
    //We have to write the json to a string and then save it.
    func save_data() {
        
        
        
    }
    
    
    //Basically we have to loop through the values and set them to the keys and values of a new dictionary
    func parse_json(anyObject:AnyObject) -> Dictionary<String, String>{
        
        var dict: Dictionary<String, String> = {}
        
        if anyObject is Dictionary<AnyObject, AnyObject> {
            
            var key:String = String()
            var value:String = String()
            
            for json in anyObject as Dictionary<AnyObject, AnyObject> {
                
                
                
            }
            
        }
        
        return dict
    }
}

