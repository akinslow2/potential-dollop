//
//  roomheader.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/22/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.


let feature_references = ["Lighting": "lighting_database", "Combination Oven": "combination_ovens", "Convection Oven": "convection_ovens", "Conveyor Oven": "conveyor_ovens", "Dishwasher": "dishwashers", "Freezer": "freezers", "Fryer": "fryers", "Glass Door Refrigerator": "glass_door_refrig", "Griddle": "griddles", "Hot Food Cabinet": "hfcs", "Ice Maker": "ice_makers", "Pre-Rinser": "pre-rinse", "Rack Oven": "rack_ovens", "Refrigerator": "refrigerators", "Solid Door Freezer": "solid_door_freezers", "Solid Door Refrigerator": "solid_door_refrigerators", "Steam Cooker": "steam_cookers"]

import Foundation

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[Range(start ..< end)]
    }
}

class Room: Audit {
    
    //This dictionary maps from the optimal model number to its total energy cost (averaged weekly)
    var models_to_cost = Dictionary<String, Double>()
    
    //In Android app all we need is plug-load and everything included in kitchen would be under that #Anthony
    var lighting = Array<Dictionary<String, String>>()
    var hvac = Array<Dictionary<String, String>>()
    var plug_load = Array<Dictionary<String, String>>()
    var kitchen_equipment = Array<Dictionary<String, String>>()
    
    var general_values = Dictionary<String, String>()
    var general_values_keys = Array<String>()
    var feature_table_keys = Array<String>()
    var room_name = ""
    var room_type = ""
    var curr_values = Dictionary<String, String>()
    
    let lighting_specs = ["Space Type", "Measured Lux", "Area", "Units"] //There are five space typye options located in column A of file Space Type which can be found in lighting folder of initial state #Anthony
    let hvac_specs = Array<String>()
    let room_specs_without_lighting = Array<String>()
    
    func setName(room_name_passed: String) {
        
        room_name = room_name_passed
        
    }
    
    /* setTypeOfRoom
    * ===============
    * Sets the globals based on the type of the room being entered by the user
    */
    
    func setTypeOfRoom(room_type_param: String) {
        
        room_type = room_type_param
        
        if room_type_param == "Lighting zone" {
            
            general_values_keys = lighting_specs
            
        } else if room_type_param == "HVAC zone" {
            
            general_values_keys = hvac_specs
            
        } else {
            
            general_values_keys = lighting_specs + room_specs_without_lighting
            
        }
        
        feature_table_keys = general_values_keys
        
        setGeneralValues()
        
    }
    
    private func setGeneralValues() {
        
        for key in general_values_keys {
            
            general_values[key] = ""
            
        }
        
        
    }

    //This below list of values should really be supplied when the room is closed.

    /* This method is called from the front end and will create a new feature for the room currently being edited.
    * Parameters: feature_type: one of four energy using features
    *             values: this is the map that contains the info about the energy using device from the front end
    */

    func new_feature(feature_type:String, values:Dictionary<String, String>) {
        
        curr_values = values

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
    
    /* Converts the values dictionary to the curr_values dictionary (a global) */
    
    func augment(values: Dictionary<String, String>) {
        
        for (key, value) in values {
            
            curr_values[key] = value
            
        }
        
    }
    
    
    /* Extracts the data for the light feature and then calculates the amount of energy used for each light. This is 
    * This is stored in the "lighting" map with both watts and energy.
    */

    private func __add_light_feature(values:Dictionary<String, String>) {
        
        let model_number = values["model_number"]!
        
        let num_lamps = Int(values["num_lamps"]!) 
        
        //We also need a variable for number of ballasts #Anthony
        
        let test_hours = Int(values["test_hours"]!)
        
        let hours_on = Int(values["hours_on"]!)
        
        let watts = fluorescent_lighting_watts(model_number: model_number) //This is not correct. Watts needs to be taken from a table. I will need to explain further on a call #Anthony
        
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
        
        let space_type = space_type_conversion(space_type: values["space_type"]!) //As previously mentioned should be a drop-down menu with 5 options.
        
        let area = Float(values["room-type"]!)
        
        let room_type = values["room-type"]! //This is not needed for MVP #Anthony
        
        
        
        let under_over_lighted = over_under_lamped(lux: lux!, category: space_type, units_in_lumens: units_in_lumens!)

        var total_watts = 0
        
        for light in lighting {
            
            total_watts += Int(light["watts"]!)!
            
        }

        let watts_usage_per_sqft = light_per_area(watts: total_watts, area: area!, room_type: room_type) //Not needed for MVP #Anthony
        
        var new_dict = Dictionary<String, String>()
        
        new_dict["watts_usage_per_sqft"] = String(watts_usage_per_sqft) //Not needed for MVP #Anthony
        
        new_dict["under_over_lighted"] = String(under_over_lighted)

        lighting.append(new_dict)
    }

 
    /* UNIMPLEMENTED */
    func __add_hvac_feature(values:Dictionary<String, String>) {
        

    }
    
    /* Checks to see which type of kitchen feature is being referenced and then does the calculations based
    * on the correct appliance.
    */

    func __add_kitchen_feature(values:Dictionary<String, String>) {
        let model_number = values["model_number"]!
        
        let company = values["num_lamps"]! //Why is this num_lamps??? #Anthony
        
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
            __compute__freezer__fridge(model_number: model_number, company: company)
        } else if type == "refrigerator" {
            __compute__freezer__fridge(model_number: model_number, company: company)
        } else if type == "hot_food_cabinets" {
            __compute__hot_food_cabinets(model_number: model_number, company: company)
        } else if type == "fryer" {
            __compute__fryer(model_number: model_number, company: company)
        } else if type == "steam_cookers" {
            __compute__steam__cookers(model_number: model_number, company: company)
        } else if type == "griddles" {
            __compute__griddle(model_number: model_number, company: company)
        }
        
    }
    
    /* Temporary solution to give the back end access to the production and size fields received from the
    * front end.
    */
        
    func deliver_prod_size(production: String, size: String) -> Dictionary<String, String> {
        
        return ["production": production, "size": size]
        
    }
    
    
    
    /* -------------------------------------------------------BEGINNING OF THE INDIVIDUAL APPLIANCE CALCULATIONS ---------------------------------------------- */
    
