extends Control

#The file dialog that allows to choose a file
@onready var file_dialog = $FileDialog

#These are nodes that have a link with warnings
@onready var warning_box = $WarningBox
@onready var warning_message_label = %WarningMessageLabel
@onready var no_button = %No
@onready var yes_button = %Yes

@onready var DayLabels = %DayLabelsVbox
@onready var Date_label = $Scroll/EveryThing/Reference/TimePeriod/SideContainer/Date_label
@onready var month_label = %MonthLabel
@onready var year_label = %YearLabel

@onready var day_labels_panel = %DayLabelsPanel
@onready var pad_hseparator = %PadHSeparator

#Each variables is a VBox in the agenda
@onready var monday_box = $Scroll/EveryThing/DayOrganisation/Week/Monday
@onready var tuesday_box = $Scroll/EveryThing/DayOrganisation/Week/Tuesday
@onready var wednesday_box = $Scroll/EveryThing/DayOrganisation/Week/Wednesday
@onready var thursday_box = $Scroll/EveryThing/DayOrganisation/Week/Thursday
@onready var friday_box = $Scroll/EveryThing/DayOrganisation/Week/Friday
@onready var week_hbox = $Scroll/EveryThing/DayOrganisation/Week
@onready var week = [monday_box, tuesday_box, wednesday_box, thursday_box, friday_box]

@onready var time_period_node = %PeriodTimeContainer

@onready var timer: Timer = Timer.new()

var time_selector_panel = load("res://scenes/CustomNodes/TimeSelectorPopup.tscn")

var empty_star_icon = load("res://assets/empty_star.png")
var yellow_star_icon = load("res://assets/yellow_star.png")
var icon_theme = load("res://_theme/icons_button.tres")

var planification_case_lite = load("res://scenes/Agenda/PlanificationCaseLite.tscn")
var agenda_case = load("res://scenes/Agenda/AgendaCase.tscn")
var day_heading = load("res://scenes/Agenda/DayHeading.tscn")
var weekend_case = load("res://scenes/Agenda/WeekendCase.tscn")

#From timetable.tres
var periods_duration = global_variables.period_duration_str
var number_of_period_AM = global_variables.number_of_period_AM
var number_of_period_PM = global_variables.number_of_period_PM

#From sequences_informations.tres
var filtered_dict_of_school_days = global_variables.filtered_dict_of_school_days
var list_of_teacher_workday = global_variables.list_of_teacher_workday
var list_of_free_day = global_variables.list_of_free_day

var DAYS_IN_WEEK = global_variables.DAYS_IN_WEEK
var days_of_week = global_variables.days_of_week
var months = global_variables.months
var months_abbr = global_variables.months_abbr

var current_date = global_variables.current_date

var today = Time.get_date_dict_from_system()

var text_edit_min_size_v = 60
var period_min_size_v = 82

var text_edits_dict = {}
var empty_save_resource = SaveAgendaData.new()

var noon_label_node = null
var evening_label_node = null

var menu_options = ["Décaler la planification au prochain cours", "Décaler la prochaine planification vers ce cours", "Changer ce jour en jour de congé et décaler l'horaire",  "Fermer le menu"]
#["Décaler la planification au prochain cours", "Décaler la prochaine planification vers ce cours", 
#"Assigner une planification à ce cours" ,"Assigner une séquence à partir de ce cours", 
#"Changer ce jour en jour de congé", "Changer ce jour en jour de congé et décaler l'horaire",  "Fermer le menu"]
#"Changer ce jour en jour de congé",
func _ready():
	_populate_day()
	_populate_day_labels(global_variables.current_date)
	_populate_period_duration()
	
	#time_functions._get_week_list(current_date)
	
	file_dialog.file_selected.connect(_on_file_dialog_file_selected)
	file_dialog.dir_selected.connect(_on_file_dialog_dir_selected)
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 0.25 # Temps d'attente en secondes

	warning_box.hide()
	call_deferred("_update_all_vertical_nodes_size")

func _process(_delta):
	if Input.is_action_just_pressed("Change agenda page left"):
		_on_gauche_pressed()
	if Input.is_action_just_pressed("Change agenda page right"):
		_on_droite_pressed()
		
func _update_all_value():
		#From timetable.tres
	periods_duration = global_variables.period_duration_str
	number_of_period_AM = global_variables.number_of_period_AM
	number_of_period_PM = global_variables.number_of_period_PM

	#From sequences_informations.tres
	filtered_dict_of_school_days = global_variables.filtered_dict_of_school_days
	list_of_teacher_workday = global_variables.list_of_teacher_workday
	list_of_free_day = global_variables.list_of_free_day

	DAYS_IN_WEEK = global_variables.DAYS_IN_WEEK
	days_of_week = global_variables.days_of_week
	months = global_variables.months
	months_abbr = global_variables.months_abbr

	current_date = global_variables.current_date

	_populate_day()
	_populate_day_labels(global_variables.current_date)
	await get_tree().process_frame
	_populate_period_duration()

func _update_month_label(week_list):
	var first_day = week_list[0]
	var last_day = week_list[DAYS_IN_WEEK - 1]
	if first_day.month == last_day.month :
		month_label.text = months_abbr[first_day.month - 1]
	else :
		month_label.text = str(months_abbr[first_day.month - 1]) + "-" + str(months_abbr[last_day.month - 1])

func _update_year_label(week_list):
	var first_day = week_list[0]
	var last_day = week_list[DAYS_IN_WEEK - 1]
	if first_day.year == last_day.year :
		year_label.text = str(first_day.year)
	else :
		year_label.text = str(first_day.year) + "-" + str(last_day.year)
	
func _populate_day_labels(date):
	var week_list = time_functions._get_week_list(date)
	_update_month_label(week_list)
	_update_year_label(week_list)
	
	for child in DayLabels.get_children() :
		child.queue_free()
	
	for day in week_list :
		var new_day_heading = day_heading.instantiate()
		new_day_heading.date = day
		
		DayLabels.add_child(new_day_heading)
		new_day_heading._update_labels()
		new_day_heading._update_tasks()
		
		if day != week_list[4] :
			DayLabels.add_child(VSeparator.new())
			
	_ajust_pad_separator()
		
