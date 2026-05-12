extends Control

@onready var category_button_nodes = get_tree().get_nodes_in_group("CategoryButton")
@onready var category_page_nodes = get_tree().get_nodes_in_group("CategoryParameter")
@onready var general_button = $PanelContainer/MarginContainer/Parameter/ParameterCategory/General
@onready var exit_button = $PanelContainer/X

#All the selectors are here
@onready var screen_size_selector = %ScreenSizeSelector
@onready var language_selector = %LanguageSelector
@onready var complex_color_selector = %ComplexColorSelector

@onready var show_title_selector = %ShowTitleSelector
@onready var show_morning_selector = %ShowMorningSelector
@onready var show_noon_selector = %ShowNoonSelector
@onready var show_evening_selector = %ShowEveningSelector
@onready var ai_resume_selector = %AIResumeSelector

var current_button = null
var global_parameter_path = global_variables.global_parameter_path

func _ready():
	for category in category_button_nodes:
		category.connect("pressed", _open_category_parameter.bind(category))
	general_button.button_pressed = true
	current_button = general_button
	
	load_instance_data_resource()
	
func _open_category_parameter(category_button):
	for category in category_page_nodes:
		if category_button.name == category.name :
			category.show()
			print(category_button.name)
			print(current_button.name)
			if category_button.name == current_button.name :
				current_button.button_pressed = true
			else :
				current_button.button_pressed = false
			current_button = category_button
		else :
			category.hide()
			

func _on_file_dialog_file_selected(path: String):
	# This signal is emitted if FILE_MODE_OPEN_FILE or FILE_MODE_OPEN_ANY is used and a file is selected.
	# It won't be called if file_mode is FILE_MODE_OPEN_DIR.
	print("Selected file: ", path)

func _on_file_dialog_dir_selected(path: String):
	# This signal is emitted if FILE_MODE_OPEN_DIR or FILE_MODE_OPEN_ANY is used and a directory is selected.
	print("Selected directory: ", path)
	# You can now store and use this 'path' variable for your application's logic
	# For example, save it to a variable:
	# selected_folder_path = path

func _on_screen_size_selector_item_selected(index: int) -> void:
	print(index)
	match index :
		0 : #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1 : #minimal
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(Vector2(1366, 768))

func _on_complex_color_selector_toggled(toggled_on: bool) -> void:
	global_variables.complex_color_activated = toggled_on
	var parameter_resource = _get_data_resource()
	if parameter_resource :
		parameter_resource.complex_color_activated = toggled_on
		var error = ResourceSaver.save(parameter_resource, global_parameter_path) # Optionnel: ajouter FLAG_COMPRESS
		if error != OK:
			print("Error during the save of : ", global_parameter_path, " Erreur: ", error)

	var main_scene_node = get_tree().current_scene
	main_scene_node.General_Panel._update_general_panel()
	
func _on_show_title_selector_toggled(toggled_on: bool) -> void:
	global_variables.show_title_activated = toggled_on
	var parameter_resource = _get_data_resource()
	if parameter_resource :
		parameter_resource.show_title_activated = toggled_on
		var error = ResourceSaver.save(parameter_resource, global_parameter_path) # Optionnel: ajouter FLAG_COMPRESS
		if error != OK:
			print("Error during the save of : ", global_parameter_path, " Erreur: ", error)

func _on_show_morning_selector_toggled(toggled_on: bool) -> void:
	var parameter_resource = _get_data_resource()
	if parameter_resource :
		parameter_resource.show_morning_activated = toggled_on
		var error = ResourceSaver.save(parameter_resource, global_parameter_path) # Optionnel: ajouter FLAG_COMPRESS
		if error != OK:
			print("Error during the save of : ", global_parameter_path, " Erreur: ", error)

func _on_show_noon_selector_toggled(toggled_on: bool) -> void:
	var parameter_resource = _get_data_resource()
	if parameter_resource :
		parameter_resource.show_noon_activated = toggled_on
		var error = ResourceSaver.save(parameter_resource, global_parameter_path) # Optionnel: ajouter FLAG_COMPRESS
		if error != OK:
			print("Error during the save of : ", global_parameter_path, " Erreur: ", error)

func _on_show_evening_selector_toggled(toggled_on: bool) -> void:
	var parameter_resource = _get_data_resource()
	if parameter_resource :
		parameter_resource.show_evening_activated = toggled_on
		var error = ResourceSaver.save(parameter_resource, global_parameter_path) # Optionnel: ajouter FLAG_COMPRESS
		if error != OK:
			print("Error during the save of : ", global_parameter_path, " Erreur: ", error)

func _on_ai_resume_selector_toggled(toggled_on: bool) -> void:
	global_variables.ai_resume_activated = toggled_on
	var parameter_resource = _get_data_resource()
	if parameter_resource :
		parameter_resource.ai_resume_activated = toggled_on
		var error = ResourceSaver.save(parameter_resource, global_parameter_path) # Optionnel: ajouter FLAG_COMPRESS
		if error != OK:
			print("Error during the save of : ", global_parameter_path, " Erreur: ", error)


func _on_go_to_website_pressed() -> void:
	OS.shell_open("https://www.planificaplus.com")

func load_instance_data_resource():
		var loaded_resource = _get_data_resource()
		if loaded_resource :
			apply_save_data_from_resource(loaded_resource)

func apply_save_data_from_resource(save_resource: SaveParametersData):
	complex_color_selector.button_pressed = save_resource.complex_color_activated
	show_title_selector.button_pressed = save_resource.show_title_activated
	show_morning_selector.button_pressed = save_resource.show_morning_activated
	show_noon_selector.button_pressed = save_resource.show_noon_activated
	show_evening_selector.button_pressed = save_resource.show_evening_activated
	ai_resume_selector.button_pressed = save_resource.ai_resume_activated

func _on_x_pressed() -> void:
	var main_scene_node = get_tree().current_scene
	var parameter_button = main_scene_node.get_node("EveryThing/OptionsContainer/OptionR/Parameter")
	parameter_button.emit_signal("pressed")

func _get_data_resource():
	if FileAccess.file_exists(global_parameter_path):
		var loaded_resource = ResourceLoader.load(global_parameter_path)
		if loaded_resource is SaveParametersData:
			return loaded_resource
