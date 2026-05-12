extends Control

@onready var name_selector = %GroupNameSelector
@onready var level_selector = %GroupLevelSelector
@onready var year_selector = %GroupYearSelector
@onready var subject_selector = %GroupSubjectSelector
@onready var timetable_cycle_button = $PreliminaryPanel/PreliminaryMargin/PreliminarySelector/NumTimetableSelector/NumTimetable
@onready var num_period_AM_button = $PreliminaryPanel/PreliminaryMargin/PreliminarySelector/NumPeriodSelector/NumPeriodAM/NumPeriod
@onready var num_period_PM_button = $PreliminaryPanel/PreliminaryMargin/PreliminarySelector/NumPeriodSelector/NumPeriodPM/NumPeriod
@onready var school_year_button = $PreliminaryPanel/PreliminaryMargin/PreliminarySelector/SchoolYearSelector/SchoolYear

@onready var error_label = $ErrorLabel
@onready var time_modifier = $TimeModifierPanel

@onready var timetable_scroll_container = %TimetableScrollContainer
@onready var timetable = %TimeTable

@onready var primary_theme = load("res://_theme/button-primary.tres")

@onready var selectors = [name_selector, level_selector, year_selector, subject_selector]

var level_option = ["Primaire", "Secondaire"]
var year_option = {"Primaire":["1","2","3","4","5","6"], "Secondaire":["1","2","3","4","5"]}


var subject_primary = GouvDocumentation.sujet_domaine_apprentissage_primaire

var subject_secondary_first_cycle = GouvDocumentation.sujets_premier_cycle_domaine_apprentissage_secondaire  
var subject_secondary_second_cycle = GouvDocumentation.sujets_deuxieme_cycle_domaine_apprentissage_secondaire

var option_dict = {
	"Primaire":{
		"1":subject_primary,
		"2":subject_primary,
		"3":subject_primary,
		"4":subject_primary,
		"5":subject_primary,
		"6":subject_primary
		},
	"Secondaire":{
		"1":subject_secondary_first_cycle,
		"2":subject_secondary_first_cycle,
		"3":subject_secondary_second_cycle,
		"4":subject_secondary_second_cycle,
		"5":subject_secondary_second_cycle
		}
	}

var num_period_AM = 0
var num_period_PM = 0
var max_num_period = 6
var timetable_cycle = null
var max_timetable_cycle = 20
var max_lenth_group_name = 8
var max_group_num = 20

var group_count = 1
var groups = []
var groups_colors = {}
var group_schedules = []
var note_schedule_dict = {}
var period_duration = []

var today = Time.get_datetime_dict_from_system()

var current_month = global_variables.current_date.month
var current_year = global_variables.current_date.year
var current_school_date = {"year": current_year, "month": current_month}
var school_year_name = ""

var min_size_v = 75
var min_size_h = 150

var first_time_next = 0

func _ready() -> void:
	var school_year = time_functions.get_first_school_month(current_school_date.year, current_school_date.month)
	var first_year_string = str(school_year.year) + "-" + str(school_year.year + 1)
	var second_year_string = str(school_year.year + 1) + "-" + str(school_year.year + 2)
	school_year_button.add_item(first_year_string)
	school_year_button.add_item(second_year_string)
	
	timetable_cycle_button.connect("item_selected", _on_item_selected.bind(timetable_cycle_button))
	var idx = level_selector.get_child_count() - 1
	var level_button = level_selector.get_child(idx)
	for option in level_option:
		level_button.add_item(option)
	level_button.select(-1)
	level_button.connect("item_selected", _on_level_chose.bind(idx, level_button))
	
	subject_primary.sort()
	subject_secondary_first_cycle.sort()
	subject_secondary_second_cycle.sort()
	
func _on_item_selected(id, button):
	var total_item = button.get_item_count()
	var selected = button.get_item_text(id)
	
	if id == total_item - 1:
		var parent = button.get_parent()
		parent.remove_child(button)
		var line_edit = LineEdit.new()
		line_edit.size_flags_horizontal = Control.SIZE_SHRINK_END | Control.SIZE_EXPAND
		line_edit.connect("focus_exited", _on_text_submitted.bind(line_edit, button, parent))
		parent.add_child(line_edit)
		line_edit.grab_focus()
	else:
		if button == timetable_cycle_button:
			timetable_cycle = selected

