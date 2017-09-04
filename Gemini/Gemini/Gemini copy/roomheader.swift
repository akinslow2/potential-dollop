//
//  roomheader.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/22/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import Foundation

class Room {
    
    var lighting = Array<Dictionary<String, String>>()
    var hvac = Array<Dictionary<String, String>>()
    var plug_load = Array<Dictionary<String, String>>()
    var kitchen_equipment = Array<Dictionary<String, String>>()
    var room_name = ""

    init(room_name_passed: String) { room_name = room_name_passed }


    //Parameters here have to be supplied by the user or the Swift code
    //Note: the parameter "values" is a dictionary
    //The required keys vary, depending on the object.
    //Lighting (if not lighting_finished): "model_number", "number_of_lamps":(INT), "length", "max_width", "test_hours":(INT), "hours_on":(INT), "control_type"
    //Lighting (if lighting_finished): (above keys), "measured_lux", "space_type(->category: A, B, C, etc.)", "room_type", "room_area":(FLOAT), "units_in_lumens":(Boolean)
    //HVAC:
    //Kitchen:
    //Plug:

    func new_feature(feature_type:String, values:Dictionary<String, String>) {
        if feature_type == "Lighting" {
            
            __add_light_feature(values: values)
            
        } else if feature_type == "HVAC" {
            
            __add_hvac_feature(values: values)
            
        } else if feature_type == "Kitchen Equipment" {
            
            __add_kitchen_feature(values: values)
            
        } else if feature_type == "Plug Load" {
            
            -__add_plug_feature(values: values)
            
        }
        
    }


    func __add_light_feature(values:Dictionary<String, String>) {
        let watts = fluorescent_lighting_watts(values["model_number"])
        let energy = total_energy_calculation_per_light(int(values["model_number"]), int(values["test_hours"]), int(values["hours_on"]), watts)

        //It looks like they want a lot of other features here (color temp, lamp type, lumens, etc.)
        var new_dict = Dictionary<String, String>()
        new_dict["watts"] = String(watts)
        new_dict["energy"] = String(energy)
        lighting.append(new_dict)
    }

    func __compute_lighting_specs(values:Dictionary<String, String>) {
        let under_over_lighted = over_under_lamped(values["measured_lux"], space_type_conversion(values["space_type"]), values["units_in_lumens"])

        var total_watts = 0
        for light in lighting {
            total_watts += Int(light["watts"]!)!
        }

        let watts_usage_per_sqft = light_per_area(total_watts, values["room-type"], Float(values["room_area"]))
        
        var new_dict = Dictionary<String, String>()
        new_dict["watts_usage_per_sqft"] = String(watts_usage_per_sqft)
        new_dict["under_over_lighted"] = String(under_over_lighted)

        lighting.append(new_dict)
    }

    func __add_hvac_feature(values:Dictionary<String, String>) {
        
    }

    func __add_kitchen_feature(values:Dictionary<String, String>) {
        
    }

    func __add_plug_feature(values:Dictionary<String, String>) {
        
    }


    //This writes the features of a room back to the outputs dictionary
    func save_room() {

        //save overall lighting inputs
        __save_type(curr_array: lighting, name: "lighting")
        __save_type(curr_array: hvac, name: "hvac")
        __save_type(curr_array: plug_load, name: "plugload")
        __save_type(curr_array: kitchen_equipment, name: "kitchen")

    }
    
    func __save_type(curr_array:Array<Dictionary<String, String>>, name:String) {
        var item_number = 0
        for item in curr_array {
            let unique_key = room_name + "/" + name + "/" + String(item_number)
            outputs[unique_key] = item
            item_number += 1
        }
    }

}