    /* To create a new appliance: Copy and paste the griddle method. Change the name. "is_energy_star" will be the same but the file_name will
    * change depending on the file name of the correct csv.
    * Then the find best model will change based on the parameters that are required to be the same between the old model and the new 
    * retrofitted model.
    */
    
    
    
    
    /* ----------------------------------------------------------BEGINNING OF THE COMPUTE APPLIANCE SECTION---------------------------------------------------- */
    
 
    /*This method is repeated for every single different kitchen appliance. It first checks to see if the model and company
    * can be found in the energy star list. If it is, then the method is complete and the original appliance is the best one.
    * If not, then the "find-best-model" method for that appliance is called with the specific parameters, and the best model is found
    * and then model number is returned.
    */
    
    
    /* Griddles */
    private func __compute__griddle(model_number:String, company: String){
        let energy_star = is_energy_star(model_number: model_number, company: company, file_name: feature_references["Convection Oven"]!)
        if energy_star {
            return
        }
        
        
        let best_model_num = find_best_model_griddle(surface_area: curr_values["size"]!, size: curr_values["capacity"]!, nominal_width: curr_values["width"]!, fuel_type: curr_values["fuel_type"]!, file_name: feature_references["Griddle"]!)
    }
    
    
    /* Steam Cookers */
    private func __compute__steam__cookers(model_number:String, company: String){
        let energy_star = is_energy_star(model_number: model_number, company: company, file_name: feature_references["Convection Oven"]!)
        if energy_star {
            return
        }
        
        
        let best_model_num = find_best_model_steam_cooker(prod_capacity: curr_values["production"]!, pan_capacity: curr_values["pan"]!, fuel_type: curr_values["fuel_type"]!, water_use: curr_values["Water Use"]!, steamer_type: curr_values["Type"]!, file_name: feature_references["Convection Oven"]!)
    }
    
    
    /* Fryer */
    private func __compute__fryer(model_number:String, company: String){
        let energy_star = is_energy_star(model_number: model_number, company: company, file_name: feature_references["Convection Oven"]!)
        if energy_star {
            return
        }
        
        let best_model_num = find_best_model_fryer(prod_capacity: curr_values["production"]!, shortening_capacity: curr_values["shortening capacity"]!, vat_width: curr_values["Vat Width"]!, fuel_type: curr_values["Fuel Type"]!, file_name: feature_references["Convection Oven"]!)
    }
    
    
    /* Hot Food Cabinets */
    private func __compute__hot_food_cabinets(model_number:String, company: String){
        let energy_star = is_energy_star(model_number: model_number, company: company, file_name: feature_references["Convection Oven"]!)
        if energy_star {
            return
        }
        
        let best_model_num = find_best_model_cabinet(cabinet_volume: curr_values["Cabinet Volume"]!, size: curr_values["Size"]!, idle_energy_rate: curr_values["Energy Rate"]!, file_name: feature_references["Convection Oven"]!)
    }
    
    
    /* Both Freezers and Refigerators */
    private func __compute__freezer__fridge(model_number:String, company: String){
        let energy_star = is_energy_star(model_number: model_number, company: company, file_name: feature_references["Convection Oven"]!)
        if energy_star {
            return
        }
        
        let best_model_num = find_best_model_fridge_freezer(prod_type: curr_values["Product Type"]!, total_volume: curr_values["total volume"]!, fridge_capacity: curr_values["Fridge Capacity"]!, file_name: feature_references["Convection Oven"]!)
    }
    
    
    /* Ice Makers */
    private func __compute__icemaker(model_number:String, company: String){
        let energy_star = is_energy_star(model_number: model_number, company: company, file_name: feature_references["Ice Maker"]!)
        if energy_star {
            return
        }
        
        let best_model_num = find_best_model_ice(ice_harvest_rate: curr_values["Ice Harvest Rate"]!, energy_use_rate: curr_values["Energy Use Rate"]!, ice_type: curr_values["Ice Type"]!, machine_type: curr_values["Machine Type"]!, file_name: feature_references["Ice Maker"]!)
    }
    
    
    /* Conveyor Ovens */
    private func __compute__conveyor__oven(model_number:String, company: String){
        let energy_star = is_energy_star(model_number: model_number, company: company, file_name: feature_references["Conveyor Oven"]!)
        if energy_star {
            return
        }
        let best_model_num = find_best_model_conveyor(oven_length: curr_values["oven length"]!, conveyor_width: curr_values["conveyor width"]!, file_name: feature_references["Conveyor Oven"]!)
    }
    
    
    /* Convection Ovens */
    private func __compute__convection__oven(model_number:String, company: String){
        let energy_star = is_energy_star(model_number: model_number, company: company, file_name: feature_references["Convection Oven"]!)
        if energy_star {
            return
        }
        
        let best_model_num = find_best_model_convection(capacity: curr_values["capacity"]!, size: curr_values["size"]!, fuel_type: curr_values["Fuel Type"]!, file_name: feature_references["Convection Oven"]!)
    }
    
    
    /* Combination Ovens */
    private func __compute__combination__oven(model_number:String, company: String){
        let energy_star = is_energy_star(model_number: model_number, company: company, file_name: feature_references["Combination Oven"]!)
        if energy_star {
            return
        }
        
        
        let best_model_num = find_best_model_combination(fuel_type: curr_values["Fuel Type"]!, size: curr_values["size"]!, file_name: feature_references["Combination Oven"]!)
    }
    
    
    /* Rack Ovens */
    private func __compute__rack__oven(model_number:String, company: String){
        let energy_star = is_energy_star(model_number: model_number, company: company, file_name: feature_references["Rack Oven"]!)
        if energy_star {
            return
        }
        
        let best_model_num = find_best_model_rack(prod_capacity: curr_values["production"]!, size: curr_values["size"]!, file_name: feature_references["Rack Oven"]!)
    }
    
    
    
    
    /* -------------------------------------------------------BEGINNING OF THE "FIND BEST MODEL" APPLIANCE SECTION------------------------------------------------- */
    
    
    /* This method opens the csv for the certain kitchen appliance. Then it finds all the models where the fixed parameters all match the original
    * appliance. This will guarantee that the new appliance matches the correct specifications of the original non-energy-star model.
    *
    * To create new find best model method: Change the parameters to the be the parameters that must be held constant in the new model
    * Replace the row[""] with the correct header name in the csv that corresponds to the parameter that must be held constant between models.
    * Then you will need to create a new find_energy_cost for the new appliance with the parameters needed for the energy cost calculations
    */
    //The below options don't seem to be doing any calculations to find the best model. If not, I will need to explain what calcs should occur. #Anthony
    
    
    /* Griddles */
    private func find_best_model_griddle(surface_area: String, size: String, nominal_width: String, fuel_type: String, file_name: String) -> String{
 
        let rows = open_csv(filename: file_name)
        
        var new_dict = Dictionary<String, Double>()
        
        for row in rows! {
            
            /*  if row["Header String in the csv"] != parameters_name {
            *           continue
            *   }
            */
            
            if row["Single or Double Sided"] != size {
                continue
            }
            if row["Surface Area (ft²)"] != surface_area {
                continue
            }
            if row["Nominal Width (ft)"] != nominal_width {
                continue
            }
            if row["Fuel Type"] != fuel_type {
                continue
            }
            
            //Preheat Energy, Idle Energy Rate
            new_dict[row["Model Number"]!] = find_energy_cost_combination_fryer_griddle(preheat_energy: Double(row["Preheat Energy (Btu)"]!)!, idle_energy_rate: Double(row["Idle Energy Rate (Btu/h or kW)"]!)!)
        }
        
        var best_model = find_lowest_cost_model(list_of_costs: new_dict)
        
        return best_model
    }
    
