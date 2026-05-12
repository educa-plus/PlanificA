extends Node

signal date_changed(new_date)

var first_time = true
var current_date = Time.get_date_dict_from_system()

var DAYS_IN_WEEK = 5
var days_of_week = ["Dimanche","Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"]
var days_of_week_abbr = ["D","L","M","M","J","V","S"]
var months = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"]
var months_abbr = ["Janv.", "Févr.", "Mars", "Avril", "Mai", "Juin", "Juill.", "Août", "Sept.", "Oct.", "Nov.", "Déc."]
var levels_abbr = {"Secondaire" : "Sec.", "Primaire" : "Pri."}
#var months_school_order = ["Août", "Septembre", "Octobre", "Novembre", "Décembre", "Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet"]
#var months_abbr_school_order = ["Août", "Sept.", "Oct.", "Nov.", "Déc.","Janv.", "Févr.", "Mars", "Avril", "Mai", "Juin", "Juill."]

var groups_folder_path = []

var sibling_original_size = Vector2.ZERO
var sibling : Node = null
var initial_minimum = null
var is_resizing = false
var separator_id = 0
var _resize_start_global_mouse_pos = Vector2.ZERO

var default_user_planification_dir = ""
var custom_default_user_planification_dir = false
var current_school_year_dir = "user://"
var current_selected_group = ""
var year_string = ""

var is_set_for_the_year: bool = false

#timetable_and_groups
var timetable_cycle = 0
var number_of_period_AM = 2
var number_of_period_PM = 2
var period_duration = []
var period_duration_str = ["00:00\nà\n00:00", "00:00\nà\n00:00", "00:00\nà\n00:00", "00:00\nà\n00:00", "00:00\nà\n00:00"]
var groups = []
var groups_colors = {}
var group_schedules = []

#sequences_informations
var filtered_dict_of_school_days_group = {}
var filtered_dict_of_school_days = {}
var list_of_teacher_workday = []
var list_of_free_day = []
var first_day = {}
var last_day = {}

#global_parameters
var global_parameter_path = "user://global_parameter.tres"
var local_version = ""
var override_current_year: bool = false
var complex_color_activated = false
var show_title_activated = true
var ai_resume_activated = false

