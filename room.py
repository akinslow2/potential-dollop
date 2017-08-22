# Room Class Definition
# Jordan Rosen-Kaplan and Wil Kautz
# 21 August 2017
# Gemini

import lighting.py # Again, not sure on the syntax of this...

class Room:

	"""A class that represents an individual room"""

	# Constructor
	def __init__(self, room_name):

		lighting = set()
		hvac = set()
		plug_load = set()
		kitchen_equipment = set()
		name = room_name

###################################################################################################################################################


	# Parameters here have to be supplied by the user or the Swift code
	# Note: the parameter "values" is a dictionary
	# The required keys vary, depending on the object. 
	# Lighting (if not lighting_finished): "model_number", "number_of_lamps":(INT), "length", "max_width", "test_hours":(INT), "hours_on":(INT), "control_type"
	# Lighting (if lighting_finished): (above keys), "measured_lux", "space_type(->category: A, B, C, etc.)", "room_type", "room_area":(FLOAT), "units_in_lumens":(Boolean)
	# HVAC:
	# Kitchen:
	# Plug:
	
	def new_feature(outputs, feature_type, values, lighting_finished):
		if feature_type == "Lighting":
			__add_light_feature(values)

			if lighting_finished:
				__compute_lighting_specs(values)

		elif feature_type == "HVAC":
			__add_hvac_feature(values)

		elif feature_type == "Kitchen Equipment":
			__add_kitchen_feature(values)

		elif feature_type == "Plug Load":
			__add_plug_feature(values)


	def __add_light_feature(values):
		watts = fluorescent_lighting_watts(values["model_number"])
		energy = total_energy_calculation_per_light(int(values["model_number"]), int(alues["test_hours"]), int(values["hours_on"]), watts)

		# It looks like they want a lot of other features here (color temp, lamp type, lumens, etc.)

		lighting.add({"watts": watts, "energy": energy})

	def __compute_lighting_specs(values):
		under_over_lighted = over_under_lamped(values["measured_lux"], space_type_conversion(values["space_type"]), values["units_in_lumens"])

		total_watts = 0
		for light in lighting:
			total_watts += light["watts"]

		watts_usage_per_sqft = light_per_area(total_watts, values["room-type"], float(values["room_area"]))

		lighting.add({"watts_usage_per_sqft":, watts_usage_per_sqft, "under_over_lighted": under_over_lighted})

	def __add_hvac_feature(values):
		pass

	def __add_kitchen_feature(values):
		pass

	def __add_plug_features(values):
		pass

 
###################################################################################################################################################

	# This writes the features of a room back to the outputs dictionary
	def save_room(outputs):

		__save_type(outputs, lighting, "lighting")
		__save_type(outputs, hvac, "hvac")
		__save_type(outputs, plug_load, "plugload")
		__save_type(outputs, kitchen_equipment, "kitchen")


	def __save_type(outputs, curr_set, name):
		item_number = 0
		for item in curr_set:

			unique_key = "%s_%s_%d" % (room_name, name, item_number)
			outputs[unique_key] = item

			item_number += 1