    /* Steam Cookers */
    private func find_best_model_steam_cooker(prod_capacity: String, pan_capacity: String, fuel_type: String, water_use: String, steamer_type: String, file_name: String) -> String{
        
        let rows = open_csv(filename: file_name)
        
        var new_dict = Dictionary<String, Double>()
        
        for row in rows! {
            
            if row["Pan Capacity"] != pan_capacity {
                continue
            }
            if row["Production Capacity (lb/h)"] != prod_capacity {
                continue
            }
            if row["Fuel Type"] != fuel_type {
                continue
            }
            if row["Water Use (gph)"] != water_use {
                continue
            }
            if row["Steamer Type"] != steamer_type {
                continue
            }
            
            new_dict[row["Model Number"]!] = find_energy_cost_steam_cooker(preheat_energy: Double(row["Preheat Energy (Btu)"]!)!, idle_energy_rate: Double(row["Idle Energy Rate (Btu/h or kW)"]!)!)
        }
        
        var best_model = find_lowest_cost_model(list_of_costs: new_dict)
        
        return best_model
    }
    
    /* Fryer */
    private func find_best_model_fryer(prod_capacity: String, shortening_capacity: String, vat_width: String, fuel_type: String, file_name: String) -> String{
        
        let rows = open_csv(filename: file_name)
        
        var new_dict = Dictionary<String, Double>()
        
        for row in rows! {
            
            if row["Shortening Capacity (lb)"] != shortening_capacity {
                continue
            }
            if row["Production Capacity (lbs/h)"] != prod_capacity {
                continue
            }
            if row["Vat Width"] != vat_width {
                continue
            }
            if row["Fuel Type"] != fuel_type {
                continue
            }
            
            new_dict[row["Model Number"]!] = find_energy_cost_combination_fryer_griddle(preheat_energy: Double(row["Preheat Energy (Btu)"]!)!, idle_energy_rate: Double(row["Idle Energy Rate (Btu/h or kW)"]!)!)
        }
        
        var best_model = find_lowest_cost_model(list_of_costs: new_dict)
        
        return best_model
    }
    
    /* Hot Food Cabinets */
    private func find_best_model_cabinet(cabinet_volume: String, size: String, idle_energy_rate: String, file_name: String) -> String{
        
        let rows = open_csv(filename: file_name)
        
        var new_dict = Dictionary<String, Double>()
        
        for row in rows! {
            
            if row["Cabinet Volume (cu. ft.)"] != cabinet_volume {
                continue
            }
            if row["Size"] != size {
                continue
            }
            if row["Idle Energy Rate (Btu/h or kW)"] != idle_energy_rate {
                continue
            }
            
            new_dict[row["Model Number"]!] = find_energy_cost_cabinet(cabinet_volume: Double(row["Cabinet Volume (cu. ft.)"]!)!, idle_energy_rate: Double(row["Idle Energy Rate (Btu/h or kW)"]!)!)
        }
        
        var best_model = find_lowest_cost_model(list_of_costs: new_dict)
        
        return best_model
    }
    
    /* Freezers and Refrigerators */
    private func find_best_model_fridge_freezer(prod_type: String, total_volume: String, fridge_capacity: String, file_name: String) -> String{
        
        let rows = open_csv(filename: file_name)
        
        var new_dict = Dictionary<String, Double>()
        
        for row in rows! {
            
            if row["Style Type"] != prod_type {
                continue
            }
            if row["Total Volume (cu. ft.)"] != total_volume {
                continue
            }
            
            new_dict[row["Model Number"]!] = find_energy_cost_freeze_fridge()
            
            
        }
        
        var best_model = find_lowest_cost_model(list_of_costs: new_dict)
        
        return best_model
    }
    
    /* Ice Harvest */
    private func find_best_model_ice(ice_harvest_rate: String, energy_use_rate: String, ice_type: String, machine_type: String, file_name: String) -> String{
        
        let rows = open_csv(filename: file_name)
        
        var new_dict = Dictionary<String, Double>()
        
        for row in rows! {
            
            if row["Ice Harvest Rate (lbs/day)"] != ice_harvest_rate {
                continue
            }
            if row["Energy Use Rate (kWh/100 lbs)"] != energy_use_rate {
                continue
            }
            if row["Ice Type"] != ice_type {
                continue
            }
            if row["Machine Type"] != machine_type {
                continue
            }
            
            new_dict[row["Model Number"]!] = find_energy_cost_ice(energy_use_rate: Double(row["Energy Use Rate (kWh/100 lbs)"]!)!, ice_harvest_rate: Double(row["Ice Harvest Rate (lbs/day)"]!)!)
        }
        
        var best_model = find_lowest_cost_model(list_of_costs: new_dict)
        
        return best_model
    }
    
