# Audit Class Definition
# Jordan Rosen-Kaplan and Wil Kautz
# 21 August 2017
# Gemini

import ast, os

class Audit:

	"""A class that represents an individual audit process"""

	# Constructor
	def __init__(self, audit_name):
		outputs = {}
		filename = "%s.txt" % audit_name # Not exactly sure about the formatting (.csv, etc.)

		try:
			abs_path = filename.resolve() # Tries to complete the path name

		except FileNotFoundError:
			abs_path = ""

		if abs_path != "":
			__load_saved_outputs()
		else:
			abs_path = "%s/%s" % (os.path.dirname(os.path.realpath(__file__)), filename)

		return


	def save():
		with open(abs_path, "w") as file:
			file.write(str(outputs))


	def retrieve():
		__load_saved_outputs()


	def __load_saved_outputs(): # There is no such thing as private methods :/ so this my way of making it different/unlikely to be called
		with open(abs_path, "r") as saved_file:
			saved_outputs = saved_file.read()
			outputs = ast.literal_evals(saved_outputs)

	def return_outputs():
		return outputs