func _on_text_submitted(line_edit, button, parent):
	var text = line_edit.text
	var text_is_int = text.is_valid_int()
	var int_is_good = false
	if not text_is_int :
		_get_message_to_the_user("La valeur entrée\ndoit être un nombre")
	else :
		int_is_good = int(text) <= max_timetable_cycle
		if not int_is_good :
			_get_message_to_the_user("La valeur entrée\nest trop haute\nmax = " + str(max_timetable_cycle))

	line_edit.queue_free()
	parent.add_child(button)
	button.remove_item(button.get_item_count() - 1)
	if int_is_good :
		button.add_item(text)
	button.add_item("Autre")
	button.select(button.get_item_count() - 2)


func _get_message_to_the_user(message):
	#match emplacement:
	#	"top_right":
	#		coordinate = Vector2(node.get_screen_position().x + node.size.x + 30, node.get_screen_position().y)
	#	"bottom_left":
	#		coordinate = Vector2(node.get_screen_position().x, node.get_screen_position().y + node.size.y)
	error_label.show_and_fade(message, get_global_mouse_position())

func _on_new_group_pressed() -> void:
	group_count += 1
	if name_selector.get_child_count() <= max_group_num:
		print(group_count)
		for selector_node in selectors:
			match selector_node: # Match on the node instance itself
				name_selector:
					print("--- Processing Name Selector ---")
					var new_group_name = LineEdit.new()
					new_group_name.name = "Group" + str(group_count)
					new_group_name.max_length = max_lenth_group_name
					name_selector.add_child(new_group_name)
					var id = name_selector.get_children().size() - 2
					name_selector.move_child(new_group_name, id)
					
				level_selector:
					print("--- Processing Level Selector ---")
					var new_option_button = OptionButton.new()
					new_option_button.name = "Group" + str(group_count)
					new_option_button.theme = primary_theme
					new_option_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
					new_option_button.custom_minimum_size.y = 40
					level_selector.add_child(new_option_button)
					for key in option_dict.keys():
						new_option_button.add_item(key)
					new_option_button.select(-1)
					var idx = level_selector.get_child_count() - 1
					new_option_button.connect("item_selected", _on_level_chose.bind(idx, new_option_button))
					
				year_selector:
					print("--- Processing Year Selector ---")
					var new_option_button = OptionButton.new()
					new_option_button.name = "Group" + str(group_count)
					new_option_button.theme = primary_theme
					new_option_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
					new_option_button.custom_minimum_size.y = 40
					year_selector.add_child(new_option_button)
					new_option_button.add_item(" ")
					
				subject_selector:
					print("--- Processing Subject Selector ---")
					var new_option_button = OptionButton.new()
					new_option_button.name = "Group" + str(group_count)
					new_option_button.theme = primary_theme
					new_option_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
					new_option_button.custom_minimum_size.y = 40
					subject_selector.add_child(new_option_button)
					new_option_button.add_item(" ")
				_: # Default case if a selector in the array doesn't match any of the above
					print("--- Encountered an unknown selector: ", selector_node.name, " ---")
	else:
		_get_message_to_the_user("Nombre maximum de groupe atteint")

func _on_delete_group_pressed() -> void:
	group_count -= 1
	var idx = 0
	if name_selector.get_child_count() >= 4:
		for selector_node in selectors:
			if selector_node == name_selector:
				idx = selector_node.get_child_count() - 2
			else:
				idx = selector_node.get_child_count() - 1
			var node = selector_node.get_child(idx)
			node.queue_free()
	else:
		_get_message_to_the_user("Vous devez inscrire au moins un groupe")

func _on_level_chose(id, idx, level_button):
	var year_button = year_selector.get_child(idx)
	var level = level_button.get_item_text(id)
	var years = option_dict[level].keys()
	year_button.clear()
	for year in years:
		year_button.add_item(year)
	year_button.select(-1)
	year_button.connect("item_selected", _on_year_selected.bind(idx, level, year_button))
	