    /* Conveyor Ovens */
    private func find_best_model_conveyor(oven_length: String, conveyor_width: String, file_name: String) -> String{
        
        let rows = open_csv(filename: file_name)
        
        var new_dict = Dictionary<String, Double>()
        
        for row in rows! {
            
            if row["Conveyor Width (in)"] != conveyor_width {
                continue
            }
            
            new_dict[row["Model Number"]!] = find_energy_cost_oven(preheat_energy: Double(row["Preheat Energy (Btu)"]!)!, idle_energy_rate: Double(row["Idle Energy Rate (Btu/h or kW)"]!)!, fan_energy_rate: Double(row["Fan/Control Energy Rate (kW)"]!)!)
        }
        
        var best_model = find_lowest_cost_model(list_of_costs: new_dict)
        
        return best_model
    }
    
    /* Convection Ovens */
    private func find_best_model_convection(capacity: String, size: String, fuel_type: String, file_name: String) -> String{
        
        let rows = open_csv(filename: file_name)
        
        var new_dict = Dictionary<String, Double>()
        
        for row in rows! {
            
            if row["Production Capacity (lbs/h)"] != capacity {
                continue
            }
            if row["Oven Size"] != size {
                continue
            }
            if row["Fuel Type"] != fuel_type {
                continue
            }
            
            new_dict[row["Model Number"]!] = find_energy_cost_oven(preheat_energy: Double(row["Preheat Energy (Btu)"]!)!, idle_energy_rate: Double(row["Idle Energy Rate (Btu/h or kW)"]!)!, fan_energy_rate: Double(row["Fan/Control Energy Rate (kW)"]!)!)
        }
        
        var best_model = find_lowest_cost_model(list_of_costs: new_dict)
        
        return best_model
    }
    
    /* Combination Ovens */
    private func find_best_model_combination(fuel_type: String, size: String, file_name: String) -> String{
        
        let rows = open_csv(filename: file_name)
        
        var new_dict = Dictionary<String, Double>()
        
        for row in rows! {
            
            if row["Fuel Type"] != fuel_type {
                continue
            }
            if row["Size (Steam Pans)"] != size {
                continue
            }
            
            new_dict[row["Model Number"]!] = find_energy_cost_combination_fryer_griddle(preheat_energy: Double(row["Preheat Energy (Btu)"]!)!, idle_energy_rate: Double(row["Idle Energy Rate (Btu/h or kW)"]!)!)
        }
        
        var best_model = find_lowest_cost_model(list_of_costs: new_dict)
        
        return best_model
    }
    
    /* Rack Ovens */
    private func find_best_model_rack(prod_capacity: String, size: String, file_name: String) -> String{
        
        let rows = open_csv(filename: file_name)
        
        var new_dict = Dictionary<String, Double>()
        
        for row in rows! {
            
            if row["Size"] != size {
                continue
            }
            if row["Production Capacity (lbs/h)"] != prod_capacity {
                continue
            }
            
            new_dict[row["Model Number"]!] = find_energy_cost_oven(preheat_energy: Double(row["Preheat Energy (Btu)"]!)!, idle_energy_rate: Double(row["Idle Energy Rate (Btu/h or kW)"]!)!, fan_energy_rate: Double(row["Fan/Control Energy Rate (kW)"]!)!)
        }
        
        var best_model = find_lowest_cost_model(list_of_costs: new_dict)
        
        return best_model
    }
    
    /* ------------------------------------------------ BEGINNING OF FIND ENERGY COST APPLIANCE SECTION --------------------------------------------------*/
    
    /* This method calculates the energy cost (weekly) for each individual appliance. It can be broken up into two sections: gas, electric.
     * These calculations are based completely off the energy calculations for that appliance and whether it uses fas, electric, or both.
     *
     * To create new find energy cost method: Follow the format of the others and input the correct equation. Many times, the equation for a new
     * appliance will be the same as one already inputted and the equation can be reused.
     */
    //Calculations are correct but the same variable total cost is used repeatedly. Does this mean I wil not be able to determine
    //the energy costs of any individual appliance??? #Anthony
    
    
    /* Ovens except for combination ovens */
    private func find_energy_cost_oven(preheat_energy: Double, idle_energy_rate: Double, fan_energy_rate: Double) -> Double{
        
        //Gets the pricing_chart for the peak_hours for winter and summer based on the rate structure from the front end.
        var pricing_chart = get_bill_data(bill_type: audit.outputs["Rate Structure Electric"]!)
        
        //This calculates the amount of Peak, Off-Peak, and Part-Peak hours that happen during the operation hours
        var peak_hour_schedule = calculate_all_peak_hours()
        
        
        //Calculates Weekly Gas-Energy and Gas Costs
        var gas_energy = preheat_energy * Double(audit.outputs["days_in_operation"] as! String)! + Double(audit.outputs["ideal_run_hours"] as! String)! * idle_energy_rate
        
        var winter_rate = calculate_winter_rate(gas_energy: gas_energy)
        
        var summer_rate = calculate_summer_rate(gas_energy: gas_energy)
        
        //Taking the average rates assumes no changes in operation for the ovens
        //Dividing by 99976.1 assumes the gas is being measured in BTUs and we need it in therms
        var gas_cost = gas_energy / 99976.1 * (winter_rate + summer_rate) / 2
        
        
        //Calculates Summer and Winter Weekly Electric Cost
        //fan energy rate is power output
        var summer = Double(peak_hour_schedule["Summer-On-Peak"]!) * fan_energy_rate * Double(pricing_chart["Summer-On-Peak"]!)
        summer += Double(peak_hour_schedule["Summer-Part-Peak"]!) * fan_energy_rate * Double(pricing_chart["Summer-Part-Peak"]!)
        summer += Double(peak_hour_schedule["Summer-Off-Peak"]!) * fan_energy_rate * Double(pricing_chart["Summer-Off-Peak"]!)
        
        var winter = Double(peak_hour_schedule["Winter-On-Peak"]!) * fan_energy_rate * Double(pricing_chart["Winter-On-Peak"]!)
        winter += Double(peak_hour_schedule["Winter-Off-Peak"]!) * fan_energy_rate * Double(pricing_chart["Winter-Off-Peak"]!)
        
        
        //Calculates the total
        var total_electric = summer + winter
        
        var total_cost = total_electric + gas_cost
        
        return total_cost
        
    }
    
