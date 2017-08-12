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

			if units_in_lumens:
				if lux < int(row[1]):
					return "Underlighted"
				elif lux > int(row[3]):
					return "Overlighted"
				else:
					return "Perfect"

			else: 
				if lux < int(row[4]):
					return "Underlighted"
				elif lux > int(row[6]):
					return "Overlighted"
				else:
					return "Perfect"


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

#This might have to change to incorporate different instances of lighting in 
#one room, but we will change that later
def area_energy_calculation(num_lamps_per_fixture, num_fixtures, watts, area):
	return float(watts * num_fixtures * num_lamps_per_fixture) / area


def total_energy_calculation(num_lamps_per_fixture, num_fixtures, test_hours, hours_on, watts):
	hours_per_year = float(hours_on) / test_hours * 8760
	total_watts = watts * num_fixtures * num_lamps_per_fixture
	return hours_per_year * total_watts


def main():
	
	watts = fluorescent_lighting_watts("F32T10")
	#over_under_lamped(-, space_type_conversion(-), -)


if __name__ == '__main__':
	main()