func _on_year_selected(id, idx, level, year_button):
	var subject_button = subject_selector.get_child(idx)
	subject_button.clear()
	var year = year_button.get_item_text(id)
	#var subjects = option_dict[level][year]
	#for subject in subjects:
	#	subject_button.add_item(subject)
		
	var subjects = GouvDocumentation.domaine_apprentissage_dict[level]
	subjects.sort()
	
	for subject in subjects:
		var subject_dict = subjects[subject]
		if subject_dict.has(year) :
			subject_button.add_item(subject)
	subject_button.select(-1)

func _on_next_button_pressed() -> void:
	var go_forward = true
	for i in group_count:
		var group = {"name": "", "level": "", "year": "", "subject": ""}
		
		var group_name_node = name_selector.get_child(i + 1)
		group.name = group_name_node.text
		
		var group_level_node = level_selector.get_child(i + 1)
		if group_level_node.selected != -1 :
			group.level = group_level_node.get_item_text(group_level_node.selected)
		else:
			go_forward = false
			
		var group_year_node = year_selector.get_child(i + 1)
		if group_year_node.selected != -1 :
			group.year = group_year_node.get_item_text(group_year_node.selected)
		else:
			go_forward = false
			
		var group_subject_node = subject_selector.get_child(i + 1)
		if group_subject_node.selected != -1 :
			group.subject = group_subject_node.get_item_text(group_subject_node.selected)
		else:
			go_forward = false
		
		if group.name == "" or group.level == "" or group.year == "" or group.subject == "" :
			go_forward = false
		
		if timetable_cycle_button.selected == -1 or num_period_AM_button.selected == -1 or num_period_PM_button.selected == -1:
			go_forward = false
		else:
			timetable_cycle = int(timetable_cycle_button.get_item_text(timetable_cycle_button.selected))
			num_period_AM = int(num_period_AM_button.get_item_text(num_period_AM_button.selected))
			num_period_PM = int(num_period_PM_button.get_item_text(num_period_PM_button.selected))
			school_year_name = school_year_button.get_item_text(school_year_button.selected)
		if go_forward:
			groups.append(group)
			var group_code = group.name + " " + group.level + " " + group.year
			groups_colors[group_code] = Color(1,1,1,1)
			
	if go_forward :
		first_time_next += 1
		#print(first_time_next)
		timetable_scroll_container.show()
		$PreliminaryPanel.hide()
		_populate_timetable()
	else:
		_get_message_to_the_user("Veuillez remplir toutes les cases")

func _populate_timetable():
	# var num_column = num_period_AM + num_period_PM + 2
	var cycle_container = _populate_first_column()
	timetable.add_child(cycle_container)
	
	timetable.add_child(VSeparator.new())
	var morning_container = _populate_note_column("Matin")
	timetable.add_child(morning_container)
	
	for period in num_period_AM:
		var period_container = _populate_period_column()
		timetable.add_child(VSeparator.new())
		timetable.add_child(period_container)
		
	timetable.add_child(VSeparator.new())
	var noon_container = _populate_note_column("Midi")
	timetable.add_child(noon_container)
	
	for period in num_period_PM:
		var period_container = _populate_period_column()
		timetable.add_child(VSeparator.new())
		timetable.add_child(period_container)
		
	timetable.add_child(VSeparator.new())
	var evening_container = _populate_note_column("Soir")
	timetable.add_child(evening_container)

func _populate_first_column():
	var container = VBoxContainer.new()
	var count = 1
	var empty_label = Label.new()
	empty_label.custom_minimum_size = Vector2(min_size_h, min_size_v)
	empty_label.text = ""
	container.add_child(empty_label)
	container.add_child(HSeparator.new())
	
	for day in timetable_cycle:
		var label = Label.new()
		label.custom_minimum_size = Vector2(min_size_h, min_size_v)
		label.text = "Jour " + str(count)
		container.add_child(label)
		if count != timetable_cycle:
			var separator = HSeparator.new()
			container.add_child(separator)
		count += 1
	return container
		