    private func find_energy_cost_combination_fryer_griddle(preheat_energy: Double, idle_energy_rate: Double) -> Double{
        
        var pricing_chart = get_bill_data(bill_type: audit.outputs["Rate Structure Electric"]!)
        
        
        //Weekly Gas Cost
        var gas_energy = preheat_energy * Double(audit.outputs["days_in_operation"] as! String)! + Double(audit.outputs["ideal_run_hours"] as! String)! * idle_energy_rate
        
        var winter_rate = calculate_winter_rate(gas_energy: gas_energy)
        
        var summer_rate = calculate_summer_rate(gas_energy: gas_energy)
        
        
        var gas_cost = gas_energy / 99976.1 * (winter_rate + summer_rate) / 2
        
        
        var peak_hour_schedule = calculate_all_peak_hours()
        
        //Electric Cost Weekly:
        var summer = Double(peak_hour_schedule["Summer-On-Peak"]!) * idle_energy_rate * Double(pricing_chart["Summer-On-Peak"]!)
        summer += Double(peak_hour_schedule["Summer-Part-Peak"]!) * idle_energy_rate * Double(pricing_chart["Summer-Part-Peak"]!)
        summer += Double(peak_hour_schedule["Summer-Off-Peak"]!) * idle_energy_rate * Double(pricing_chart["Summer-Off-Peak"]!)
        
        var winter = Double(peak_hour_schedule["Winter-On-Peak"]!) * idle_energy_rate * Double(pricing_chart["Winter-On-Peak"]!)
        winter += Double(peak_hour_schedule["Winter-Off-Peak"]!) * idle_energy_rate * Double(pricing_chart["Winter-Off-Peak"]!)
        
        var total_electric = summer + winter
        
        var total_cost = total_electric + gas_cost
        
        return total_cost
        
    }
    
    /* Ice Maker */
    private func find_energy_cost_ice(energy_use_rate: Double, ice_harvest_rate: Double) -> Double{
        
        var pricing_chart = get_bill_data(bill_type: audit.outputs["Rate Structure Electric"]!)
        
        var peak_hour_schedule = calculate_all_peak_hours()
        
        var hour_energy_use = ice_harvest_rate * energy_use_rate / 24.0
        
        
        //Electric Cost:
        var summer = Double(peak_hour_schedule["Summer-On-Peak"]!) * hour_energy_use * Double(pricing_chart["Summer-On-Peak"]!)
        summer += Double(peak_hour_schedule["Summer-Part-Peak"]!) * hour_energy_use * Double(pricing_chart["Summer-Part-Peak"]!)
        summer += Double(peak_hour_schedule["Summer-Off-Peak"]!) * hour_energy_use * Double(pricing_chart["Summer-Off-Peak"]!)
        
        //Winter is only part-peak and off-peak #Anthony
        var winter = Double(peak_hour_schedule["Winter-On-Peak"]!) * hour_energy_use * Double(pricing_chart["Winter-On-Peak"]!)
        winter += Double(peak_hour_schedule["Winter-Off-Peak"]!) * hour_energy_use * Double(pricing_chart["Winter-Off-Peak"]!)
        
        var total_electric = summer + winter
        
        var total_cost = total_electric
        
        return total_cost
        
    }
    
    /* Freezers and Refrigerators */
    private func find_energy_cost_freeze_fridge() -> Double{
        
        var pricing_chart = get_bill_data(bill_type: audit.outputs["Rate Structure Electric"]!)
        
        var peak_hour_schedule = calculate_all_peak_hours()
        
        //this is a place holder, because I do not know the equation 184 days
        var hour_energy_use = 10.0 //this should be a parameter requested #Anthony
        //Also this runs 24/7 which means the hours can be constants specifically:
        // summer-on-peak would be 6hrs-per-day*128days (because not during weekends or 3 holidays) to equal 768 hrs 
        // summer-part-peak would be 7hrs-per-day*128 days (because not during weekends or 3 holidays) to equal 896 hrs
        // summer-off-peak would be 11hrs-per-day*128 + 24hrs-per-day*60 days to equal 2,848 hrs #Anthony
        
        //Electric Cost:
        var summer = Double(peak_hour_schedule["Summer-On-Peak"]!) * hour_energy_use * Double(pricing_chart["Summer-On-Peak"]!)
        summer += Double(peak_hour_schedule["Summer-Part-Peak"]!) * hour_energy_use * Double(pricing_chart["Summer-Part-Peak"]!)
        summer += Double(peak_hour_schedule["Summer-Off-Peak"]!) * hour_energy_use * Double(pricing_chart["Summer-Off-Peak"]!)
        
        //Winter should only have part-peak and off peak. #Anthony
        //Because they are refrigerators the hours can be constant specifically:
        //winter-part-peak would be 13hrs-per-day*124days (because not during weekends or 5 holidays) to equal 1,612 hrs
        //winter-off-peak would be 11hrs-per-day*124days + 24hrs-per-day*57 days to equal 2,732 hrs #Anthony
        var winter = Double(peak_hour_schedule["Winter-On-Peak"]!) * hour_energy_use * Double(pricing_chart["Winter-On-Peak"]!)
        winter += Double(peak_hour_schedule["Winter-Off-Peak"]!) * hour_energy_use * Double(pricing_chart["Winter-Off-Peak"]!)
        
        var total_electric = summer + winter 
        
        var total_cost = total_electric
        
        return total_cost
        
    }
    
    /* Hot Food Cabinets */
    private func find_energy_cost_cabinet(cabinet_volume: Double, idle_energy_rate: Double) -> Double{
        
        var pricing_chart = get_bill_data(bill_type: audit.outputs["Rate Structure Electric"]!)
        
        var peak_hour_schedule = calculate_all_peak_hours()
        
        
        var energy_use = cabinet_volume * idle_energy_rate / 1000.0
        
        //Electric Cost:
        var summer = Double(peak_hour_schedule["Summer-On-Peak"]!) * energy_use * Double(pricing_chart["Summer-On-Peak"]!)
        summer += Double(peak_hour_schedule["Summer-Part-Peak"]!) * energy_use * Double(pricing_chart["Summer-Part-Peak"]!)
        summer += Double(peak_hour_schedule["Summer-Off-Peak"]!) * energy_use * Double(pricing_chart["Summer-Off-Peak"]!)
        //Winter should be only part-peak and off-peak #Anthony
        var winter = Double(peak_hour_schedule["Winter-On-Peak"]!) * energy_use * Double(pricing_chart["Winter-On-Peak"]!)
        winter += Double(peak_hour_schedule["Winter-Off-Peak"]!) * energy_use * Double(pricing_chart["Winter-Off-Peak"]!)
        
        var total_electric = summer + winter
        
        var total_cost = total_electric
        
        return total_cost
        
    }
    