func _ajust_pad_separator():
	var padding = 8 + (day_labels_panel.get_combined_minimum_size().y - day_labels_panel.custom_minimum_size.y)
	#print(padding)
	pad_hseparator.add_theme_constant_override("separation", padding)
			
func _populate_period_duration():
	
	var parameter_data = load(global_variables.global_parameter_path)
	
	for child in time_period_node.get_children():
		child.queue_free()
	
	if parameter_data.show_morning_activated :
		var morning = Label.new()
		morning.custom_minimum_size.y = text_edit_min_size_v
		noon_label_node = morning
		morning.text = "Matin"
		morning.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		morning.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		time_period_node.add_child(morning)
		
		var separatorm = HSeparator.new()
		separatorm.add_theme_constant_override("separation", 0)
		time_period_node.add_child(separatorm)
	
	for i in range(number_of_period_AM):
		var period_duration = Label.new()
		var period_idx = i
		period_duration.text = periods_duration[period_idx]
		period_duration.tooltip_text = "Effectuez un clic droit pour modifier l'heure de début ou l'heure de fin"
		period_duration.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		period_duration.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		period_duration.add_theme_font_size_override("font_size", 14)
		period_duration.add_theme_constant_override("line_spacing", 0)
		period_duration.custom_minimum_size.y = period_min_size_v
		period_duration.set_h_size_flags(Control.SIZE_EXPAND | Control.SIZE_FILL)
		period_duration.set_v_size_flags(Control.SIZE_EXPAND | Control.SIZE_FILL)
		
		period_duration.connect("gui_input", _update_period_duration.bind(period_idx, period_duration))
		time_period_node.add_child(period_duration)
		
		var separatoram = HSeparator.new()
		separatoram.add_theme_constant_override("separation", 0)
		time_period_node.add_child(separatoram)
	
	if parameter_data.show_noon_activated :
		var noon = Label.new()
		noon.custom_minimum_size.y = text_edit_min_size_v
		noon_label_node = noon
		noon.text = "Midi"
		noon.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		noon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		time_period_node.add_child(noon)
		
		var separatorn = HSeparator.new()
		separatorn.add_theme_constant_override("separation", 0)
		time_period_node.add_child(separatorn)
	
	for i in range(number_of_period_PM):
		var period_duration = Label.new()
		var period_idx = i + number_of_period_AM
		period_duration.text = periods_duration[period_idx]
		period_duration.tooltip_text = "Effectuez un clic droit pour modifier l'heure de début ou l'heure de fin"
		period_duration.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		period_duration.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		period_duration.custom_minimum_size.y = period_min_size_v
		period_duration.set_h_size_flags(Control.SIZE_EXPAND | Control.SIZE_FILL)
		period_duration.set_v_size_flags(Control.SIZE_EXPAND | Control.SIZE_FILL)

		period_duration.connect("gui_input", _update_period_duration.bind(period_idx, period_duration))
		time_period_node.add_child(period_duration)

		var separatorpm = HSeparator.new()
		separatorpm.add_theme_constant_override("separation", 0)
		time_period_node.add_child(separatorpm)
	
	if parameter_data.show_evening_activated :
		var evening = Label.new()
		evening.custom_minimum_size.y = text_edit_min_size_v
		evening_label_node = evening
		evening.text = "Soir"
		evening.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		evening.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		time_period_node.add_child(evening)

func _update_period_duration(event, period_idx, period_duration_label):
	if event is InputEventMouseButton :
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			var label_rect = period_duration_label.get_rect()
			var label_rect_half_y = period_duration_label.global_position.y + (label_rect.size.y / 2.0)
			var upper_side = get_global_mouse_position().y < label_rect_half_y
			var new_time_selector = time_selector_panel.instantiate()
			get_tree().get_current_scene().add_child(new_time_selector)
			new_time_selector.position = get_global_mouse_position()
			new_time_selector.connect("time_selected", _apply_new_period_duration.bind(period_idx, upper_side))
			
func _apply_new_period_duration(time_str, period_idx, upper_side):
	#print(upper_side)
	if upper_side :
		var duration_str = periods_duration[period_idx].right(8)
		periods_duration[period_idx] = time_str + duration_str

	if not upper_side :
		var duration_str = periods_duration[period_idx].left(8)
		periods_duration[period_idx] = duration_str + time_str
	
	var periods_duration_dict_array = _get_period_duration_dict(periods_duration)
	print(periods_duration_dict_array)
	global_variables.period_duration_str = periods_duration
	var timetable_file_path = global_variables.current_school_year_dir + "/" + "timetable_and_groups.tres"
	if FileAccess.file_exists(timetable_file_path):
		var loaded_resource = load(timetable_file_path)
		if loaded_resource is SaveOptionsData:
			loaded_resource.period_duration = periods_duration_dict_array
			ResourceSaver.save(loaded_resource, timetable_file_path)
	else :
		var new_timetable_resource = SaveOptionsData.new()
		new_timetable_resource.period_duration = periods_duration_dict_array
		ResourceSaver.save(new_timetable_resource, timetable_file_path)
			
	_populate_period_duration()

func _get_period_duration_dict(periods_duration_array_str):
	var period = 1
	var periods_duration_dict_array = []
	for duration in periods_duration_array_str :
		var start = duration.left(5)
		var end = duration.right(5)
		var periods_duration_dict = {"period": period, "start": start, "end": end}
		periods_duration_dict_array.append(periods_duration_dict)
		period += 1
	return periods_duration_dict_array
		
func _update_all_vertical_nodes_size():
	var Day = week[0]
	for case in Day.get_children() :
		var index = case.get_index()
		#print(case.type)
		_update_vertical_nodes_size(index, case.type)

