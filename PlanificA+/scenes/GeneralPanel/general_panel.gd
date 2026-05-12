extends Control

@onready var month_calendar_node = $Everything/EveryThing/MonthLabelMargin/MonthCalendar
@onready var label_and_button_calendar_node = $Everything/EveryThing/MonthLabelMargin/MonthCalendar/LabelAndButton
@onready var month_label_node = $Everything/EveryThing/MonthLabelMargin/MonthCalendar/LabelAndButton/MonthPanel/Month
@onready var group_manager_node = $Everything/EveryThing/ScrollContainer/GroupManagerPanel/GroupManager


var today = Time.get_date_dict_from_system()
var month_font_size = 10
var current_month = 0
var current_year = 0
var month_grid = null

func _ready():
	var date = global_variables.current_date
	var year = date.year
	var month = date.month
	current_month = month
	current_year = year

	populate_month_calendar(date)
	populate_group_manager()
	
func _update_general_panel():
	var date = global_variables.current_date
	var year = date.year
	var month = date.month
	current_month = month
	current_year = year
	populate_month_calendar(date)
	
	for child in group_manager_node.get_children():
		child.queue_free()
	populate_group_manager()
	
func populate_month_calendar(date):
	for child in month_calendar_node.get_children():
		if child != label_and_button_calendar_node :
			child.queue_free()
	
	var year = date.year
	var month = date.month
	var month_calendar = time_functions.get_calendar_month(year, month, true, true)
	var month_container = _add_month_grid_container(month, year)
	
	# If "Show week numbers" is ON an empty space has to be added before the weekday names
	for weekday in global_variables.days_of_week_abbr:
		var weekday_label = Label.new()

		weekday_label.add_theme_font_size_override("font_size", month_font_size)
		weekday_label.text = weekday
		weekday_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		weekday_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		month_container.add_child(weekday_label)
	
	for week in month_calendar:
		for day in week:
			
			var date_button: Button
			if date.month == month:
				date_button = Button.new()
				date_button.theme = load("res://_theme/button-calendar-gray.tres")
				
				if global_variables.list_of_free_day.has(day):
					date_button.theme = load("res://_theme/button-calendar-green.tres")
				
				if global_variables.list_of_teacher_workday.has(day):
					date_button.theme = load("res://_theme/button-calendar-yellow.tres")
				
				var first_day = global_variables.first_day.duplicate()
				first_day.erase("jour")
				if day == first_day :
					date_button.theme = load("res://_theme/button-calendar-first.tres")
				date_button.text = str(day.day)
				
				var last_day = global_variables.last_day.duplicate()
				last_day.erase("jour")
				if day == last_day :
					date_button.theme = load("res://_theme/button-calendar-last.tres")
				date_button.text = str(day.day)


			date_button.add_theme_font_size_override("font_size", month_font_size)
			month_container.add_child(date_button)
			
			# if date.is_equal(selected_date):
				# set_selected_state(date_label)

func _add_month_grid_container(month, year):
	var container_padding = MarginContainer.new()
	container_padding.set("theme_override_constants/margin_left", 10)
	container_padding.set("theme_override_constants/margin_right", 10)
	container_padding.set("theme_override_constants/margin_top", 10)
	container_padding.set("theme_override_constants/margin_bottom", 10)
	
	# var title_string = "%s, %s" % [months_formatted[p_month - 1], year]
	month_label_node.text = global_variables.months[month - 1] + " " + str(year)
	month_label_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	# month_title.label_settings.font_color = Color("#ffffff")
	
	month_grid = GridContainer.new()
	month_grid.columns = 7
	month_grid.set("theme_override_constants/h_separation", 6)
	month_grid.set("theme_override_constants/v_separation", 6)
	month_grid.size_flags_horizontal = SIZE_SHRINK_CENTER
	#month_container.add_child(month_grid)
	#container_padding.add_child(month_container)
	#$Panel.add_child(container_padding)
	month_calendar_node.add_child(month_grid)
	return month_grid

