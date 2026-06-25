extends Control

@onready var year_grid = $BG/Everything/FreeDaySelection/YearGrid
@onready var error_label = $ErrorLabel
@onready var legend = $BG/Everything/LegendMargin/LegendContainer/LegendMargin/Legend

@onready var warning_box = $WarningBox
@onready var warning_message_label = %WarningMessageLabel
@onready var no_button = $WarningBox/MarginContainer/VboxContainer/Buttons/No
@onready var yes_button = $WarningBox/MarginContainer/VboxContainer/Buttons/Yes

var first_day_style = load("res://_theme/button-calendar-first.tres")
var last_day_style = load("res://_theme/button-calendar-last.tres")
var free_day_style = load("res://_theme/button-calendar-green.tres")
var teacher_workday_style = load("res://_theme/button-calendar-yellow.tres")
var base_style = load("res://_theme/base-theme.tres")

var month_font_size = 10
var current_month = global_variables.current_date.month
var current_year = global_variables.current_date.year
var current_school_date = {"year": current_year, "month": current_month}
var month_grid = null
var no_class_style: StyleBox = load("res://Styles/no_class_today.tres")

var first_day = {}
var first_day_button = null
var last_day = {}
var last_day_button = null
var list_of_teacher_workday = []
var list_of_free_day = []

var list_of_school_days = []

var legend_button_min_size = Vector2(20, 20)

enum SequenceState {
	IDLE,       # Not in a sequence
	FIRST_DAY, 
	LAST_DAY,
	TEACHER_WORKDAYS, 
	FREE_DAYS,
	FREE_SEQUENCE
}
var current_state = SequenceState.IDLE

func _ready():
	
	var year = current_school_date.year
	var month = current_school_date.month
	var date = time_functions.get_first_school_month(year, month) 
	current_state = SequenceState.FIRST_DAY
	_populate_calendar(date)
	_update_sequence_message()
	
func _populate_calendar(date):
	var year = date.year
	var month = date.month
	
	for months in global_variables.months:
		var month_calendar = time_functions.get_calendar_month(year, month)
		var month_grid_container = _add_month_grid_container()
		var month_container = VBoxContainer.new()
		var month_label_node = Label.new()
		month_label_node.text = global_variables.months[month - 1] + " " + str(year)
		month_label_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		for weekday in global_variables.days_of_week_abbr:
			var weekday_label = Label.new()

			weekday_label.add_theme_font_size_override("font_size", month_font_size)
			weekday_label.text = weekday
			weekday_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			weekday_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			month_grid_container.add_child(weekday_label)
		
		for week in month_calendar:

			for day in week:
				
				var date_button: Button
				date_button = Button.new()
				date_button.mouse_filter = Control.MOUSE_FILTER_STOP
				if typeof(day) != TYPE_DICTIONARY:
					date_button.text = ""
				else:
					list_of_school_days.append(day)
					
					date_button.text = str(day.day)
				
					date_button.toggle_mode = true
					date_button.connect("pressed", _on_date_pressed.bind(date_button,day))
					date_button.add_theme_font_size_override("font_size", month_font_size)
				month_grid_container.add_child(date_button)
		month_container.add_child(month_label_node)
		month_container.add_child(month_grid_container)
		year_grid.add_child(month_container)
		month += 1
		if month > 12:
			year += 1
			month = 1
	
func _add_month_grid_container():
	month_grid = GridContainer.new()
	month_grid.columns = 7
	month_grid.set("theme_override_constants/h_separation", 6)
	month_grid.set("theme_override_constants/v_separation", 6)
	month_grid.size_flags_horizontal = SIZE_SHRINK_CENTER
	return month_grid