func _update_vertical_nodes_size(index, type):
	var max_in_row = 0
	for j in len(week) :
		var Day = week[j]
		#print(Day)
		var node_to_check = Day.get_child(index)
		if node_to_check != null :
			var old_min = node_to_check.custom_minimum_size.y
			node_to_check.custom_minimum_size.y = 0
			var node_size = node_to_check.get_combined_minimum_size().y
			node_to_check.custom_minimum_size.y = old_min
			if node_size > max_in_row :
				max_in_row = node_size
				
	var max_size = 0
	if type == "period" or type == "empty_period" :
		max_size = max(max_in_row, period_min_size_v)
	if type == "noon" or type == "evening" or type == "morning" :
		max_size = max(max_in_row, text_edit_min_size_v)
		
	for j in len(week) :
		var Day = week[j]
		var node_to_update = Day.get_child(index)
		if node_to_update != null :
			node_to_update.custom_minimum_size.y = max_size
	
	var time_period_label = time_period_node.get_child((index * 2))
	#print("the label is" + str(time_period_label))
	#print(max_size)
	if time_period_label != null :
		time_period_label.custom_minimum_size.y = max_size

	
func _populate_day():
	
	var last_period = time_functions._find_last_period_of_current_time()
	var week_list = time_functions._get_week_list(global_variables.current_date)
	
	var parameter_data = load(global_variables.global_parameter_path)
	
	for j in len(week) :
		var current_index = 0
		var Day = week[j]
		#var week_id = week.find(Day)
		var week_day = week_list[j]
		
		var children = Day.get_children()
		if children != []:
			for child in children:
				Day.remove_child(child)
				child.queue_free()
				
		if parameter_data.show_morning_activated :
			var morning = _create_agenda_case(week_day, "morning")
			Day.add_child(morning)
			morning._update_values()
			morning.connect("text_modified", _update_vertical_nodes_size.bind(current_index, "morning"))
			current_index += 1
				
		for i in range(number_of_period_AM):
			week_day.period = i + 1
			var period= _create_period_lite(week_day, last_period, parameter_data.show_title_activated)
			Day.add_child(period)
			period._update_values()
			period.connect("text_modified", _update_vertical_nodes_size.bind(current_index, "period"))
			current_index += 1
			
		if parameter_data.show_noon_activated :
			var noon = _create_agenda_case(week_day, "noon")
			Day.add_child(noon)
			noon._update_values()
			noon.connect("text_modified", _update_vertical_nodes_size.bind(current_index, "noon"))
			current_index += 1

		for i in range(number_of_period_PM):
			week_day.period = i + 1 + number_of_period_AM
			var period = _create_period_lite(week_day, last_period, parameter_data.show_title_activated)
			Day.add_child(period)
			period._update_values()
			period.connect("text_modified", _update_vertical_nodes_size.bind(current_index, "period"))
			current_index += 1
		
		if parameter_data.show_evening_activated :
			var evening = _create_agenda_case(week_day, "evening")
			Day.add_child(evening)
			evening._update_values()
			evening.connect("text_modified", _update_vertical_nodes_size.bind(current_index, "evening"))
			current_index += 1
	
	call_deferred("_update_all_vertical_nodes_size")
	#load_instance_data_resource(global_variables.current_date) # update à 5 reprise améliorable

func _create_period_lite(week_day, last_period, show_title_activated):
	var filtered_date = {"day" : week_day.day, "month" : week_day.month, "period" : week_day.period, "year" : week_day.year} #"weekday" : week_day.weekday
	var period_date = {"day" : week_day.day, "month" : week_day.month, "period" : week_day.period, "year" : week_day.year, "weekday" : week_day.weekday}
	
	var group_color = Color(1, 1, 1, 0.7)
	var info_dict = check_if_file_exist(week_day, "planification")
	var empty_period_info_dict = check_if_file_exist(week_day, "empty_period")
	
	if info_dict :
		var period_lite = planification_case_lite.instantiate()
		period_lite.custom_minimum_size.y = period_min_size_v
		period_lite.connect("planif_d_pressed", _go_into_planification.bind(period_lite))
		period_lite.connect("open_menu", _handle_option_menu.bind(period_lite))
		
		var group_name = ""
		period_lite.date = period_date
		if global_variables.filtered_dict_of_school_days_group.has(filtered_date):
			group_name = global_variables.filtered_dict_of_school_days_group[filtered_date]
		
		var title = info_dict.title
		if group_name: #If there is a group attached to planification, attriubute the group name and color
			if global_variables.groups_colors.has(group_name):
				period_lite.heading_modulation = global_variables.groups_colors[group_name]
			if show_title_activated :
				period_lite.title = title
			period_lite.group_code = group_name
		else : #This is the case when the year is not set
			if show_title_activated :
				period_lite.title = title

		period_lite.notes = info_dict.notes

		var formatted_date = "%04d-%02d-%02d-%01d" % [week_day.year, week_day.month, week_day.day, week_day.period]
		var formatted_today = "%04d-%02d-%02d-%01d" % [today.year, today.month, today.day, last_period]
		if formatted_date <= formatted_today :
			#period_lite.retroaction_visible = true
			if check_if_file_exist(week_day, "retroaction"):
				period_lite.existing_retroaction = true
		return period_lite
	
	else : #If there is no planification
		var empty_period = agenda_case.instantiate()
		empty_period.date = period_date
		empty_period.type = "empty_period"
		empty_period.custom_minimum_size.y = period_min_size_v
		if empty_period_info_dict != {} :
			empty_period.loaded_text = empty_period_info_dict.text_data
		return empty_period

func _create_agenda_case(week_day, type):
	var data_info_dict = check_if_file_exist(week_day, type)
	var new_agenda_case = agenda_case.instantiate()
	new_agenda_case.date = week_day
	new_agenda_case.type = type
	new_agenda_case.size_flags_vertical = SIZE_SHRINK_BEGIN
	new_agenda_case.custom_minimum_size.y = text_edit_min_size_v
	
	if data_info_dict != {} :
		new_agenda_case.loaded_text = data_info_dict.text_data
	
	return new_agenda_case