func _ready():
	if FileAccess.file_exists(global_parameter_path) :
		var loaded_resource = load(global_parameter_path)
		if loaded_resource is SaveParametersData:
			local_version = loaded_resource.local_version
			complex_color_activated = loaded_resource.complex_color_activated
			show_title_activated = loaded_resource.show_title_activated
			ai_resume_activated = loaded_resource.ai_resume_activated
	else :
		var save_resource = SaveParametersData.new()
		var error = ResourceSaver.save(save_resource, global_parameter_path) # Optionnel: ajouter FLAG_COMPRESS
		if error == OK:
			print("Planification save in : ", global_parameter_path)
	
	var file_path = "user://" + "tree_data" + ".tres"
	if not FileAccess.file_exists(file_path):
		var save_resource = SaveTreeData.new()
		var error = ResourceSaver.save(save_resource, file_path, ResourceSaver.FLAG_COMPRESS) # Optionnel: ajouter FLAG_COMPRESS
		if error == OK:
			print("tree save in : ", file_path)
		else:
			print("Error during the save of : ", file_path, " Erreur: ", error)
	
	if not custom_default_user_planification_dir :
		default_user_planification_dir = getDesktopPath()
		var default_user_dir_access = DirAccess.open(default_user_planification_dir) 
		if default_user_dir_access:
			default_user_dir_access.make_dir_recursive("PlanificA+")
			default_user_planification_dir += "/PlanificA+"
	
	var school_year = time_functions.get_first_school_month(current_date.year, current_date.month)
	year_string = str(school_year.year) + "-" + str(school_year.year + 1)
	current_school_year_dir = "user://" + "school_year_" + year_string
	
	var user_dir_access = DirAccess.open("user://")
	if user_dir_access:
		user_dir_access.make_dir_recursive("school_year_" + year_string)
		user_dir_access.make_dir_recursive("sequences")
		user_dir_access.make_dir_recursive("to_do_list")
		user_dir_access.make_dir_recursive("class_plan_models")
	
	var dir_access = DirAccess.open(current_school_year_dir + "/")
	if dir_access:
		dir_access.make_dir_recursive("agenda_folder")
		dir_access.make_dir_recursive("no_group")
		dir_access.make_dir_recursive("retroaction")
		dir_access.make_dir_recursive("class_plan")
	
	var dir = DirAccess.open(current_school_year_dir)
	dir.list_dir_begin() # Start iterating through the directory's contents
	var file_name = dir.get_next()
	while file_name != "":
		var full_path = current_school_year_dir.path_join(file_name)
		if dir.current_is_dir() and file_name != "agenda_folder" and file_name != "retroaction":
			groups_folder_path.append(full_path)
		file_name = dir.get_next()
	current_date["period"] = 0
	
	if groups_folder_path.size() <= 1 :
		is_set_for_the_year = false
	else :
		is_set_for_the_year = true

	var sequences_file_path = current_school_year_dir + "/" + "sequences_informations.tres"
	if FileAccess.file_exists(sequences_file_path):
		var loaded_resource = load(sequences_file_path)
		if loaded_resource is SaveOptionsData:
			filtered_dict_of_school_days_group = loaded_resource.filtered_dict_of_school_days_group
			filtered_dict_of_school_days = loaded_resource.filtered_dict_of_school_days
			list_of_teacher_workday = loaded_resource.list_of_teacher_workday
			list_of_free_day = loaded_resource.list_of_free_day
			first_day = loaded_resource.first_day
			last_day = loaded_resource.last_day
			is_set_for_the_year = true
	else :
		is_set_for_the_year = false
	
	var timetable_file_path = current_school_year_dir + "/" + "timetable_and_groups.tres"
	if FileAccess.file_exists(timetable_file_path):
		var loaded_resource = load(timetable_file_path)
		if loaded_resource is SaveOptionsData:
			groups = loaded_resource.groups
			groups_colors = loaded_resource.groups_colors
			group_schedules = loaded_resource.group_schedules
			timetable_cycle = loaded_resource.timetable_cycle
			number_of_period_AM = loaded_resource.number_of_period_AM
			number_of_period_PM = loaded_resource.number_of_period_PM
			period_duration = loaded_resource.period_duration
			period_duration_str = []
			print(period_duration)
			for duration in period_duration :
				var dur_str = duration.start + "\n" + "à" + "\n" + duration.end
				period_duration_str.append(dur_str)
			
			is_set_for_the_year = true
	else :
		is_set_for_the_year = false

