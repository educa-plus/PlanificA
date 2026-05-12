extends VBoxContainer

@export var date = {}

@onready var rvseparator = %RVSeparator
@onready var lvseparator = %LVSeparator

@onready var date_label = %DateLabel
@onready var schedule_label = %ScheduleLabel
@onready var task_button = %TaskButton
@onready var task_popup = %TaskPopupMenu

func _update_labels():
	if date_label != null and schedule_label != null :
		var days_of_week = global_variables.days_of_week
		date_label.text = days_of_week[date.weekday] + " " + str(date.day)
			
		var dict_day = {"day" : date.day, "month" : date.month, "year" : date.year }

		if global_variables.filtered_dict_of_school_days.has(dict_day) :
			schedule_label.text = "Jour " + str(global_variables.filtered_dict_of_school_days[dict_day])
				
		elif global_variables.list_of_teacher_workday.has(dict_day) :
			schedule_label.text = "Journée pédagogique"
			
		elif global_variables.list_of_free_day.has(dict_day) :
			schedule_label.text = "Congé"
			
		else :
			schedule_label.hide()
			
		if self.get_index() == 0 :
			lvseparator.visible = true
		
		
		
func _update_tasks():
	var to_do_dir_path = "user://" + "to_do_list" + "/"
	var to_do_files = global_variables._find_all_files_in_dir(to_do_dir_path)
	var task_count = 0
	var task_description = ""
	task_popup.clear()
	for file in to_do_files :
		var file_path = to_do_dir_path + file
		var loaded_task = load(file_path)
		var task_date = loaded_task.task_date_due
		if task_date != {} :
			if date.day == task_date.day and date.month == task_date.month and date.year == task_date.year and loaded_task.task_progress != 100 :
				task_count += 1
				var task_text = "- " + loaded_task.task_text + "\n"
				task_description += task_text
				task_popup.add_item(task_text)
	
	if task_count > 0 :
		task_button.show()
		if task_count > 1 :
			task_button.text = "Tâches dues : " + str(task_count)
		else :
			task_button.text = "Tâche due : " + str(task_count)
		
	else :
		task_button.hide()
	


func _on_task_button_pressed() -> void:
	task_popup.popup()
	
	var button_pos = global_position
	var target_pos = Vector2i(button_pos.x, button_pos.y + size.y)
	
	task_popup.position = target_pos