func check_if_file_exist(date, type):
	var period = date.period
	var day = date.day
	var month = date.month
	var year = date.year
	if type == "planification" :
		var filename = "planification_%04d-%02d-%02d-%01d.tres" % [year, month, day, period]
		var no_group_planification_file_path = global_variables.current_school_year_dir + "/" + "no_group" + "/"
		if global_variables.is_set_for_the_year == true :
			for path in global_variables.groups_folder_path :
				var planification_file_path = path + "/" + filename
				if FileAccess.file_exists(planification_file_path):
					var loaded_resource = load(planification_file_path)
					if loaded_resource is SaveCanvaData:
						var title = loaded_resource.title
						var notes = loaded_resource.notes
						var info_dict = {"title" : title, "notes" : notes, "path": path} #path in the dict to be able to call _move_to_next_course() inside _add_free_day()
						#print("Resource finded : ", file_path)
						return info_dict
				
				elif FileAccess.file_exists(no_group_planification_file_path + filename):
					var loaded_resource = load(no_group_planification_file_path + filename)
					if loaded_resource is SaveCanvaData:
						var title = loaded_resource.title
						var info_dict = {"title" : title, "path": path} #path in the dict to be able to call _move_to_next_course() inside _add_free_day()
						return info_dict
		
		if global_variables.is_set_for_the_year == false :
			var file_path = no_group_planification_file_path + filename
			if FileAccess.file_exists(no_group_planification_file_path + filename):
				var loaded_resource = load(file_path)
				if loaded_resource is SaveCanvaData:
					var title = loaded_resource.title
					var info_dict = {"title" : title, "path": no_group_planification_file_path} #path in the dict to be able to call _move_to_next_course() inside _add_free_day()
					#print("Resource finded : ", file_path)
					return info_dict
	
	if type == "retroaction" :
		var filename = "retroaction_%04d-%02d-%02d-%01d.tres" % [year, month, day, period]
		var file_path = global_variables.current_school_year_dir + "/" + "retroaction" + "/" + filename
		if FileAccess.file_exists(file_path):
			return true
		
	if type == "morning" or type == "noon" or type == "evening":
		var filename = "agenda_" + type + "_data_%04d-%02d-%02d.tres" % [year, month, day]
		var file_path = global_variables.current_school_year_dir + "/" + "agenda_folder" + "/" + filename
		if FileAccess.file_exists(file_path):
			var loaded_resource = load(file_path)
			if loaded_resource is SaveAgendaData:
				var text_data = loaded_resource.text_data
				var info_dict = {"text_data" : text_data} #path in the dict to be able to call _move_to_next_course() inside _add_free_day()
				print("Resource finded : ", file_path)
				return info_dict
	
	if type == "empty_period" :
		var filename = "agenda_" + type + "_data_%04d-%02d-%02d-%01d.tres" % [year, month, day, period]
		var file_path = global_variables.current_school_year_dir + "/" + "agenda_folder" + "/" + filename
		if FileAccess.file_exists(file_path):
			var loaded_resource = load(file_path)
			if loaded_resource is SaveAgendaData:
				var text_data = loaded_resource.text_data
				var info_dict = {"text_data" : text_data} #path in the dict to be able to call _move_to_next_course() inside _add_free_day()
				print("Resource finded : ", file_path)
				return info_dict
	return {}
					
func get_folder_name_from_path(full_folder_path: String) :
	if full_folder_path.is_empty():
		return ""
	var cleaned_path = full_folder_path.simplify_path()
	
	if cleaned_path == "res://" or cleaned_path == "user://":
		return ""
		
	return cleaned_path.get_file()
	
func _on_agenda_text_data_selected(text_edit):
	var day_selected = text_edit.get_parent() #day_selected is a vbox associated with a day
	var day_selected_id = week.find(day_selected)
	var week_list = time_functions._get_week_list(global_variables.current_date)
	var day = week_list[day_selected_id]
	
	global_variables.current_date = day
	global_variables.current_date.period = 0
	global_variables.emit_date_changed_signal()
	#print(global_variables.current_date)
	
func _check_input_of_button(event, period_button):
	if event is InputEventMouseButton:
		if event.pressed:
			#When a button is pressed, the date update
			var day_selected = period_button.get_parent() #day_selected is a vbox associated with a day
			var day_selected_id = week.find(day_selected)
			var week_list = time_functions._get_week_list(global_variables.current_date)
			var day = week_list[day_selected_id]
			
			global_variables.current_date = day
			global_variables.emit_date_changed_signal()
			
			var id = period_button.get_index()
			if id >= global_variables.number_of_period_AM:
				global_variables.current_date.period = id
			else:
				global_variables.current_date.period = id + 1
			
			var new_date = global_variables.current_date
			var filtered_date = {"day" : new_date.day, "month" : new_date.month, "period" : new_date.period, "year" : new_date.year}
			if global_variables.filtered_dict_of_school_days_group.has(filtered_date) :
				global_variables.current_selected_group = global_variables.filtered_dict_of_school_days_group[filtered_date]
				print(global_variables.filtered_dict_of_school_days_group[filtered_date])
			else :
				global_variables.current_selected_group = ""
			#var info_dict = check_if_file_exist(global_variables.current_date)
			#if info_dict:
			#	global_variables.current_selected_group = info_dict.group_code
			#	print(global_variables.current_selected_group)
			
			#The double click is handle inside _go_into_planification()
			if event.button_index == MOUSE_BUTTON_LEFT:
				_go_into_planification(period_button)
				
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				pass
				#_handle_option_menu()

func _handle_option_menu(period_button):
	var popup_menu = PopupMenu.new()
	
	for i in range(menu_options.size()):
		popup_menu.add_item(menu_options[i], i) # The second argument is the ID
		
	$".".add_child(popup_menu)
	#popup_menu.popup_at_global_position(DisplayServer.mouse_get_position())
	popup_menu.position = get_global_mouse_position()
	popup_menu.id_pressed.connect(_on_menu_item_pressed.bind(period_button))
	popup_menu.popup()
#["Assigner une séquence à partir de ce cours", "Changer ce jour en jour de congé", "Changer ce jour en jour de congé et décaler l'horaire",  "Fermer le menu"]