    /* Steam Cookers */
    private func find_energy_cost_steam_cooker(preheat_energy: Double, idle_energy_rate: Double) -> Double{
        
        var gas_energy = preheat_energy * Double(audit.outputs["days_in_operation"] as! String)! + Double(audit.outputs["ideal_run_hours"] as! String)! * idle_energy_rate
        
        var winter_rate = calculate_winter_rate(gas_energy: gas_energy)
        
        var summer_rate = calculate_summer_rate(gas_energy: gas_energy)
        
        
        var gas_cost = gas_energy / 99976.1 * (winter_rate + summer_rate) / 2
        
        var total_cost = gas_cost
        
        return total_cost
        
    }
    
    /* ------------------------------------------------------------------------------------------------------------------------ */
    
    
    
    /* Function: find_lowest_cost_model
    * ---------------------------------
    * This method loops through all the elements in the map "list_of_costs" and finds the model number
    * that has the lowest cost. It also saves the model with the lowest cost in a map to be used to 
    * calculate the total energy cost for all appliances.
    */
    
    private func find_lowest_cost_model(list_of_costs: Dictionary<String, Double>) -> String {
        let lowest_cost = 10000000000.0
        var model_name = ""
        
        
        for model in list_of_costs.keys {
            if list_of_costs[model]! < lowest_cost {
                model_name = model
            }
        }
        models_to_cost[model_name] = lowest_cost
        
        return model_name
    }
    
    /* Function: total_cost
    * ---------------------
    * This calculates the total_cost of all the energy used in the simple interval data csv from PG&E. 
    */
    //Missing peak rates which is used in Time of Use (TOU) billing. Will need to explain to y'all further. #Anthony
    
    func total_cost() -> Double{
        var hour_data = read_in_hour_data()
        var pricing_data = get_bill_data(bill_type: audit.outputs["Rate Structure Electric"]!)
        
        //So they did the part-peak right here...not sure why not above #Anthony
        var total_cost = hour_data["Winter-Part-Peak"]! * pricing_data["Winter-Part-Peak"]!
        total_cost = total_cost + hour_data["Winter-Off-Peak"]! * pricing_data["Winter-Off-Peak"]!
        total_cost = total_cost + hour_data["Summer-On-Peak"]! * pricing_data["Summer-On-Peak"]!
        total_cost = total_cost + hour_data["Summer-Part-Peak"]! * pricing_data["Summer-Part-Peak"]!
        total_cost = total_cost + hour_data["Summer-Off-Peak"]! * pricing_data["Summer-Off-Peak"]!
        
        return total_cost
    }
    
    /* Function: read_in_hour_data
    * ----------------------------
    * This method works through the simple_interval_data csv and finds all the energy that is used in each different
    * kind of bill peak (Peak, Part-Peak, Off-Peak) and stores it in a map, to be used in total_cost.
    * At the moment, this method assumes that every day is a weekday and non-holiday
    * This is also specific to PG&E
    */
    
    private func read_in_hour_data() -> Dictionary<String, Double> {
        let rows = open_csv(filename: "sample_interval_data")
        
        var hour_data = Dictionary<String, Double>()
        
        //Loops through every row
        for row in rows! {
            let someString = row["usg_dt"] //This is the column with day, year, and month
            var firstChar = Int((someString?[0])!)!
            if firstChar == 1 {
                if let digit = Int((someString?[1])!) {
                    firstChar = Int(String(firstChar) + (someString?[1])!)!
                }
            }
            
            //This is the check if it's a winter month which are between November (11) and April (4) 
            if firstChar <= 4 || firstChar >= 11 {
                //Find the time in the "elec_intvl_end_dttm" column
                let str1 = row["elec_intvl_end_dttm"]?.components(separatedBy: " ")[1]
                let firstTimeChar = Int((str1?[0])!)!
                
                //If the first number in the time is a 1 or 2, check if the hour is 2 digit
                //In military time 0-24hrs
                if  firstTimeChar == 1 || firstTimeChar == 2 {
                    if let digit = Int((someString?[1])!) {
                        firstChar = Int(String(firstChar) + (someString?[1])!)!
                    }
                }
                
                //Then checks to see which time the time falls under. This is the hard-coded time, but could be adjusted to 
                //be based on a csv or formula
                //needs to be 830 to 2130 #Anthony
                if firstTimeChar >= 8 && firstTimeChar < 21 {
                    let a = hour_data["Winter-Part-Peak"]
                    hour_data["Winter-Part-Peak"] = a! + Double(row["usgAmount"]!)!
                } else {
                    let a = hour_data["Winter-Off-Peak"]
                    hour_data["Winter-Off-Peak"] = a! + Double(row["usgAmount"]!)!
                }
                
                
            //This is the check if its a summer month
            } else {
                var str = row[""]
                let str1 = row["elec_intvl_end_dttm"]?.components(separatedBy: " ")[1]
                let firstTimeChar = Int((str1?.components(separatedBy: "")[0])!)
                if  firstTimeChar == 1 || firstTimeChar == 2{
                    if let digit = Int((someString?[1])!) {
                        firstChar = Int(String(firstChar) + (someString?[1])!)!
                    }
                }
                
                //Similar to winter, but there are three different peaks
                //Part-peak should be 830 - 12 & 18 - 2130 #Anthony
                if firstTimeChar! >= 12 && firstTimeChar! < 18 {
                    let a = hour_data["Summer-On-Peak"]
                    hour_data["Summer-On-Peak"] = a! + Double(row["usgAmount"]!)!
                } else if (firstTimeChar! >= 8 && firstTimeChar! < 12) || (firstTimeChar! >= 18 && firstTimeChar! < 21){
                    let a = hour_data["Summer-Part-Peak"]
                    hour_data["Summer-Part-Peak"] = a! + Double(row["usgAmount"]!)!
                } else {
                    let a = hour_data["Summer-Off-Peak"]
                    hour_data["Summer-Off-Peak"] = a! + Double(row["usgAmount"]!)!
                }
                
            }
        }
        return hour_data
    }
    
    
    /* Function: calculate_all_peak_hours()
    * -------------------------------------
    * This takes uses the operating hours, taken from the front-end input. Then it uses those hours
    * to calculate how many of the operating hours are in each of the different peaks.
    */
    