#This is a copy of _ready() that is called when the setter is complete
func _update_all_value():
	if FileAccess.file_exists(global_parameter_path) :
		var loaded_resource = load(global_parameter_path)
		if loaded_resource is SaveParametersData:
			pass
	else :
		var save_resource = SaveOptionsData.new()
		var error = ResourceSaver.save(save_resource, global_parameter_path) # Optionnel: ajouter FLAG_COMPRESS
		if error == OK:
			print("Planification save in : ", global_parameter_path)
	
	if not custom_default_user_planification_dir :
		default_user_planification_dir = getDesktopPath()
		var default_user_dir_access = DirAccess.open(default_user_planification_dir) 
		if default_user_dir_access:
			default_user_dir_access.make_dir_recursive("PlanificA+")
			default_user_planification_dir += "/PlanificA+"
	
	var school_year = time_functions.get_first_school_month(current_date.year, current_date.month)
	year_string = str(school_year.year) + "-" + str(school_year.year + 1)
	current_school_year_dir = "user://" + "school_year_" + year_string
	
	var user_dir_access = DirAccess.open("user://")
	if user_dir_access:
		user_dir_access.make_dir_recursive("school_year_" + year_string)
	
	var dir_access = DirAccess.open(current_school_year_dir + "/")
	if dir_access:
		dir_access.make_dir_recursive("agenda_folder")
		dir_access.make_dir_recursive("retroaction")
		dir_access.make_dir_recursive("no_group")
		dir_access.make_dir_recursive("class_plan")
	
	var dir = DirAccess.open(current_school_year_dir)
	dir.list_dir_begin() # Start iterating through the directory's contents
	var file_name = dir.get_next()
	while file_name != "":
		var full_path = current_school_year_dir.path_join(file_name)
		if dir.current_is_dir():
			groups_folder_path.append(full_path)
		file_name = dir.get_next()
	
	if groups_folder_path.size() <= 1 :
		is_set_for_the_year = false
	else :
		is_set_for_the_year = true
	
	current_date["period"] = 0
	
	var sequences_file_path = current_school_year_dir + "/" + "sequences_informations.tres"
	if FileAccess.file_exists(sequences_file_path):
		var loaded_resource = load(sequences_file_path)
		if loaded_resource is SaveOptionsData:
			filtered_dict_of_school_days_group = loaded_resource.filtered_dict_of_school_days_group
			filtered_dict_of_school_days = loaded_resource.filtered_dict_of_school_days
			list_of_teacher_workday = loaded_resource.list_of_teacher_workday
			list_of_free_day = loaded_resource.list_of_free_day
			first_day = loaded_resource.first_day
			last_day = loaded_resource.last_day
			is_set_for_the_year = true
	else :
		is_set_for_the_year = false
	
	var timetable_file_path = current_school_year_dir + "/" + "timetable_and_groups.tres"
	if FileAccess.file_exists(timetable_file_path):
		var loaded_resource = load(timetable_file_path)
		if loaded_resource is SaveOptionsData:
			groups = loaded_resource.groups
			groups_colors = loaded_resource.groups_colors
			group_schedules = loaded_resource.group_schedules
			timetable_cycle = loaded_resource.timetable_cycle
			number_of_period_AM = loaded_resource.number_of_period_AM
			number_of_period_PM = loaded_resource.number_of_period_PM
			period_duration = loaded_resource.period_duration
			period_duration_str = []
			for duration in period_duration :
				var dur_str = duration.start + "\n" + "à" + "\n" + duration.end
				period_duration_str.append(dur_str)
			
			is_set_for_the_year = true
	else :
		is_set_for_the_year = false

func emit_date_changed_signal():
	emit_signal("date_changed", current_date)
		