func _populate_period_column():
	var period_container = VBoxContainer.new()
	
	var time_period_container = HBoxContainer.new()
	time_period_container.alignment = BoxContainer.ALIGNMENT_CENTER
	time_period_container.custom_minimum_size = Vector2(min_size_h, min_size_v)
	var first_button = Button.new()
	first_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	first_button.text = "00:00"
	first_button.connect("pressed", _on_time_pressed.bind(first_button))
	var second_button = Button.new()
	second_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	second_button.text = "00:00"
	second_button.connect("pressed", _on_time_pressed.bind(second_button))
	var between_label = Label.new()
	between_label.text = "à"
	
	time_period_container.add_child(first_button)
	time_period_container.add_child(between_label)
	time_period_container.add_child(second_button)
	period_container.add_child(time_period_container)
	
	for day in timetable_cycle:
		var V_container = VBoxContainer.new()
		V_container.custom_minimum_size = Vector2(min_size_h, min_size_v)
		var H_container = HBoxContainer.new()
		var option_button = OptionButton.new()
		option_button.theme = load("res://_theme/button-primary.tres")
		option_button.add_item("", -1)
		for group in groups:
			var group_code = group.name + " " + group.level + " " + group.year
			option_button.add_item(group_code)
		period_container.add_child(HSeparator.new())
		option_button.selected = -1
		
		var label = Label.new()
		label.text = "Local: "
		label.add_theme_font_size_override("font_size", 10)
		var line_edit = LineEdit.new()
		line_edit.add_theme_font_size_override("font_size", 10)
		line_edit.max_length = 6
		H_container.add_child(label)
		H_container.add_child(line_edit)
		V_container.add_child(option_button)
		V_container.add_child(H_container)
		period_container.add_child(V_container)
	return period_container

func _populate_note_column(text: String):
	var note_container = VBoxContainer.new()
	note_container.set_v_size_flags(Control.SIZE_EXPAND | Control.SIZE_FILL)
	
	var label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.custom_minimum_size = Vector2(min_size_h, min_size_v)
	label.text = text
	note_container.add_child(label)
	
	for day in timetable_cycle:
		var text_edit = TextEdit.new()
		text_edit.custom_minimum_size = Vector2(min_size_h, min_size_v)
		text_edit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
		text_edit.text_changed.connect(func(): _timetable_update_size(text_edit))
		#text_edit.set_h_size_flags(Control.SIZE_EXPAND | Control.SIZE_FILL)
		note_container.add_child(HSeparator.new())
		note_container.add_child(text_edit)
	return note_container

func _on_time_pressed(button):
	time_modifier.show()
	
	var coordinate = get_global_mouse_position()
	time_modifier.set_position(coordinate)
	time_modifier.set_button(button)