func _on_menu_item_pressed(id: int, period_button):
	var selected_option = menu_options[id]
	var school_year_path = global_variables.current_school_year_dir
	var group = period_button.group_code
	var date = period_button.date
	print(group)
	print(date)
	if group != "" :
		var path = school_year_path + "/" + group
		match selected_option:
			"Décaler la planification au prochain cours":
				_move_to_next_course(path, date)
			"Décaler la prochaine planification vers ce cours":
				_move_to_previous_course(path, date)
			"Assigner une planification à ce cours":
				_assign_planification()
			"Assigner une séquence à partir de ce cours":
				_assign_sequence()
			"Changer ce jour en jour de congé":
				_add_free_day(date, false)
			"Changer ce jour en jour de congé et décaler l'horaire":
				_add_free_day(date, true)
			"Fermer le menu":
				pass
	
var first_period_button = null
func _go_into_planification(period_case):
		
	#if timer.time_left > 0.0 and first_period_button == period_button:
	var day = period_case.date
	print(day)
	global_variables.current_date = day
	global_variables.current_selected_group = period_case.group_code
	var main_scene_node = get_tree().current_scene
	var planif_button = main_scene_node.get_node("EveryThing/OptionsContainer/OptionR/PlanifDetail")
	planif_button.emit_signal("pressed")
		
	#if timer.time_left == 0.0:
	#	timer.start()
	#	first_period_button = period_button

func _start_retroaction(period_button):
	var day_selected = period_button.get_parent() #day_selected is a vbox associated with a day
	var day_selected_id = week.find(day_selected)
	var week_list = time_functions._get_week_list(global_variables.current_date)
	var day = week_list[day_selected_id]
			
	global_variables.current_date = day
	global_variables.emit_date_changed_signal()
	
	var id = period_button.get_index()
	if id >= global_variables.number_of_period_AM:
		global_variables.current_date.period = id
	else:
		global_variables.current_date.period = id + 1
	var main_scene_node = get_tree().current_scene
	main_scene_node._start_retroaction()
	print("retro")
	
func _text_update_size(textedit, type, save):
	var lines = textedit.get_total_visible_line_count()
	var height = textedit.get_line_height()
	var new_height = max(text_edit_min_size_v, (lines * height) + 16)   # Ensure a minimum height
	textedit.custom_minimum_size.y = new_height
	
	if save :
		save_instance_agenda_resource(textedit, type)

func _on_droite_pressed() -> void:
	time_functions.get_next_week_date(global_variables.current_date)
	# 1. get the noon and evening group and clear them
	var evening_group = get_tree().get_nodes_in_group("evening_text_edit")
	var noon_group = get_tree().get_nodes_in_group("noon_text_edit")
	# 2. Loop through the array and remove each node from the group.
	for evening in evening_group:
		evening.remove_from_group("noon_text_edit")
	for noon in noon_group:
		noon.remove_from_group("noon_text_edit")
		
	#Remove children to avoid repetition
	for child in DayLabels.get_children():
		DayLabels.remove_child(child)
		child.queue_free()
	_populate_day_labels(global_variables.current_date)
	_populate_period_duration()
	await get_tree().process_frame
	_populate_day()

func _on_gauche_pressed() -> void:
	time_functions.get_previous_week_date(global_variables.current_date)
	# 1. get the noon and evening group and clear them
	var evening_group = get_tree().get_nodes_in_group("evening_text_edit")
	var noon_group = get_tree().get_nodes_in_group("noon_text_edit")
	# 2. Loop through the array and remove each node from the group.
	for evening in evening_group:
		evening.remove_from_group("noon_text_edit")
	for noon in noon_group:
		noon.remove_from_group("noon_text_edit")
		
	#Remove children to avoid repetition
	for child in DayLabels.get_children():
		DayLabels.remove_child(child)
		child.queue_free()
	_populate_day_labels(global_variables.current_date)
	_populate_period_duration()
	await get_tree().process_frame
	_populate_day()


func _move_to_previous_course(path: String, date):
	var day = date.day
	var month = date.month
	var year = date.year
	var period = date.period
	var current_file = "planification_%04d-%02d-%02d-%01d.tres" % [year, month, day, period]
	
	var dir_access = DirAccess.open(path)

	if dir_access:
		var files_and_dirs: PackedStringArray = []
		
		# Start listing directory contents
		dir_access.list_dir_begin()
		var file_name = dir_access.get_next()

		while file_name != "":
			# Exclude "." and ".." entries
			if file_name != "." and file_name != "..":
				files_and_dirs.append(file_name)
			file_name = dir_access.get_next()

		dir_access.list_dir_end() # Important to call this to clean up
		
		# Now iterate through the collected list
		var current_file_id = files_and_dirs.find(current_file)
		var precedent_item = "delete"
		for i in range(files_and_dirs.size()):
			var current_item = files_and_dirs[i]
			var old_path = path + "/" + current_item
			var new_path = path + "/" + precedent_item
			
			if i > current_file_id :
				# Check if it's a directory or file (optional, if you need to differentiate)
				var is_dir = dir_access.dir_exists(path + "/" + current_item) # Check if it's a directory by appending the full path
				if not is_dir :
					print(old_path)
					print(new_path)
					var error = dir_access.rename(old_path, new_path)
					
					if error != OK:
						print("An error occurred when trying to access the path: " + path)
			precedent_item = current_item
			
			if i == files_and_dirs.size() - 1 :
				var save_resource = SaveCanvaData.new()
				var file_path = path + "/" + current_item
				var error = ResourceSaver.save(save_resource, file_path) # Optionnel: ajouter FLAG_COMPRESS
				if error != OK:
					print("Error during the save of : ", file_path, " Erreur: ", error)
				break
		_populate_day()
		
