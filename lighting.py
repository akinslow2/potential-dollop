# Jordan Rosen-Kaplan and Wil Kautz
# Gemini Energy Consulting
# 
# TAKES FROM FRONT END:
# 		Lux and Units-in-Lumens/Foot-Candles
#

import csv

def over_under_lamped(lux, category, units_in_lumens):
	with open("space_unit_levels.csv", "rb") as file:
		reader = csv.reader(file)
		for row in reader:
			if row[0] != category:
				continue
			if lux < int(row[1 if units_in_lumens == "True" else 4]): # Ugly but it's likely gotten stored as a string
				return "Underlighted"
			elif lux > int(row[3 if units_in_lumens == "True" else 6]):
				return "Overlighted"
			else:
				return "Neither under- nor overlighted"


def space_type_conversion(space_type):
	with open("space_type_conversion.csv", "rb") as file:
		reader = csv.reader(file)
		for row in reader:
			if row[0] != space_type:
				continue
			return row[1]


def fluorescent_lighting_watts(model_number):
	in_range = True
	watts = ""
	for char in model_number:
		if not char.isdigit() and in_range:
			in_range = False
			continue
		elif not in_range and not char.isdigit():
			return int(watts)
		else:
			watts += char


# The parameter room_type needs to provided to the user from watts_per_sqft.csv (it is in the first column)
# That way we can guarantee that one choice will match
def light_per_area(watts, room_type, area):
	with open("watts_per_sqft.csv", 'r') as file:
		reader = csv.reader(file)

	watts_per_sqft = float(watts) / area

	for row in reader:
		if room_type != row[0]:
			continue
		if watts_per_sqft > float(row[1]):
			return "Overuse of watts per sqft"
		elif watts_per_sqft < float(row[1]):
			return "Underuse of watts per sqft"
		else:
			return "Meets use of watts per sqft"


def total_energy_calculation_per_light(num_lamps, test_hours, hours_on, watts):
	hours_per_year = float(hours_on) / test_hours * 8760
	total_watts = watts * num_lamps
	return hours_per_year * total_watts