    private func calculate_all_peak_hours() -> Dictionary<String, Int> {
        //This gets the opening and closing hours
        //Does not seem to allow for multiple operating hours in a day nor different operating hours each day. #Anthony
        var opening = audit.outputs["Operating Hours"]?.components(separatedBy: " ")[0]
        var closing = audit.outputs["Operating Hours"]?.components(separatedBy: " ")[1]
        
        
        //Current Placeholder, opening_hour will be the first two characters of the "opening" string, same with closing_hour
        var opening_hour = Int("1")
        var closing_hour = Int("2")
        
        var hour_data = Dictionary<String, Int>()
        
        
        //Loops through all 24 hours, could be changed to loop through half-hours
        //should be all half-hours
        for i in 1...24 {
            //If the hour i is not within the operating hours, skip it
            //Should be i < closing_hour #Anthony
            if i <= opening_hour! || i > closing_hour! {
                continue
            }
            
            //Find which Types of peaks this hours fits into
            //The summer part-peak hours need to be 830 - 12 & 18 - 2130 #Anthony
            //The winter part-peak hours need to be 830 - 2130 #Anthony
            if i >= 12 && i < 18 {
                hour_data["Summer-On-Peak"]! += 1
            } else if (i >= 8 && i < 12) || (i >= 18 && i < 21){
                hour_data["Summer-Part-Peak"]! += 1
            } else {
                hour_data["Summer-Off-Peak"]! += 1
            }
            
            if i >= 8 && i < 21 {
                hour_data["Winter-Part-Peak"]! += 1
            } else {
                hour_data["Winter-Off-Peak"]! += 1
            }
            
            
        }
        
        return hour_data
        
    }
    
    /* Function: calculate_winter_rate()
    * ----------------------------------
    * This calculates the winter rate for the gas based on the gas bill. It calculates the daily_energy_usage
    * and then uses that to find the correct column for average_daily_usage. Then it adds the winter rate and the 
    * Public Purpose Program Surcharge.
    */
    //Need to get an example of gas bill to make sure this is correct.#Anthony
    //This whole function is a little confusing #Anthony
    private func calculate_winter_rate(gas_energy: Double) -> Double{
        //super estimation, 6 is to make it likely an overestimation
        var daily_energy_usage = gas_energy / 6
        
        var total_cost = 0.0
        
        let rows = open_csv_rows(filename: "pge_gas_small")
        
        var month = 0
        
        for row in rows! {
            
            //This loops until the first month is found, it can be adjusted to find the correct first month
            if row[0][0] != "0" && !found {
                continue
            }
            found = true
            
            var running_month_total = 0.0
            
            //This finds the correct range for the daily-usage rate
            //This is taking a month to be 30 days when in reality number of days differ month to month. Should be fixed in Android version #Anthony
            if daily_energy_usage <= 5.0 {
                
                running_month_total = Double(row[2])! * 30.0
            } else if daily_energy_usage <= 16.0 {
                running_month_total = Double(row[3])! * 30.0
            } else if daily_energy_usage <= 41.0 {
                running_month_total = Double(row[4])! * 30.0
            } else if daily_energy_usage <= 123.0 {
                running_month_total = Double(row[5])! * 30.0
            } else {
                running_month_total = Double(row[6])! * 30.0
            }
            
            //This adds the winter_rate
            //Should be row[14], summer is row[12] from the code. #Anthony
            //Also assumes under 4,000 therms which is the threshold (specific to PG&E) before the price rises. 
            running_month_total = running_month_total + (daily_energy_usage * 30.0 * Double(row[8])!)
            
            //This adds the Public Purpose Program Surcharge
            //Still assumes 30 days per month. 
            running_month_total = running_month_total + (daily_energy_usage * 30.0 * Double(row[16])!)

            total_cost += running_month_total
            
            month = month + 1
            //Why for all 12 months? Needs to be 6 months, November (11) thru April (4) 
            if month == 12 {
                break
            }
            
        }
        
        //this returns the average to find the monthly cost
        //You can divide by 52 instead in order to make it weekly
        return Double(total_cost / 12) //This seems a bit pointless and it is not saved to a variable #Anthony
        
    }
    