func _on_next_pressed() -> void:
	first_time_next += 1
	note_schedule_dict = {}
	var columns = timetable.get_children()
	var filtered_columns = []
	for column in columns:
		if column is not VSeparator:
			filtered_columns.append(column)
	
	var max_period_count = num_period_AM + num_period_PM
	
	var day_count = -1
	for row in timetable_cycle + 1:
		var period_count = 1
		day_count += 1
		var noon_append = false
		var evening_append = false
		var morning_append = false
		var note_schedule = {"morning" : "",  "noon" : "", "evening" : ""}
		for column in filtered_columns:
			if column is not VSeparator:
				var box = column.get_child(row * 2)
				
				if box is Label and row == 0:
					pass
					
				if box is HBoxContainer and row == 0:
					var time_boxs = box.get_children()
					var duration = {"period": 0, "start": "", "end": ""}
					if period_count <= max_period_count:
						duration.period = period_count
					period_count += 1
					for time_box in time_boxs:
						if time_box is Button:
							if time_box.get_index() == 0:
								duration.start = time_box.text
							if time_box.get_index() == 2:
								duration.end = time_box.text
					period_duration.append(duration)
					print(period_duration)
				
				if box is VBoxContainer and row != 0:
					var group_schedule = {"day": 0, "period": 0, "group": "", "local": ""}
					group_schedule.day = day_count
					group_schedule.period = period_count
					period_count += 1
					var children = box.get_children()
					var append = true
					for child in children:
						if child is OptionButton:
							if child.selected == -1 or child.get_item_text(child.selected) == "" :
								append = false
							else:
								group_schedule.group = child.get_item_text(child.selected)
						if child is HBoxContainer:
							var line_edit = child.get_child(1)
							group_schedule.local = line_edit.text
					if append:
						group_schedules.append(group_schedule)
					
				if box is TextEdit and row != 0:
					
					if column == filtered_columns[filtered_columns.size() - 1] :
						if box.text != "" :
							note_schedule.evening = box.text
							evening_append = true
					elif column == filtered_columns[1] :
						if box.text != "" :
							note_schedule.morning = box.text
							morning_append = true
					else :
						if box.text != "" :
							note_schedule.noon = box.text
							noon_append = true
					
					if filtered_columns[filtered_columns.size() - 1] == column:
						if morning_append or noon_append or evening_append:
							note_schedule_dict[day_count] = note_schedule
					
	if first_time_next == 2:
		save_instance_data_resource()
		for group_path in global_variables.groups_folder_path :
			print("These are the group_path :",group_path)
			global_variables.delete_directory_recursive(group_path)
		var agenda_dir_path = global_variables.current_school_year_dir + "/" + "agenda_folder"
		global_variables.delete_directory_recursive(agenda_dir_path)
		
		global_variables.current_school_year_dir = "user://" + "school_year_" + school_year_name
		global_variables._update_all_value()
		var main_scene_root = get_tree().get_root().get_node("Main")
		main_scene_root._setter_check()
		first_time_next = 0
	
func _on_back_pressed() -> void:
	first_time_next = 0
	groups = []
	groups_colors = {}
	var columns = timetable.get_children()
	for column in columns:
		column.queue_free()
	
	timetable_scroll_container.hide()
	$PreliminaryPanel.show()

func _timetable_update_size(textedit):
	var current_text = textedit.text
	var max_characters = 30
	if current_text.length() > max_characters:
		textedit.text = current_text.substr(0, max_characters)
		
	var lines = textedit.get_total_visible_line_count()
	var height = textedit.get_line_height()
	var new_height = max(min_size_v, (lines * height)+10)  # Ensure a minimum height
	var index = textedit.get_index()
	for child in timetable.get_children():
		if child is VBoxContainer:
			var node = child.get_child(index)
			node.custom_minimum_size.y = new_height
	textedit.custom_minimum_size.y = new_height

func save_instance_data_resource():
	var save_resource = collect_save_data_into_resource()
	var filename = generate_date_coded_filename_resource()
	var directory = "school_year_" + school_year_name
	
	var dir_access = DirAccess.open("user://")
	if dir_access:
		dir_access.make_dir_recursive(directory)
		
	var file_path = "user://" + directory + "/" + filename
	var error = ResourceSaver.save(save_resource, file_path) # Optionnel: ajouter FLAG_COMPRESS
	if error == OK:
		print("Planification save in : ", file_path)
	else:
		print("Error during the save of : ", file_path, " Erreur: ", error)
	
	


func collect_save_data_into_resource():
	var save_resource = SaveOptionsData.new()
	save_resource.groups = groups
	save_resource.groups_colors = groups_colors
	save_resource.timetable_cycle = timetable_cycle
	save_resource.number_of_period_AM = num_period_AM
	save_resource.number_of_period_PM = num_period_PM
	save_resource.school_year = school_year_name
	save_resource.group_schedules = group_schedules
	save_resource.note_schedule_dict = note_schedule_dict
	save_resource.period_duration = period_duration
	return save_resource

func generate_date_coded_filename_resource():

	return "timetable_and_groups" + ".tres"


func _on_close_button_pressed() -> void:
	timetable_scroll_container.hide()
	$PreliminaryPanel.show()
	
	var dimmer = self.get_parent()
	var main_node = get_tree().current_scene
	main_node.current_state = main_node.SetterState.IDLE
	dimmer.hide()
	dimmer.remove_child(self)
	
	
