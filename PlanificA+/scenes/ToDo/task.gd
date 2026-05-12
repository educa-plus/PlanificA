extends PanelContainer

@export var task_code = ""
@export var task_order = -1
@export var date_due = {}

@onready var pre_separator = %PreHSeparator

@onready var date_selector_popup = %DateSelectorPopup
@onready var date_selector = %DateSelector

@onready var slidable_progress_bar = %SlidableProgressBar
@onready var progress_slider = %ProgressSlider
@onready var text_edit = %TaskText

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#_load_instance_task_resource()

func _on_date_selector_pressed() -> void:
	date_selector_popup.popup()
	
	var button_pos = global_position
	var target_pos = Vector2i(button_pos.x, button_pos.y + size.y)
	
	date_selector_popup.position = target_pos

func _on_date_selector_popup_visibility_changed() -> void:
	if date_selector_popup != null :
		if not date_selector_popup.visible :
			if date_selector_popup.choosen_date != {}:
				date_due = date_selector_popup.choosen_date
				date_selector.text = "%04d/%02d/%02d" % [date_due.year, date_due.month, date_due.day]
				_save_instance_task_resource()

func _on_slidable_progress_bar_completed() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.finished.connect(queue_free)

func _on_slidable_progress_bar_was_completed() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.finished.connect(queue_free)

func _save_instance_task_resource():
	var filename = _generate_task_coded_filename_resource()
	var file_path = "user://" + "to_do_list" + "/" + filename
	var data_resource = null
	if FileAccess.file_exists(file_path):
		var loaded_resource = load(file_path)
		if loaded_resource is SaveTodoData :
			data_resource = loaded_resource
	else :
		data_resource = SaveTodoData.new()
		
	data_resource.task_text = text_edit.text
	data_resource.task_progress = progress_slider.value
	data_resource.task_date_due = date_due
	data_resource.task_code = task_code
	data_resource.task_order = task_order
	
	var error = ResourceSaver.save(data_resource, file_path) # Optionnel: ajouter FLAG_COMPRESS
	if error != OK:
		print("Error during the save of : ", file_path, " Erreur: ", error)
		
func _generate_task_coded_filename_resource():
	var filename = "task_" + task_code + ".tres"
	return filename
	
func _generate_random_code() -> String:
	var unix_time = Time.get_unix_time_from_system()
	var random_val = randi() % 10000
	return "%d_%d" % [unix_time, random_val]

func _load_instance_task_resource():
	var filename = _generate_task_coded_filename_resource()
	var file_path = "user://" + "to_do_list" + "/" + filename
	var data_resource = null
	if FileAccess.file_exists(file_path):
		var loaded_resource = load(file_path)
		if loaded_resource is SaveTodoData :
			data_resource = loaded_resource
	else :
		data_resource = SaveTodoData.new()
		task_code = _generate_random_code()
		
	text_edit.text = data_resource.task_text
	progress_slider.value = data_resource.task_progress
	date_due = data_resource.task_date_due
	if date_due != {} :
		date_selector.text = "%04d/%02d/%02d" % [date_due.year, date_due.month, date_due.day]
	else :
		date_selector.text = "AAAA/MM/JJ"
		
	slidable_progress_bar.current_value = data_resource.task_progress
	
	#if task_order == 0 :
	#	pre_separator.hide()
	
func _on_slidable_progress_bar_modified() -> void:
	_save_instance_task_resource()

func _on_task_text_text_changed() -> void:
	_save_instance_task_resource()

func _on_delete_task_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.connect("finished", queue_free)
	
	var filename = _generate_task_coded_filename_resource()
	var file_path = "user://" + "to_do_list" + "/" + filename
	var error = DirAccess.remove_absolute(file_path)