    /* Function: calculate_summer_rate()
     * ----------------------------------
     * This calculates the winter rate for the gas based on the gas bill. It calculates the daily_energy_usage
     * and then uses that to find the correct column for average_daily_usage. Then it adds the winter rate and the
     * Public Purpose Program Surcharge.
    //Directly above they copied and pasted the description, and said winter rate when they should of said summer rate #Anthony
     */
    private func calculate_summer_rate(gas_energy: Double) -> Double {
        //super estimation, 6 is to make it likely an overestimation
        var daily_energy_usage = gas_energy / 6
        
        var total_cost = 0.0
        
        let rows = open_csv_rows(filename: "pge_gas_small")
        
        var month = 0
        
        for row in rows! {
            //This loops until the first month is found, it can be adjusted to find the correct first month
            if row[0][0] != "0" && !found {
                continue
            }
            found = true
            
            var running_month_total = 0.0
            
            if daily_energy_usage <= 5.0 {
                
                running_month_total = Double(row[2])! * 30.0
            } else if daily_energy_usage <= 16.0 {
                running_month_total = Double(row[3])! * 30.0
            } else if daily_energy_usage <= 41.0 {
                running_month_total = Double(row[4])! * 30.0
            } else if daily_energy_usage <= 123.0 {
                running_month_total = Double(row[5])! * 30.0
            } else {
                running_month_total = Double(row[6])! * 30.0
            }
            
            //This adds the summer_rate
            //summer is actually row[12] #Anthony
            running_month_total = running_month_total + (daily_energy_usage * 30.0 * Double(row[10])!)
            
            running_month_total = running_month_total + (daily_energy_usage * 30.0 * Double(row[16])!)
            
            total_cost += running_month_total
            
            month = month + 1
            
            if month == 12 {
                break
            }
            
        }
        
        return Double(total_cost / 12) //Same issue as previous function of purpose of average & no variable for later use #Anthony
    }

    
    /* Function: get_bill_data()
    * --------------------------
    * This method walks through the csv to find the rates of each of the peak times. This is based on the
    * bill_type.
    */
    private func get_bill_data(bill_type: String) -> Dictionary<String, Double> {
        
        //This references file PG&E_RelevantElectricRateStructures_Current(Aug15).xls located in PG&E folder
        let rows = open_csv(filename: "pge_electric")
        
        var new_dict = Dictionary<String, Double>()
        
        var found = false
        var summer = true
        var super_exists = false
        
        for row in rows! {
            
            //This loops until it finds the correct bill_type
            if row["Name"]! == bill_type {
                found = true
            } else if row["Name"]! != bill_type {
                if !found {
                    continue
                } else if !row["Name"]!.isEmpty {
                    break
                }
            }
            
            //This adds the two winter rates
            if row["Season"]! == "Winter"{
                summer = false
                if row["Peak"]! == "On-Peak" {
                    new_dict["Winter-On-Peak"] = Double(row["Energy"]!)
                } else {
                    new_dict["Winter-Off-Peak"] = Double(row["Energy"]!)
                }
                
            //This adds the summer rates
            } else if row["Season"]! == "Summer" || summer {
                summer = true
                //If the bill has a super-peak, then this code just makes it On-Peak and shifts everything down one
                //Not sure what the idea of a super-peak is. The next 9 lines can be deleted or commented out -Anthony
                if row["Peak"]! == "Super-Peak" || super_exists {
                    super_exists = true
                    if row["Peak"]! == "Super-Peak" {
                        new_dict["Summer-On-Peak"] = Double(row["Energy"]!)
                    } else if row["Peak"] == "On-Peak" {
                        new_dict["Summer-Part-Peak"] = Double(row["Energy"]!)
                    } else {
                        new_dict["Summer-Off-Peak"] = Double(row["Energy"]!)
                    }
                 //Do not delete past here -Anthony   
                //otherwise it adds the Peak rates like normal
                } else {
                    if row["Peak"]! == "On-Peak" {
                        new_dict["Summer-On-Peak"] = Double(row["Energy"]!)
                    } else if row["Peak"] == "Part-Peak" {
                        new_dict["Summer-Part-Peak"] = Double(row["Energy"]!)
                    } else {
                        new_dict["Summer-Off-Peak"] = Double(row["Energy"]!)
                    }
                }
            }
        }
        return new_dict
    }
    
    /* Function: is_energy_star()
    * ---------------------------
    * This method loops through the csv for the kitchen appliance and then checks to see if the model
    * and company can be found in the list. If it is, then you return true saying that it has been found
    * and false if you never found the model in the list.
    */
    
    func is_energy_star(model_number: String, company: String, file_name: String) -> Bool {
        let rows = open_csv(filename: file_name)
        
        for row in rows! {
            
            if row["Company"]! != company {
                continue
            }
            if row["Model Number"]! != model_number { //model_number must be revised. Not sure what it should be, depends on the csv
                continue
            }
            return true
            
        }
        
        return false
    }
    
    /* UNIMPLEMENTED */
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
    
    
    //This is how the elemnts are to be saved for the front-end but is not really used
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
    
    /* ----------------------------------------- LIGHTING SECTION --------------------------------------------- */
    
    private func over_under_lamped(lux: Float, category: String, units_in_lumens: Bool) -> String {
        //Refers to file space_type located in lighting folder of initial state
        let rows = open_csv(filename: "space_unit_levels")
        
        for row in rows! {
            
            if row["key"] != category { //This key will depend on what the header is in the csv
                continue
            }
    
            //Add support for units in lumens
            if lux < Float(row["underlighted key"]!)! {
                
                return "Underlighted"
                
            } else if lux > Float(row["overlighted key"]!)! {
                
                return "Overlighted"
                
            } else {
                //Should return: Within recommened lighting range #Anthony
                return "Neither under- nor overlighted"
                
            }
        }
        
        return ""
    }
    
    
    /* This method converts the space type into the name it holds in the csv */
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
    
    /*
     
     Function: open_csv
     --------------------
     Returns an Optional(Array<Dictionary<String, String>>)
     of the elements in a csv with the first column as
     the keys in the array, and the subsequent columns
     are the values, corresponding to their shared row.
     
     For example:
     Category, Space Type
     A, Classroom
     B, Armory
     ->
     [{A : Classroom}, {B : Armory}]
     
     ***
     
     In order to input a file:
     
     1. Download as a .txt with \t separated values
     2. Open in Word and save as a .txt with UTF-8 encoding
     and LF only
     3. In Xcode, File -> Add Files to ... -> *Select file and add to "CSVs" folder*
     
     ***
     
     @param file's name in folder, String
     
     Example: (for CSVs/space_type.csv), filename = "space_type"
     
     */
    private func open_csv(filename:String) -> Array<Dictionary<String, String>>! {
        
        var output_file_string = ""
        
        let full_filename = "CSVs/" + filename
        
        do {
            
            guard let path = Bundle.main.path(forResource: full_filename, ofType: "txt")
                
                else { return nil }
            
            output_file_string = try String(contentsOfFile: path).replacingOccurrences(of: "\t", with: ",")
            
        } catch {
            
            print("There was an error")
            
            return nil
            
        }
        
        let csv = CSwiftV(with: output_file_string)
        
        
        return csv.keyedRows!
        
    }
    
    //same as the above method, but it returns an array of rows instead of a dictionary.
    private func open_csv_rows(filename:String) -> Array< Array<String> >! {
        
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
        
        
        return csv.rows
        
    }
    
    //The parameter room_type needs to provided to the user from watts_per_sqft.csv (it is in the first column)
    //That way we can guarantee that one choice will match
    private func fluorescent_lighting_watts (model_number:String) -> Int {
        
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
    //Not necessary for MVP you can delete or comment-out this function #Anthony
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
        
        let total_watts = watts * Float(num_lamps) //This should be watts per ballast * number of ballasts #Anthony
        
        return hours_per_year * total_watts
        
    }
    
}





