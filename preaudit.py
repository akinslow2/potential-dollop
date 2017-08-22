# Pre-Audit
# Jordan Rosen-Kaplan and Wil Kautz
# 21 August 2017
# Gemini Energy Audits

import sys
import auditheader.py # Not sure about this syntax

# This is where we should collect the initial pre-audit parameters
def collect_preaudit_parameters(outputs):
	outputs["business_name"] = None
	outputs["business_address"] = None
	outputs["client_interviewed_name"] = None
	outputs["client_interviewed_position"] = None
	outputs["main_client_name"] = None
	outputs["main_client_position"] = None
	outputs["main_client_email"] = None
	outputs["main_client_phone number"] = None
	outputs["total_square_footage"] = None
	outputs["facility_type"] = None
	outputs["age_of_building"] = None
	outputs["age_of_lighting"] = None
	outputs["age_of_lighting_controls"] = None
	outputs["age_of_hvac"] = None
	outputs["age_of_hvac_controls"] = None
	outputs["age_of_kitchen_equipment"] = None
	outputs["lighting_maintenance_interval"] = None
	outputs["hvac_maintenance_interval"] = None
	outputs["kitchen_equipment_maintenance_interval"] = None
	outputs["upgrades_budget"] = None
	outputs["expected_roi"] = None
	outputs["utility_company"] = None
	outputs["rate_structure_electric"] = None
	outputs["rate_structure_gas"] = None
	outputs["date_of_interview"] = None
	outputs["auditors_names"] = {}
	outputs["notes"] = None


# Note for Wil: parameters are passed by reference if they're mutable and copy if not
# If passed by reference, you can call member functions on the object and it will remain out of scope
# (i.e. if x is a list[], x.append())
# but you can't reassign
# (i.e. x = [1, 2, 3])

def preaudit():
	if len(sys.argv) != 2:
		raise AssertionError("format: --> python audit.py \"name\"")

	preaudit = Audit(sys.argv[1])

	collect_preaudit_parameters(preaudit.outputs)

	preaudit.save()