func _update_sequence_message():
	match current_state:
		SequenceState.IDLE:
			pass
		SequenceState.FIRST_DAY:
			_show_to_user("Veuillez sélectionner la première journée d'école")
			var hbox = HBoxContainer.new()
			var label = Label.new()
			label.text = "Premier jour : "
			var button = Button.new() #Le style de ce bouton doit être identique à celui appliqué dans le calendrier
			button.text = ""
			button.theme = first_day_style
			button.custom_minimum_size = legend_button_min_size
			button.toggle_mode = true
			button.button_pressed = false
			button.set_h_size_flags(Control.SIZE_SHRINK_END | Control.SIZE_EXPAND)
			hbox.add_child(label)
			hbox.add_child(button)
			legend.add_child(hbox)
			
		SequenceState.LAST_DAY:
			_show_to_user("Veuillez sélectionner la dernière journée d'école")
			var hbox = HBoxContainer.new()
			var label = Label.new()
			label.text = "Dernier jour : "
			var button = Button.new() #Le style de ce bouton doit être identique à celui appliqué dans le calendrier
			button.text = ""
			button.theme = last_day_style
			button.custom_minimum_size = legend_button_min_size
			button.toggle_mode = true
			button.button_pressed = false
			button.set_h_size_flags(Control.SIZE_SHRINK_END | Control.SIZE_EXPAND)
			hbox.add_child(label)
			hbox.add_child(button)
			legend.add_child(hbox)

		SequenceState.TEACHER_WORKDAYS:
			_show_to_user("Veuillez sélectionner toutes les journées pédagogiques\nAppuyez sur « suivant » pour passer à la prochaine étape")
			var hbox = HBoxContainer.new()
			var label = Label.new()
			label.text = "Journées pédagogiques : "
			var button = Button.new() #Le style de ce bouton doit être identique à celui appliqué dans le calendrier
			button.text = ""
			button.theme = teacher_workday_style
			button.custom_minimum_size = legend_button_min_size
			button.toggle_mode = true
			button.button_pressed = false
			button.set_h_size_flags(Control.SIZE_SHRINK_END | Control.SIZE_EXPAND)
			hbox.add_child(label)
			hbox.add_child(button)
			legend.add_child(hbox)

		SequenceState.FREE_DAYS:
			_show_to_user("Veuillez sélectionner tous les congés, incluant les jours fériés\nAppuyez sur « suivant » pour passer à la prochaine étape")
			var hbox = HBoxContainer.new()
			var label = Label.new()
			label.text = "Jours de congés : "
			var button = Button.new() #Le style de ce bouton doit être identique à celui appliqué dans le calendrier
			button.text = ""
			button.theme = free_day_style
			button.custom_minimum_size = legend_button_min_size
			button.toggle_mode = true
			button.button_pressed = false
			button.set_h_size_flags(Control.SIZE_SHRINK_END | Control.SIZE_EXPAND)
			hbox.add_child(label)
			hbox.add_child(button)
			legend.add_child(hbox)
			
		SequenceState.FREE_SEQUENCE:
			_show_to_user("Vérifiez que toutes les dates indiquées sont correctes.\nAppuyez sur « suivant » pour compléter le générateur")
			

func _on_date_pressed(button, date):
	print(current_state)
	match current_state:
		SequenceState.IDLE:
			pass
		SequenceState.FIRST_DAY:
			first_day = date
			button.theme = first_day_style
			button.button_pressed = false
			first_day_button = button
			current_state = SequenceState.LAST_DAY
			_update_sequence_message()
			
		SequenceState.LAST_DAY:
			button.button_pressed = false
			if date != first_day :
				last_day = date
				button.theme = last_day_style
				last_day_button = button
				current_state = SequenceState.TEACHER_WORKDAYS
				_update_sequence_message()

		SequenceState.TEACHER_WORKDAYS:
			button.button_pressed = false
			#Suppress the date it is already selected
			if list_of_teacher_workday.has(date):
				list_of_teacher_workday.erase(date)
				button.theme = null
			else:
				#Check if the date is already attributed to fist_day or last_day to prevent multiple selection
				if date != first_day and date != last_day :
					list_of_teacher_workday.append(date)
					button.theme = teacher_workday_style

		SequenceState.FREE_DAYS:
			button.button_pressed = false
			#Suppress the date it is already selected
			if list_of_free_day.has(date):
				list_of_free_day.erase(date)
				button.theme = null
				
			else:
				#Check if the date is already attributed to fist_day, last_day or teacher_workday to prevent multiple selection
				if date != first_day and date != last_day and not list_of_teacher_workday.has(date):
					list_of_free_day.append(date)
					button.theme = free_day_style

		SequenceState.FREE_SEQUENCE:
			pass
	# button.add_theme_stylebox_override("pressed", no_class_style)
		
