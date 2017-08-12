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



def main():
	over_under_lamped(-, -, -)


if __name__ == '__main__':
	main()