func _move_to_next_course(path: String, date):
	var day = date.day
	var month = date.month
	var year = date.year
	var period = date.period
	var current_file = "planification_%04d-%02d-%02d-%01d.tres" % [year, month, day, period]
	
	var dir_access = DirAccess.open(path)

	if dir_access:
		var files_and_dirs: PackedStringArray = []
		
		# Start listing directory contents
		dir_access.list_dir_begin()
		var file_name = dir_access.get_next()

		while file_name != "":
			# Exclude "." and ".." entries
			if file_name != "." and file_name != "..":
				files_and_dirs.append(file_name)
			file_name = dir_access.get_next()

		dir_access.list_dir_end() # Important to call this to clean up

		# Now iterate backward through the collected list
		var precedent_item = "delete"
		for i in range(files_and_dirs.size() - 1, -1, -1):
			var current_item = files_and_dirs[i]
			var old_path = path + "/" + current_item
			var new_path = path + "/" + precedent_item
			# Check if it's a directory or file (optional, if you need to differentiate)
			var is_dir = dir_access.dir_exists(path + "/" + current_item) # Check if it's a directory by appending the full path
			if not is_dir :
				print(old_path)
				print(new_path)
				var error = dir_access.rename(old_path, new_path)
				
				if error != OK:
					print("An error occurred when trying to access the path: " + path)
			precedent_item = current_item
			if current_item == current_file :
				var save_resource = SaveCanvaData.new()
				var file_path = path + "/" + current_file
				var error = ResourceSaver.save(save_resource, file_path) # Optionnel: ajouter FLAG_COMPRESS
				if error != OK:
					print("Error during the save of : ", file_path, " Erreur: ", error)
				break
		_populate_day()
		
#This function start the planification assignation
func _assign_planification():
	file_dialog.current_dir = global_variables.default_user_planification_dir
	file_dialog.popup_centered()
	# For convenience, set up the dialog initially for directory selection
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	
#This function deals with the planification assignation
func _on_file_dialog_file_selected(path: String):
	# This signal is emitted if FILE_MODE_OPEN_FILE or FILE_MODE_OPEN_ANY is used and a file is selected.
	var date = global_variables.current_date
	var day = date.day
	var month = date.month
	var year = date.year
	var period = date.period
	var filename = "planification_%04d-%02d-%02d-%01d.tres" % [year, month, day, period]
	var school_year = global_variables.current_school_year_dir
	var group = global_variables.current_selected_group
	var file_path = school_year + "/" + group + "/" + filename

	if FileAccess.file_exists(path) and FileAccess.file_exists(file_path):
		var dir_access = DirAccess.open("user://")
		var error = dir_access.copy(path, file_path)
		if error != OK:
			print("An error occurred when trying to access the path: " + path)
		else :
			print("File copied successfully from '", path, "' to '", file_path, "'. Original kept.")
	
	print("Selected file: ", path)
	_populate_day()

#This function start the sequence assignation by making you chose a directory 
func _assign_sequence():
	# For convenience, set up the dialog initially for directory selection
	file_dialog.current_dir = global_variables.default_user_planification_dir
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.popup_centered()
	
#This function deals with sequence assignation by verifying and preparing the data
func _on_file_dialog_dir_selected(path: String):

	var date = global_variables.current_date
	var day = date.day
	var month = date.month
	var year = date.year
	var period = date.period
	var filename = "planification_%04d-%02d-%02d-%01d.tres" % [year, month, day, period]
	
	var school_year = global_variables.current_school_year_dir
	var group = global_variables.current_selected_group
	var file_path = school_year + "/" + group

	var planification_dir_access = DirAccess.open(file_path)
	var planification = []
	
	if planification_dir_access:
		# Start listing directory contents
		planification_dir_access.list_dir_begin()
		var file_name = planification_dir_access.get_next()

		while file_name != "":
			# Exclude "." and ".." entries
			if file_name != "." and file_name != "..":
				planification.append(file_name)
			file_name = planification_dir_access.get_next()

		planification_dir_access.list_dir_end() # Important to call this to clean up
	
	#It is important to remove the planification that happen before the selected date
	var new_planification = planification.duplicate()
	for i in range(planification.size()):
		if planification[i] != filename :
			new_planification.erase(planification[i])
		else:
			break
	planification = new_planification
	
	
	var sequence_dir_access = DirAccess.open(path)
	var sequence: PackedStringArray = []
	
	if sequence_dir_access:
		# Start listing directory contents
		sequence_dir_access.list_dir_begin()
		var file_name = sequence_dir_access.get_next()

		while file_name != "":
			# Exclude "." and ".." entries
			if file_name != "." and file_name != "..":
				sequence.append(file_name)
			file_name = sequence_dir_access.get_next()

		sequence_dir_access.list_dir_end() # Important to call this to clean up
	
	#difference should start at 0. A longer planification should not make it in the negative
	var difference = 0
	if sequence.size() > planification.size():
		difference = sequence.size() - planification.size()
		
		warning_message_label.text = "La séquence choisie contient " + str(sequence.size()) + " cours."
		warning_message_label.text += "\nCette séquence est plus longue que le nombre de cours restant"
		#It is important to verify the excess number in order to correctly conjugate the sentence
		if difference > 1 :
			warning_message_label.text += "\nLes " + str(difference) + " dernier cours de la séquence seront ignorés"
		else:
			warning_message_label.text += "\nLe dernier cours de la séquence sera ignoré"
			
		warning_message_label.text += "\nÊtes-vous certains de vouloir appliquer cette séquence ?"
		warning_message_label.text += "\n[font_size=12][color=red](Si une planification n'est pas sauvegardée, elle sera perdue)[/color][/font_size]"
		warning_box.show()
	else:
		warning_message_label.text = "La séquence choisie contient " + str(sequence.size()) + " cours."
		warning_message_label.text += "\nÊtes-vous certains de vouloir appliquer cette séquence ?"
		warning_message_label.text += "\n[font_size=12][color=red](Si une planification n'est pas sauvegardée, elle sera perdue)[/color][/font_size]"
		warning_box.show()
	
	#It is good practice to disconnect the existing connections to avoid calling multiple functions
	var no_button_connections = no_button.pressed.get_connections()
	for connection in no_button_connections:
		var callable_to_disconnect = connection.callable
		no_button.pressed.disconnect(callable_to_disconnect)
	#This function mean stop
	no_button.connect("pressed", _stop_sequence_assignation)
	
	#It is good practice to disconnect the existing connections to avoid calling multiple functions
	var yes_button_connections = yes_button.pressed.get_connections()
	for connection in yes_button_connections:
		var callable_to_disconnect = connection.callable
		yes_button.pressed.disconnect(callable_to_disconnect)
	#This function mean go forward
	yes_button.connect("pressed", _finalise_sequence_assignation.bind(sequence, planification, path, file_path, difference))
	