func _on_suivant_pressed() -> void:
	match current_state:
		SequenceState.IDLE:
			pass
		SequenceState.FIRST_DAY:
			pass
		SequenceState.LAST_DAY:
			pass
		SequenceState.TEACHER_WORKDAYS:
			current_state = SequenceState.FREE_DAYS
			_update_sequence_message()
		SequenceState.FREE_DAYS:
			current_state = SequenceState.FREE_SEQUENCE
			_update_sequence_message()
		SequenceState.FREE_SEQUENCE:
			error_label.stop_showing_to_user()
			warning_box.show()
			warning_message_label.text = "Est-ce que toutes les dates importantes ont été correctement indiquées ?"
			warning_message_label.text += "\n[font_size=12][color=red](En cas d'oubli, vous pouvez ajouter un congé en appuyant "
			warning_message_label.text += "\nsur la touche droite de votre souris sur une case de l'agenda,"
			warning_message_label.text += "\npuis sélectionner « Changer ce jour en jour de congé »)[/color][/font_size]"
			#warning_message_label.text += "\nEn appuyant sur oui, l'application redémarera"
			no_button.connect("pressed", _complete_setter.bind(false))
			yes_button.connect("pressed", _complete_setter.bind(true))
			
func _complete_setter(go_forward):
	if go_forward :
		save_instance_data_resource()
		var main_scene_root = get_tree().get_root().get_node("Main")
		main_scene_root._complete_setter()
	else :
		warning_box.hide()
			
func _on_precedent_pressed() -> void:
	match current_state:
		SequenceState.IDLE:
			pass

		SequenceState.FIRST_DAY:
			pass

		SequenceState.LAST_DAY:
			current_state = SequenceState.FIRST_DAY
			first_day_button.theme = null
			first_day_button.button_pressed = false
			var last_node = legend.get_child(legend.get_children().size() - 1)
			var other_node = legend.get_child(legend.get_children().size() - 2)
			legend.remove_child(last_node)
			legend.remove_child(other_node)
			_update_sequence_message()


		SequenceState.TEACHER_WORKDAYS:
			current_state = SequenceState.LAST_DAY
			last_day_button.theme = null
			last_day_button.button_pressed = false
			var last_node = legend.get_child(legend.get_children().size() - 1)
			var other_node = legend.get_child(legend.get_children().size() - 2)
			legend.remove_child(last_node)
			legend.remove_child(other_node)
			_update_sequence_message()

		SequenceState.FREE_DAYS:
			current_state = SequenceState.TEACHER_WORKDAYS
			var last_node = legend.get_child(legend.get_children().size() - 1)
			var other_node = legend.get_child(legend.get_children().size() - 2)
			legend.remove_child(last_node)
			legend.remove_child(other_node)
			_update_sequence_message()

		SequenceState.FREE_SEQUENCE:
			current_state = SequenceState.FREE_DAYS
			var last_node = legend.get_child(legend.get_children().size() - 1)
			legend.remove_child(last_node)
			_update_sequence_message()
			
func _get_message_to_the_user(message):
	error_label.show_and_fade(message, get_global_mouse_position())
	
func _show_to_user(message):
	error_label.show_to_user(message)

