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
    
    init() {}
    
    func set_name(audit_name_param: String) {
        
        audit_name = audit_name_param
        
        filename = "data/" + audit_name + ".txt"
    }
    
    func retrieve_data() {
        
        do {
            
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                let path = dir.appendingPathComponent(filename)
                
                let output_file_string = try String(contentsOf: path, encoding: String.Encoding.utf8)
                
                let array = output_file_string.components(separatedBy: ", ")
                
                var iterator = 0
                var new_dict = Dictionary<String, String>()
                
                for entry in array {
                    
                    var key_index_start = entry.index(entry.startIndex, offsetBy: 1)
                    
                    if iterator == 0 {
                        
                        key_index_start = entry.index(entry.startIndex, offsetBy: 2)
                        
                    }
                    
                    let key1 = entry.substring(from: key_index_start)
                    
                    let key_index_end = key1.characters.index(of: "\"")!
                    
                    let key2 = key1.substring(to: key_index_end)
                    
                    let value_index = entry.characters.index(of: ":")!
                    
                    let value_index_start = entry.index(value_index, offsetBy: 3)
                    
                    let value1 = entry.substring(from: value_index_start)
                    
                    let value_index_end = value1.characters.index(of: "\"")!
                    
                    let value2 = value1.substring(to: value_index_end)
                    
                    iterator += 1
                    
                    new_dict[key2] = value2
                }
                
                outputs = new_dict
                
            }
            
            
        } catch { print("There was an error in retrieving") }
        
        
    }
    
    func save_data() {
        
        do {
            
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                let path = dir.appendingPathComponent(filename)
                
                try outputs.description.write(to: path, atomically: false, encoding: String.Encoding.utf8)
                
            }
        
        } catch { print("There was an error in saving")}
        
    }

}