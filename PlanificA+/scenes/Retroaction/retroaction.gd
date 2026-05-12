extends PanelContainer

@onready var heading = $VBoxContainer/Heading
@onready var empty_retroaction_resource = load("res://Resources/empty_retroaction_resource.tres")

func _ready() -> void:
	
	var split_container_nodes = get_tree().get_nodes_in_group("split_container_nodes")
	for split_container in split_container_nodes:
		split_container.connect("drag_ended", _on_stars_drag_ended.bind(split_container))
	
	var text_edit_nodes = get_tree().get_nodes_in_group("text_edit_nodes")
	for textedit in text_edit_nodes:
		textedit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY  # Enable word wrap
		textedit.custom_minimum_size.y = 40
		textedit.connect("text_changed",_update_size.bind(textedit))

	
	
func _update_size(textedit):
	var lines = textedit.get_total_visible_line_count()
	var height = textedit.get_line_height()
	var new_height = max(40, (lines * height)+ 16)  # Ensure a minimum height

	textedit.custom_minimum_size.y = new_height
	save_instance_data_resource()

func _on_stars_drag_ended(_split_container):
	print(_split_container.split_offset)
	save_instance_data_resource()

func save_instance_data_resource():
	var save_resource = collect_save_data_into_resource()
	var filename = generate_date_coded_filename_resource()
	var school_year = global_variables.current_school_year_dir
	var file_path = school_year + "/" + "retroaction" + "/" + filename
	
	var error = ResourceSaver.save(save_resource, file_path, ResourceSaver.FLAG_COMPRESS) # Optionnel: ajouter FLAG_COMPRESS
	if error == OK:
		print("Planification save in : ", file_path)
	else:
		print("Error during the save of : ", file_path, " Erreur: ", error)

func collect_save_data_into_resource():
	var save_resource = SaveRetroactionData.new()
	var total_offset = 0
	var split_container_nodes = get_tree().get_nodes_in_group("split_container_nodes")
	for split_container in split_container_nodes:
		var offset = split_container.split_offset
		var percent = ((offset - 10) * 100) / 202
		total_offset += offset
		save_resource.stars_offset_results[split_container.name] = offset
		save_resource.stars_percent_results[split_container.name] = percent
	
	var average = total_offset / split_container_nodes.size()
	save_resource.average_offset = average
	
	var text_edit_nodes = get_tree().get_nodes_in_group("text_edit_nodes")
	for text_edit in text_edit_nodes:
		save_resource.text_edit_content[text_edit.name] = text_edit.text
	
	return save_resource
	
func generate_date_coded_filename_resource():
	var date = global_variables.current_date
	var day = date.day
	var month = date.month
	var year = date.year
	var period = date.period

	return "retroaction_%04d-%02d-%02d-%01d.tres" % [year, month, day, period]

func load_instance_data_resource():
	var date = global_variables.current_date
	var day = date.day
	var month = date.month
	var year = date.year
	var period = date.period
	
	var month_name = global_variables.months[month - 1]
	heading.text = "Êtes-vous satisfait du cours du " + str(day) + " " + month_name + " " + str(year) + " période " + str(period) + " ?"
	
	var filename = "retroaction_%04d-%02d-%02d-%01d.tres" % [year, month, day, period]
	var school_year = global_variables.current_school_year_dir
	var file_path = school_year + "/" + "retroaction" + "/" + filename
	
	if FileAccess.file_exists(file_path):
		var loaded_resource = load(file_path)
		if loaded_resource is SaveRetroactionData:
			apply_save_data_from_resource(loaded_resource)
			print("Resource loaded with success : ", file_path)
			return true
		else:
			print("The resource is not valid : ", file_path)
			return false
	else :
		apply_save_data_from_resource(empty_retroaction_resource)
		
func apply_save_data_from_resource(save_resource: SaveRetroactionData):
	var loaded_stars_offset_results = save_resource.stars_offset_results
	var loaded_text_edit_content = save_resource.text_edit_content
	
	var text_edit_nodes = get_tree().get_nodes_in_group("text_edit_nodes")
	for text_edit_node in text_edit_nodes:
		if loaded_text_edit_content.has(text_edit_node.name):
			text_edit_node.text = loaded_text_edit_content[text_edit_node.name]

	var split_container_nodes = get_tree().get_nodes_in_group("split_container_nodes")
	for split_container_node in split_container_nodes :
		if loaded_stars_offset_results.has(split_container_node.name) :
			split_container_node.split_offset = loaded_stars_offset_results[split_container_node.name]


func _on_erase_pressed() -> void:
	var date = global_variables.current_date
	var day = date.day
	var month = date.month
	var year = date.year
	var period = date.period
	var filename = "retroaction_%04d-%02d-%02d-%01d.tres" % [year, month, day, period]
	var school_year = global_variables.current_school_year_dir
	var file_path = school_year + "/" + "retroaction" + "/" + filename
	
	if FileAccess.file_exists(file_path):
		var dir = DirAccess.open("user://")
		if dir:
			var error = dir.remove(file_path)
			if error != OK:
				print("Error removing file: ", error)
			else:
				print("File removed successfully!")
				
	var main_scene_node = get_tree().current_scene
	main_scene_node._quit_retroaction()

func _on_next_pressed() -> void:
	var main_scene_node = get_tree().current_scene
	main_scene_node._quit_retroaction()