func save_instance_data_resource():
	var save_resource = collect_save_data_into_resource()
	var filename = generate_date_coded_filename_resource()
	var current_directory = global_variables.current_school_year_dir
		
	var file_path = current_directory + "/" + filename
	var error = ResourceSaver.save(save_resource, file_path) # Optionnel: ajouter FLAG_COMPRESS
	if error == OK:
		print("Planification save in : ", file_path)
			
	else:
		print("Error during the save of : ", file_path, " Erreur: ", error)

func collect_save_data_into_resource():
	var save_resource = SaveOptionsData.new()
	save_resource.list_of_teacher_workday = list_of_teacher_workday
	save_resource.list_of_free_day = list_of_free_day
	save_resource.first_day = first_day
	save_resource.last_day = last_day
	
	#groups_dict = {"groups_sequences" : groups_sequences, "filtered_list_of_school_days" : filtered_list_of_school_days, "filtered_dict_of_school_days_group" : filtered_dict_of_school_days_group}
	var groups_dict = collect_groups_sequences()
	#save_resource.groups_sequences = groups_dict["groups_sequences"]
	save_resource.filtered_dict_of_school_days = groups_dict["filtered_dict_of_school_days"]
	save_resource.filtered_dict_of_school_days_group = groups_dict["filtered_dict_of_school_days_group"]
	
	return save_resource

func generate_date_coded_filename_resource():

	return "sequences_informations" + ".tres"