#This function close the warning message
func _stop_sequence_assignation():
	warning_box.hide()
	pass

#This function apply the sequence
func _finalise_sequence_assignation(sequence, planification, path, file_path, difference):
	warning_box.hide() #close the warning box
	#Every file in the sequence is copied into the corresponding planification
	for i in range(sequence.size() - difference): #Diffence is how many suplementary item there is in sequence in comparison to planification
		#path and file_path are the path of the directory
		var old_path = path + "/" + sequence[i]
		var new_path = file_path + "/" + planification[i]
		if FileAccess.file_exists(old_path) and FileAccess.file_exists(new_path):
			var dir_access = DirAccess.open("user://")
			var error = dir_access.copy(old_path, new_path)
			if error != OK:
				print("An error occurred when trying to access the path: " + old_path)
			else :
				print("File copied successfully from '", old_path, "' to '", new_path, "'. Original kept.")
	_populate_day()
	
#This function add a free day by moving the courses of that day to the next one in the sequence
#Shift is for the timetable. If shift is true, then all the planification after this day need to be corrected. 
func _add_free_day(button_date, shift = false):
	var school_year_path = global_variables.current_school_year_dir
	var local_current_date = button_date #I redifine a new variable with current date because the one declare at the beggining can lead to errors
	var day = local_current_date.day
	var month = local_current_date.month
	var year = local_current_date.year
	#Get the date from local_current_date
	var formatted_selected_date = "%04d-%02d-%02d" % [local_current_date.year, local_current_date.month, local_current_date.day]
	if not shift:
		#It is important to account for the total number of period
		for i in range(global_variables.number_of_period_AM + global_variables.number_of_period_PM):
			var period = i + 1 #since i start at 0
			var date = {"day" = day, "month" = month, "year" = year, "period" = period}
				
			#print(check_if_file_exist(date))
			var info = check_if_file_exist(date, "planification")
			if info != {}:
				_move_to_next_course(info.path, date)
	if shift :
		#The first step is creating the copy directory and copying all the planifications files inside
		var dir_access = DirAccess.open("user://")
		var groups_folder_path = global_variables.groups_folder_path
		for i in range(groups_folder_path.size()) :
			var group_path = groups_folder_path[i]
			#This create the copy directory for each group
			var new_dir_path = group_path + "/copy"
			dir_access.make_dir_recursive(new_dir_path)
			
			#This will copy every planification file in the copy dir
			#Start listing directory contents (each planification file after selected date need to be in the list)
			var group_dir_access = DirAccess.open(group_path) #Open group_path to access planification files
			group_dir_access.list_dir_begin()
			var file_name = group_dir_access.get_next()

			while file_name != "":
				# Exclude "." and ".." entries
				if file_name != "." and file_name != ".." and file_name != "copy" and file_name != "delete":
					#Trim the file_name to isolate the date
					var file_date = file_name.trim_prefix("planification_")
					file_date = file_date.trim_suffix(".tres")
					var short_file_date = file_date.substr(0, file_date.length() - 2) #short_date don't have the period so it is easier to compare
					
					#We don't want the files before the selected day
					if short_file_date >= formatted_selected_date :
						var old_path = group_path + "/" + file_name
						var new_path = group_path + "/copy" + "/" + file_date + ".tres"
						var error = group_dir_access.copy(old_path, new_path)
						if error != OK:
							print("An error occurred when trying to access the path: " + old_path)
						else :
							print("File copied successfully from '", old_path, "' to '", new_path, "'. Original kept.")
							#Now that we have a copy of the planification file, we can delete the original
							var file_path_to_delete = old_path
							if DirAccess.remove_absolute(file_path_to_delete):
								print("deleted")
								print()
				
				file_name = group_dir_access.get_next()

			group_dir_access.list_dir_end() # Important to call this to clean up
			
		#The next step is to update the list_of_free_day from sequences_informations.tres
		#And recreate the new var filtered_dict_of_school_days_group and filtered_dict_of_school_days with a shift of schedule
		#To do so, we first load sequences_informations.tres
		var sequences_informations_path = school_year_path + "/" + "sequences_informations.tres"
		var sequences_informations = null
		#If the file don't exist, the result will be null
		if FileAccess.file_exists(sequences_informations_path):
			sequences_informations = ResourceLoader.load(sequences_informations_path)
		
		if sequences_informations is SaveOptionsData:
			#The following step are divise in three : update filtered_dict_of_school_days, update local_filtered_dict_of_school_days_group, create the new planification files
			#1 - Update filtered_dict_of_school_days. We delete the selected date_key and ajust the following key until last_day
			var new_local_filtered_dict_of_school_days = {}
			var local_filtered_dict_of_school_days = sequences_informations.filtered_dict_of_school_days
			var selected_date_dict = {"day": day,"month": month,"year": year}
			#Erase the new free day
			local_filtered_dict_of_school_days.erase(selected_date_dict)
			#Modify the schedule of every relevant school day
			for key in local_filtered_dict_of_school_days:
				var school_day_formatted_date = "%04d-%02d-%02d" % [key.year, key.month, key.day]
				var schedule = local_filtered_dict_of_school_days[key]
				#If the key is after the selected day, drop the schedule by 1, else keep it the same
				if school_day_formatted_date > formatted_selected_date :
					if schedule == 1 :
						new_local_filtered_dict_of_school_days[key] = 9
					else:
						new_local_filtered_dict_of_school_days[key] = schedule - 1
				else :
					new_local_filtered_dict_of_school_days[key] = schedule
			#2 - Update local_filtered_dict_of_school_days_group. This one is more complicated because it need the schedule in timetable. 
			#Since timetable_and_groups.tres don't change however, we can take it from the global variables
			var new_local_filtered_dict_of_school_days_group = {}
			for school_day in new_local_filtered_dict_of_school_days.keys():
				var schedule = new_local_filtered_dict_of_school_days[school_day]
				for schedule_dict in global_variables.group_schedules :
					if schedule_dict.day == schedule :
						#Creating a new_dict is more secure than attributing a new key/value to school_day
						var new_dict = {"day":school_day.day, "month": school_day.month, "period": schedule_dict.period, "year" : school_day.year}
						new_local_filtered_dict_of_school_days_group[new_dict] = schedule_dict.group
			#3 - Now that we have the new_local_filtered_dict_of_school_days_group, we can use it to create the new accurate planification
			for school_day in new_local_filtered_dict_of_school_days_group.keys():
				#Here school_day is in the form {{day, month, year, period} : group_code}
				var group_code = new_local_filtered_dict_of_school_days_group[school_day]
				var file_name = "planification_%04d-%02d-%02d-%01d.tres" % [school_day.year, school_day.month, school_day.day, school_day.period]
				var formatted_file_date = "%04d-%02d-%02d" % [school_day.year, school_day.month, school_day.day]
				if formatted_file_date > formatted_selected_date :
					var file_path = school_year_path + "/" + group_code + "/" + file_name
					print(file_path)
					var save_resource = SaveCanvaData.new()
					var error = ResourceSaver.save(save_resource, file_path)
					if error != OK:
						print("Error during the save of : ", file_path, " Erreur: ", error)
			#4 - To be able to see the result in the agenda, we need to update the previous value in the global variables and in the sequences_informations file
			
			print(global_variables.filtered_dict_of_school_days_group)
			global_variables.filtered_dict_of_school_days_group = new_local_filtered_dict_of_school_days_group
			global_variables.filtered_dict_of_school_days = new_local_filtered_dict_of_school_days
			var new_free_day_date = {"year": year, "month": month, "day": day}
			global_variables.list_of_free_day.append(new_free_day_date)
			print(global_variables.filtered_dict_of_school_days_group)
			sequences_informations.filtered_dict_of_school_days_group = new_local_filtered_dict_of_school_days_group
			sequences_informations.filtered_dict_of_school_days = new_local_filtered_dict_of_school_days
			sequences_informations.list_of_free_day = global_variables.list_of_free_day
			var save_error = ResourceSaver.save(sequences_informations, sequences_informations_path) # Optionnel: ajouter FLAG_COMPRESS
			if save_error != OK:
				print("Error during the save of : ", sequences_informations_path, " Erreur: ", save_error)
			#5 - Finally, for each group, we apply the "copy" sequence on the new planification.
			for group_path in global_variables.groups_folder_path :
				#var file_path = school_year + "/" + group
				var planification_dir_access = DirAccess.open(group_path)
				var planification = []
				
				if planification_dir_access:
					# Start listing directory contents
					planification_dir_access.list_dir_begin()
					var file_name = planification_dir_access.get_next()
					
					while file_name != "":
						# Exclude "." and ".." entries
						if file_name != "." and file_name != ".." and file_name != "copy" and file_name != "delete":
							var file_date = file_name.trim_prefix("planification_")
							file_date = file_date.trim_suffix(".tres")
							var short_file_date = file_date.substr(0, file_date.length() - 2) #short_date don't have the period so it is easier to compare
							
							#We don't want the files before the selected day
							if short_file_date >= formatted_selected_date :
								planification.append(file_name)
						file_name = planification_dir_access.get_next()

					planification_dir_access.list_dir_end() # Important to call this to clean up
				print()
				print(planification)
				print()
				var copy_path = group_path + "/" + "copy"
				var sequence_dir_access = DirAccess.open(copy_path)
				var sequence: PackedStringArray = []
				
				if sequence_dir_access:
					# Start listing directory contents
					sequence_dir_access.list_dir_begin()
					var file_name = sequence_dir_access.get_next()

					while file_name != "":
						# Exclude "." and ".." entries
						if file_name != "." and file_name != "..":
							sequence.append(file_name)
						file_name = sequence_dir_access.get_next()

					sequence_dir_access.list_dir_end()
				print()
				print(sequence)
				print()
				var difference = 0
				if sequence.size() > planification.size():
					difference = sequence.size() - planification.size()
					
				for i in range(sequence.size() - difference): #Diffence is how many suplementary item there is in sequence in comparison to planification
				#path and file_path are the path of the directory
					var old_path = copy_path + "/" + sequence[i]
					var new_path = group_path + "/" + planification[i]
					if FileAccess.file_exists(old_path) and FileAccess.file_exists(new_path):
						var seq_dir_access = DirAccess.open("user://")
						var error = seq_dir_access.copy(old_path, new_path)
						if error != OK:
							print("An error occurred when trying to access the path: " + old_path)
						else :
							print("File copied successfully from '", old_path, "' to '", new_path, "'. Original kept.")
							
				#6 - Delete the copy directory
				global_variables.delete_directory_recursive(copy_path)
		
		for child in DayLabels.get_children():
			DayLabels.remove_child(child)
			child.queue_free()
		_populate_day_labels(local_current_date)
		_populate_day()
	print("shift")
	