func populate_group_manager():
	var current_directory = global_variables.current_school_year_dir
	var filename = "timetable_and_groups"
	var file_path = current_directory + "/" + filename + ".tres"
	if FileAccess.file_exists(file_path):
		var loaded_resource = load(file_path)
		for group in loaded_resource.groups :
			var level_abbr = global_variables.levels_abbr[group.level]
			var group_code = group.name + " " + group.level + " " + group.year
			var group_code_abbr = group.name + " " + level_abbr + " " + group.year
			var Vcontainer = VBoxContainer.new()
			var Hcontainer = HBoxContainer.new()
			var Mcontainer = MarginContainer.new()
			var color_picker = ColorPickerButton.new()
			color_picker.size_flags_horizontal = SIZE_SHRINK_END | SIZE_EXPAND
			color_picker.custom_minimum_size.x = 20
			color_picker.color = loaded_resource.groups_colors[group_code]
			color_picker.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			color_picker.picker_created.connect(_on_color_picker_created.bind(color_picker, group))
			var group_label = Label.new()

			group_label.text = group_code_abbr
			
			var courses_progress_bar = ProgressBar.new()
			courses_progress_bar.show_percentage = false
			courses_progress_bar.custom_minimum_size.y = 16
			var courses_left_label = Label.new()
			courses_left_label.add_theme_font_size_override("font_size", 12)
			courses_left_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			var files_and_dirs: PackedStringArray = []
			var last_period = time_functions._find_last_period_of_current_time()
			var formatted_today = "%04d-%02d-%02d-%01d" % [today.year, today.month, today.day, last_period]
			var school_year_path = global_variables.current_school_year_dir
			var path = school_year_path + "/" + group_code
			print(path)
			var planification_dir_access = DirAccess.open(path)
			var planification_left_list = []
			var planification_list = []
				
			if planification_dir_access:
				# Start listing directory contents
				planification_dir_access.list_dir_begin()
				var file_name = planification_dir_access.get_next()
					
				while file_name != "":
					# Exclude "." and ".." entries
					if file_name != "." and file_name != ".." and file_name != "copy" and file_name != "delete":
						var file_date = file_name.trim_prefix("planification_")
						file_date = file_date.trim_suffix(".tres")
						var planification_date = file_date.substr(0, file_date.length() - 2) #short_date don't have the period so it is easier to compare
							
						#We don't want the files before the selected day
						planification_list.append(file_name)
						if planification_date >= formatted_today :
							planification_left_list.append(file_name)
					file_name = planification_dir_access.get_next()

				planification_dir_access.list_dir_end()
			
			var courses_left = planification_left_list.size()
			var courses_total = planification_list.size()
			print(courses_left)
			courses_left_label.text = "Cours restants: " + str(courses_left)
			courses_progress_bar.max_value = courses_total
			courses_progress_bar.value = courses_total - courses_left
			
			Hcontainer.add_child(group_label)
			Hcontainer.add_child(color_picker)
			Mcontainer.add_child(courses_progress_bar)
			Mcontainer.add_child(courses_left_label)
			Vcontainer.add_child(Hcontainer)
			Vcontainer.add_child(Mcontainer)
			
			group_manager_node.add_child(Vcontainer)

func _on_color_picker_created(color_picker_button, group):
	var picker: ColorPicker = color_picker_button.get_picker()
	if global_variables.complex_color_activated == false :
		picker.edit_alpha = false          # Hide the alpha slider
		picker.color_modes_visible = false # Hide RGB/HSV/Hex toggles
		picker.presets_visible = false     # Hide the preset colors section
		picker.picker_shape = ColorPicker.SHAPE_HSV_WHEEL
		picker.sliders_visible = false # Hide Hue slider
	picker.connect("color_changed", _on_group_color_changed.bind(group))
	
func _on_group_color_changed(color,group):
	var group_code = group.name + " " + group.level + " " + group.year
	global_variables.groups_colors[group_code] = color
	var timetable_and_groups_path = global_variables.current_school_year_dir + "/" + "timetable_and_groups.tres"
	var timetable_and_groups = null
		#If the file don't exist, the result will be null
	if FileAccess.file_exists(timetable_and_groups_path):
		timetable_and_groups = ResourceLoader.load(timetable_and_groups_path)
	timetable_and_groups.groups_colors = global_variables.groups_colors
	var save_error = ResourceSaver.save(timetable_and_groups, timetable_and_groups_path) # Optionnel: ajouter FLAG_COMPRESS
	if save_error != OK:
		print("Error during the save of : ", timetable_and_groups_path, " Erreur: ", save_error)
	else :
		print("Succesfully save: ", timetable_and_groups_path)
	#var agenda_display_scene = load("res://scenes/Agenda/AgendaDisplay.tscn").instantiate()
	var main_scene_node = get_tree().current_scene
	main_scene_node._update_agenda()
	#planif_button.emit_signal("pressed")
	#print(group_code)
	
func _on_previous_month_pressed() -> void:
	current_month -= 1
	if current_month == 0:
		current_year -= 1
		current_month = 12
	var date = {"year": current_year, "month": current_month, "day": 1}
	month_calendar_node.remove_child(month_grid)
	month_grid.queue_free()
	populate_month_calendar(date)
	
func _on_next_month_pressed() -> void:
	current_month += 1
	if current_month > 12:
		current_year += 1
		current_month = 1
	var date = {"year": current_year, "month": current_month, "day": 1}
	month_calendar_node.remove_child(month_grid)
	month_grid.queue_free()
	populate_month_calendar(date)
	
func _on_group_text_submitted(text, line_edit, id):
	var new_group_label = Label.new()
	new_group_label.text = text
	group_manager_node.remove_child(line_edit)
	line_edit.queue_free()
	group_manager_node.add_child(new_group_label)
	group_manager_node.move_child(new_group_label, id)
	global_variables.groups.append(text)


	
	