func _on_separator_input(event, separator):
	var parent_node = separator.get_parent()  # Get the parent of the resize_handle
	var last_child = null
	

	var current_global_mouse_pos = get_viewport().get_mouse_position()
	var delta = current_global_mouse_pos - _resize_start_global_mouse_pos
	
	if event is InputEventMouseMotion:
		if separator is VSeparator:
			separator.mouse_default_cursor_shape = Control.CURSOR_HSIZE
		if separator is HSeparator:
			separator.mouse_default_cursor_shape = Control.CURSOR_VSIZE
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_resizing = event.pressed
			 # Start or stop resizing
			_resize_start_global_mouse_pos = get_viewport().get_mouse_position()
			
			sibling_original_size = Vector2.ZERO # restart original size
			sibling = null
			initial_minimum = null
			
			if parent_node:
				# Loop through all children of the parent node
				var children = parent_node.get_children()
				for i in range(children.size()):
					var child = children[i]
					if child == separator:
						separator_id = i
						sibling = last_child  # The last visited child is the one above the separator
						initial_minimum = sibling.size.x - 5 # 5 is only a security threshold
						
						break  # Stop searching once we found the separator
					last_child = child  # Update last_child before moving to the next one
				sibling_original_size = sibling.size
				
	if event is InputEventMouseMotion and is_resizing:
		# Calculate new size based on mouse position
		var left_node = parent_node.get_child(separator_id - 1)
		var sub_left_node = null

		var right_node = parent_node.get_child(separator_id + 1)
		var sub_right_node = null
		var minimum_left = left_node.get_minimum_size()
		var minimum_right = right_node.get_minimum_size()
		
		var minimum_ratio = 0
		
		if left_node is Control and left_node is not Tree:
			sub_left_node = left_node.get_child(0)
			minimum_left = sub_left_node.get_minimum_size()
			minimum_ratio = 0.6
			
		if right_node is Control and right_node is not Tree:
			sub_right_node = right_node.get_child(0)
			minimum_right = sub_right_node.get_minimum_size()
			if minimum_right.x < 200 :
				minimum_right = Vector2(200.0 , 31.0)
			
		var new_x_size = sibling_original_size.x + delta.x
		var new_ratio = new_x_size / parent_node.size.x
		
		#if left_node is Control :
		#	minimum_left.x += 200
		if separator is VSeparator :
			if delta.x > 0 and right_node.size.x > minimum_right.x and new_ratio > minimum_ratio:
				
				left_node.size_flags_stretch_ratio = new_ratio
				right_node.size_flags_stretch_ratio = 1.0 - new_ratio
				#left_node.custom_minimum_size.x = new_x_size #Éventuellement améliorer pour prendre en compte l'espacement
			elif delta.x < 0 and new_x_size >= minimum_left.x and new_ratio > minimum_ratio:
				left_node.size_flags_stretch_ratio = new_ratio
				right_node.size_flags_stretch_ratio = 1.0 - new_ratio
				#left_node.custom_minimum_size.x = new_x_size #Éventuellement améliorer pour prendre en compte l'espacement
				#if left_node.custom_minimum_size.x < initial_minimum :
				#	left_node.set_h_size_flags(Control.SIZE_SHRINK_BEGIN)
		if separator is HSeparator:
			left_node.custom_minimum_size.y = sibling_original_size.y + delta.y

func getDesktopPath():	# gets path to user desktop documents
	var ret = ""
	var slashes = 0
	for i in OS.get_user_data_dir():
		if i == "/":
			slashes += 1
		if slashes == 3:
			return ret + "/Documents"
		else:
			ret += i
			
func _find_all_files_in_dir(path: String):
	var dir_access = DirAccess.open(path)

	if dir_access:
		var files: PackedStringArray = []
		
		# Start listing directory contents
		dir_access.list_dir_begin()
		var file_name = dir_access.get_next()

		while file_name != "":
			# Exclude "." and ".." entries
			if file_name != "." and file_name != "..":
				if not dir_access.current_is_dir():
					files.append(file_name)
			file_name = dir_access.get_next()

		dir_access.list_dir_end()
		return files
			
func delete_directory_recursive(path: String) -> int:
	var dir = DirAccess.open(path)

	if dir == null:
		print("Error: Could not open directory at path: " + path)
		return ERR_FILE_NOT_FOUND

	var files = dir.get_files()
	for file_name in files:
		var file_path = path.path_join(file_name)
		var f_error = DirAccess.remove_absolute(file_path)
		if f_error != OK:
			print("Error deleting file: " + file_path + " - Error code: " + str(f_error))
			return f_error

	var directories = dir.get_directories()
	for dir_name in directories:
		var subdir_path = path.path_join(dir_name)
		var s_error = delete_directory_recursive(subdir_path) # Recursive call
		if s_error != OK:
			return s_error

	# After all contents are deleted, remove the directory itself
	var d_error = DirAccess.remove_absolute(path)
	if d_error != OK:
		print("Error deleting directory: " + path + " - Error code: " + str(d_error))
	else:
		print("Successfully deleted directory: " + path)

	return d_error