func collect_groups_sequences():
	var filtered_list_of_school_days = list_of_school_days.duplicate()
	var filtered_dict_of_school_days = {}
	var filtered_dict_of_school_days_group = {}
	var groups_sequences = {}
	var current_directory = global_variables.current_school_year_dir
	var filename = "timetable_and_groups"
	var file_path = current_directory + "/" + filename + ".tres"
	print(file_path)
	if FileAccess.file_exists(file_path):
		var loaded_resource = load(file_path)
		var group_schedules = loaded_resource.group_schedules
		var period_duration = loaded_resource.period_duration
		var cycle = loaded_resource.timetable_cycle
		var groups = loaded_resource.groups
		var note_schedule_dict = loaded_resource.note_schedule_dict
		var jour_count = 1
		for day in list_of_school_days:
			var year = day.year
			var month = day.month
			var d = day.day
			var weekday = time_functions.get_weekday(year,month,d)
			
			if day.year == first_day.year and day.month < first_day.month :
				filtered_list_of_school_days.erase(day)
			elif day.month == first_day.month and day.day < first_day.day:
				filtered_list_of_school_days.erase(day)
			
			elif day.year == last_day.year and day.month > last_day.month :
				filtered_list_of_school_days.erase(day)
			elif day.month == last_day.month and day.day > last_day.day:
				filtered_list_of_school_days.erase(day)
			elif first_day.year == last_day.year and day.year != last_day.year:
				filtered_list_of_school_days.erase(day)
			
			elif list_of_free_day.has(day):
				filtered_list_of_school_days.erase(day)
			elif list_of_teacher_workday.has(day):
				filtered_list_of_school_days.erase(day)

			elif weekday == 0 or weekday == 6:
				filtered_list_of_school_days.erase(day)
			
			else:
				day["jour"] = jour_count
				var dict_day = {"day" : day.day,"month" : day.month,"year" : day.year }
				filtered_dict_of_school_days[dict_day] = jour_count
				jour_count += 1
				if jour_count > cycle :
					jour_count = 1
		
		#school_day = {"day": ,"month": ,"year": }: schedule
		var agenda_dir_access = DirAccess.open(current_directory + "/")
		if agenda_dir_access:
			agenda_dir_access.make_dir_recursive("Agenda_folder")
		
		for school_day in filtered_dict_of_school_days :
			var schedule = filtered_dict_of_school_days[school_day] #schedule is the cycle number
			if note_schedule_dict.has(schedule) :
				var notes_of_the_day = note_schedule_dict[schedule]
				for type in notes_of_the_day.keys() :
					
					if notes_of_the_day[type] != "" :
						var agenda_save_resource = SaveAgendaData.new()
						var new_file_path = current_directory + "/" + "agenda_folder" + "/" + "agenda_" + str(type) + "_data_%04d-%02d-%02d.tres" % [school_day.year, school_day.month, school_day.day]

						agenda_save_resource.text_data = notes_of_the_day[type]
						
						var error = ResourceSaver.save(agenda_save_resource, new_file_path) # Optionnel: ajouter FLAG_COMPRESS
						if error != OK:
							print("Error during the save of : ", new_file_path, " Erreur: ", error)
						else :
							print("Successfuly save : ", new_file_path)
					
		for group in groups:
			var group_code = group.name + " " + group.level + " " + group.year
			
			var dir_access = DirAccess.open(current_directory)
			if dir_access:
				dir_access.make_dir_recursive(group_code)
				
			var list_of_courses = []
			
			for school_day in filtered_list_of_school_days:
				var course = {}
				for schedule_dict in group_schedules:
					if schedule_dict.group == group_code and schedule_dict.day == school_day.jour:
						course["year"] = school_day.year
						course["month"] = school_day.month
						course["day"] = school_day.day
						course["jour"] = school_day.jour
						course["period"] = schedule_dict.period
						course["local"] = schedule_dict.local
						
						#This create the dictionnary {{day, month, year, period} : group_code}
						var dict_day = {"year" : school_day.year ,"month" : school_day.month, "day" : school_day.day, "period" : schedule_dict.period}
						filtered_dict_of_school_days_group[dict_day] = group_code
						
						var duration_dict = calculate_period_durations(period_duration)
						var planification_save_resource = SaveCanvaData.new()
						var new_file_path = current_directory + "/" + group_code + "/" + "planification_%04d-%02d-%02d-%01d.tres" % [school_day.year, school_day.month, school_day.day, schedule_dict.period]

						planification_save_resource.duration = duration_dict[schedule_dict.period] 
						var error = ResourceSaver.save(planification_save_resource, new_file_path) # Optionnel: ajouter FLAG_COMPRESS
						if error != OK:
							print("Error during the save of : ", file_path, " Erreur: ", error)

						list_of_courses.append(course)
			groups_sequences[group_code] = list_of_courses
			
	#print(filtered_dict_of_school_days_group)
	return {"groups_sequences" : groups_sequences, "filtered_dict_of_school_days" : filtered_dict_of_school_days, "filtered_dict_of_school_days_group" : filtered_dict_of_school_days_group}

func calculate_period_durations(period_duration):
	var duration = {}
	for period in period_duration:
		var start_time_str: String = period.start
		var end_time_str: String = period.end

		# Parse start time
		var start_parts: PackedStringArray = start_time_str.split(":")
		var start_hour: int = start_parts[0].to_int()
		var start_minute: int = start_parts[1].to_int()
		
		# Parse end time
		var end_parts: PackedStringArray = end_time_str.split(":")
		var end_hour: int = end_parts[0].to_int()
		var end_minute: int = end_parts[1].to_int()

		# Convert times to total minutes from midnight
		var start_total_minutes: int = start_hour * 60 + start_minute
		var end_total_minutes: int = end_hour * 60 + end_minute

		# Calculate duration in minutes
		var duration_minutes: int = end_total_minutes - start_total_minutes

		# Handle cases where the end time might conceptually wrap around to the next day
		# (e.g., start 23:00, end 01:00). In your data, all ends are later than starts
		# within the same day, so this condition will not be met for your sample data.
		if duration_minutes < 0:
			duration_minutes += 24 * 60
		
		duration[period.period] = duration_minutes
	
	return duration
		
		
		
		
		
		
