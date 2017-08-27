//
//  roomheader.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/22/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import Foundation

class Room: Audit {
    
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
            
            __add_plug_feature(values: values)
            
        }
        
    }


    private func __add_light_feature(values:Dictionary<String, String>) {
        
        let model_number = values["model_number"]!
        
        let num_lamps = Int(values["num_lamps"]!)
        
        let test_hours = Int(values["test_hours"]!)
        
        let hours_on = Int(values["hours_on"]!)
        
        let watts = fluorescent_lighting_watts(model_number: model_number)
        
        let energy = total_energy_calculation_per_light(num_lamps: num_lamps!, test_hours: test_hours!, hours_on: hours_on!, watts: Float(watts))
        
        //It looks like they want a lot of other features here (color temp, lamp type, lumens, etc.)
        
        var new_dict = Dictionary<String, String>()
        
        new_dict["watts"] = String(watts)
        
        new_dict["energy"] = String(energy)
        
        lighting.append(new_dict)
    }

    private func __compute_lighting_specs(values:Dictionary<String, String>) {
        
        let lux = Float(values["measured_lux"]!)
        
        let units_in_lumens = Bool(values["units_in_lumens"]!)
        
        let space_type = space_type_conversion(space_type: values["space_type"]!)
        
        let area = Float(values["room-type"]!)
        
        let room_type = values["room-type"]!
        
        
        
        let under_over_lighted = over_under_lamped(lux: lux!, category: space_type, units_in_lumens: units_in_lumens!)

        var total_watts = 0
        
        for light in lighting {
            
            total_watts += Int(light["watts"]!)!
            
        }

        let watts_usage_per_sqft = light_per_area(watts: total_watts, area: area!, room_type: room_type)
        
        var new_dict = Dictionary<String, String>()
        
        new_dict["watts_usage_per_sqft"] = String(watts_usage_per_sqft)
        
        new_dict["under_over_lighted"] = String(under_over_lighted)

        lighting.append(new_dict)
    }

    func __add_hvac_feature(values:Dictionary<String, String>) {
        
    }

    func __add_kitchen_feature(values:Dictionary<String, String>) {
        //need some way to break up which item this is for
        let model_number = values["model_number"]!
        
        let company = values["num_lamps"]!
        
        let type = values["type"]!
        
        if type == "rack_oven" {
            __compute__rack__oven(model_number: model_number, company: company)
        } else if type == "convection_oven" {
            __compute__convection__oven(model_number: model_number, company: company)
        } else if type == "combination_oven" {
            __compute__combination__oven(model_number: model_number, company: company)
        } else if type == "conveyor_ovens" {
            __compute__conveyor__oven(model_number: model_number, company: company)
        } else if type == "ice_maker" {
            __compute__icemaker(model_number: model_number, company: company)
        } else if type == "freezer" {
            
        } else if type == "refrigerator" {
            //need to check solid door or glass door
        } else if type == "hot_food_cabinets" {
            
        } else if type == "fryer" {
            
        } else if type == "steam_cookers" {
            
        } else if type == "griddles" {
            
        }
        
    }
    
    private func __compute__icemaker(model_number:String, company: String){
        var energy_star = is_energy_star(model_number: model_number, company: company, file_name: csv_file_for_icemaker)
        if energy_star {
            //done
        }
        
        //oven length, conveyor width
        
        let best_model_num = find_best_model(prod_capacity: prod_capacity, size: size, file_name: csv_file_for_icemaker)
    }
    
    private func __compute__conveyor__oven(model_number:String, company: String){
        var energy_star = is_energy_star(model_number: model_number, company: company, file_name: csv_file_for_conveyorovens)
        if energy_star {
            //done
        }
        
        //oven length, conveyor width
        //either make this specific to the type of ktichen appliance or just make the parameters generic like "required1, required2" and so on...
        let best_model_num = find_best_model(prod_capacity: prod_capacity, size: size, file_name: csv_file_for_conveyorovens)
    }
    
    
    private func __compute__convection__oven(model_number:String, company: String){
        var energy_star = is_energy_star(model_number: model_number, company: company, file_name: csv_file_for_convectionovens)
        if energy_star {
            //done
        }
        
        //size, capacity, fuel type
        
        let best_model_num = find_best_model(prod_capacity: prod_capacity, size: size, file_name: csv_file_for_convectionovens)
    }
    
    private func __compute__combination__oven(model_number:String, company: String){
        var energy_star = is_energy_star(model_number: model_number, company: company, file_name: csv_file_for_combinationovens)
        if energy_star {
            //done
        }
        
        //size, fuel type
        
        let best_model_num = find_best_model(prod_capacity: prod_capacity, size: size, file_name: csv_file_for_combinationovens)
    }
    
    
    //Need to make constants for the csvs needed for each type of material
    private func __compute__rack__oven(model_number:String, company: String){
        var energy_star = is_energy_star(model_number: model_number, company: company, file_name: csv_file_for_rackovens)
        
        if energy_star {
            //do not need to continue with this method, but should do something
        }
        
        //let prod_capacity
        //let size
        //maybe fuel type
        
        let best_model_num = find_best_model(prod_capacity: prod_capacity, size: size, file_name: csv_file_for_rackovens)
    }
    
    //For this part, the best model might not have the exact size and capacity, so we may have to have a way to get close
    //To generalize this method, it may not be prod_capactiy and size each time
    private func find_best_model(prod_capacity: String, size: String, file_name: String) -> String{
        let rows = open_csv(filename: file_name)
        
        var new_dict = Dictionary<String, Int>()
        
        
        
        for row in rows! {
            
            if row["size"] != size {
                continue
            }
            if row["prod_capacity"] != prod_capacity { //model_number must be revised. Not sure what it should be
                continue
            }
            
            new_dict[row["model_number"]] = find_energy_cost(preheat_energy: Int(row["preheat_energy"]), idle_energy_rate: Int(row["idle_energy_rate"]), fan_energy_rate: Int(row["fan_energy_rate"]) )
            return ""
            
        }
        
        //return the model number with the lowest cost
        return ""
    }
    
    
    //most of the info needs to come from the bill, but some will come from the energy star csv
    //possibly doubles
    private func find_energy_cost(preheat_energy: Int, idle_energy_rate: Int, fan_energy_rate: Int) -> Int{
        
        //still need: winter_rate, summer_rate, hours_on_peak_pricing, hours_on_partpeak_pricing, partpeak_price, hours_on_offpeak_pricing, offpeak_price
        //also: hours_on_partpeak_pricing(winter), hours_on_offpeak_pricing(winter)
        
        var gas_energy = preheat_energy * days_in_operation + (ideal_run_hours * idle_energy_rate)
        var gas_cost = gas_energy / 99976.1 * (winter_rate + summer_rate) / 2
        
        //not sure what this is for
        //var electric_energy = ideal_run_hours * fan_energy_rate
        
        //Electric Cost:
        
        var summer = hours_on_peak_pricing * fan_energy_rate * peak_price + hours_on_partpeak_pricing * fan_energy_rate * partpeak_price + hours_on_offpeak_pricing * fan_energy_rate * offpeak_price
        
        var winter: hours_on_partpeak_pricing * fan_energy_rate * partpeak price + hours_on_offpeak_pricing * fan_energy_rate * offpeak_price
        
        var total_electric = summer + winter
        
        var total_cost = total_electric + gas_cost
        

    }
    
    private func is_energy_star(model_number:String, company: String, file_name: String) -> BooleanType {
        let rows = open_csv(filename: file_name)
        
        for row in rows! {
            
            if row["company"] != company {
                continue
            }
            if row["model_number"] != model_number { //model_number must be revised. Not sure what it should be
                continue
            }
            return true
            
        }
        
        return false
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
    
    private func __save_type(curr_array:Array<Dictionary<String, String>>, name:String) {
        
        var item_number = 0
        
        for item in curr_array {
            
            let unique_key = room_name + "/" + name + "/" + String(item_number) + "/"
            
            for (key, value) in item {
            
                audit.outputs[unique_key + key] = value
                
            }
            
            item_number += 1
            
        }
        
    }
    
    /*
 
     
     LIGHTING SECTION
 
 
    */
    
    private func over_under_lamped(lux: Float, category: String, units_in_lumens: Bool) -> String {
        
        let rows = open_csv(filename: "space_unit_levels")
        
        for row in rows! {
            
            if row["key"] != category { //Key must be revised. Not sure what it should be
                continue
            }
    
            //Add support for units in lumens
            if lux < Float(row["underlighted key"]!)! {
                
                return "Underlighted"
                
            } else if lux > Float(row["overlighted key"]!)! {
                
                return "Overlighted"
                
            } else {
                
                return "Neither under- nor overlighted"
                
            }
        }
        
        return ""
    }
    
    private func space_type_conversion(space_type: String) -> String {
        
        let rows = open_csv(filename: "space_type_conversion")
        
        for row in rows! {
            
            if row["key"] != space_type { //Key must be revised. Not sure what it should be
                continue
            }
            
            return row["space type key"]! //Again, not sure of the key
            
        }
        
        return ""
    }
        
    private func open_csv(filename:String) -> Array<Dictionary<String, String>>! {
        
        var output_file_string = ""
        
        do {
            
            guard let path = Bundle.main.path(forResource: filename, ofType: "txt")
                
                else { return nil }
            
            output_file_string = try String(contentsOfFile: path).replacingOccurrences(of: "\t", with: ",")
            
        } catch {
            
            print("There was an error")
            
            return nil
            
        }
        
        let csv = CSwiftV(with: output_file_string)
        
        
        return csv.keyedRows!
        
    }
    
    //The parameter room_type needs to provided to the user from watts_per_sqft.csv (it is in the first column)
    //That way we can guarantee that one choice will match
    private func fluorescent_lighting_watts (model_number:String) -> Int {
        //Did this work?
        
        var in_range = true
        
        var watts = 0
        
        for char in model_number.characters {
            
            if char >= "0" && char <= "9" && in_range {
                
                in_range = false
                
                continue
                
            } else if !in_range && (char >= "0" || char <= "9") {
                
                return watts
                
            } else {
                
                if let digit = Int(char.description) {
                    
                    watts += digit
                    
                }
                
            }
        }
        
        return 0
    }
        
    //The parameter room_type needs to provided to the user from watts_per_sqft.csv (it is in the first column)
    //That way we can guarantee that one choice will match
    private func light_per_area(watts: Int, area: Float, room_type: String) -> String {
        
        let watts_per_sqft = Float(watts) / area
        
        let rows = open_csv(filename: "watts_per_sqft")
        
        for row in rows! {
            
            if room_type != row["key"] { // Again, not sure what key should go here

                continue
                
            }
            
            // Need to clean up my unwrapping here
            if watts_per_sqft > Float(row["different key"]!)! { // Same problem
                
                return "Overuse of watts per sqft"
                
            } else if watts_per_sqft < Float(row["different key"]!)! {
                
                return "Underuse of watts per sqft"
                
            } else {
                
                return "Meets use of watts per sqft"
                
            }
        }
        
        return ""
        
    }
    
    
    private func total_energy_calculation_per_light(num_lamps: Int, test_hours: Int, hours_on: Int, watts: Float) -> Float {
        
        let hours_per_year = Float(hours_on) / Float(test_hours) * 8760
        
        let total_watts = watts * Float(num_lamps)
        
        return hours_per_year * total_watts
    }
    
    
}