func save_instance_agenda_resource(text_edit, type):
	var filename = generate_agenda_coded_filename_resource()
	var school_year = global_variables.current_school_year_dir
	var file_path = school_year + "/" + "agenda_folder" + "/" + filename
	var previous_data_resource = null
	if FileAccess.file_exists(file_path):
		previous_data_resource = ResourceLoader.load(file_path)
	var save_resource = collect_agenda_into_resource(text_edit, type, previous_data_resource)
	
	
	var error = ResourceSaver.save(save_resource, file_path) # Optionnel: ajouter FLAG_COMPRESS
	if error != OK:
		print("Error during the save of : ", file_path, " Erreur: ", error)

func collect_agenda_into_resource(text_edit, type, previous_data_resource):
	var save_resource = previous_data_resource
	if save_resource == null :
		save_resource = SaveAgendaData.new()

	if type == "noon" :
		save_resource.noon_text_entry = text_edit.text
		save_resource.noon_text_size = text_edit.custom_minimum_size.y
	if type == "evening" :
		save_resource.evening_text_entry = text_edit.text
		save_resource.evening_text_size = text_edit.custom_minimum_size.y
	
	return save_resource

func generate_agenda_coded_filename_resource():
	var date = global_variables.current_date
	var day = date.day
	var month = date.month
	var year = date.year
	var filename = "agenda_data_%04d-%02d-%02d.tres" % [year, month, day]
	return filename
	
