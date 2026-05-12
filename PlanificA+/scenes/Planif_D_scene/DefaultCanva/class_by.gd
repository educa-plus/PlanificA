extends MenuButton
# Custom signals to let other nodes react

@onready var file_dialog = $FileDialog
@onready var menu_button = %ClassBy

var items_data = {
	"Année scolaire" : {"checkable" : true, "checked" : true, "id" : 0}, 
	"Date" : {"checkable" : true, "checked" : true, "id" : 2},
	"Groupe" : {"checkable" : true, "checked" : true, "id" : 1},
	"Exporter" : {"checkable" : true, "checked" : true, "id" : 3},
	"Enregistrer sous" : {"checkable" : false, "id" : 4}
	}

var corresponding_data = {
	0 : global_variables.year_string + "/",
	1 : global_variables.current_selected_group + "/",
	2 : "%04d-%02d-%02d-%01d" % [global_variables.current_date.year, global_variables.current_date.month, global_variables.current_date.day, 1] #global_variables.current_date.period
}

var is_custom_path = false
var save_path = ""

func _ready():
	# Ensure the popup is created
	if get_popup() == null:
		print("Warning: MenuButton's popup is not set. Please assign a PopupMenu.")
		return
	
	var popup = get_popup()
	popup.id_pressed.connect(_on_popup_id_pressed)
#	menu_button.connect("item_toggled", _on_menu_item_toggle)
	
	file_dialog.file_selected.connect(_on_file_dialog_file_selected)
	file_dialog.dir_selected.connect(_on_file_dialog_dir_selected)
	
	_update_save_path()

func _on_menu_item_toggle(id, is_checked):
	print(id)
	print(is_checked)

func _setup_menu_items():
	var popup = get_popup()
	popup.clear() # Clear existing items if any
	
	var non_checkable_item = null
	for key in items_data:
		var item = items_data[key]
		var item_text = key
		var id = item.id
		var is_checked = false
		if id == 4 :
			non_checkable_item = item_text
		else :
			is_checked = item.checked
		
			popup.add_check_item(item_text, id)
			#popup.set_item_id(id - 1, id)
			popup.set_item_checked(popup.get_item_count() - 1, is_checked) # Set initial checked state
	
	popup.add_item(non_checkable_item, 4)

func _on_popup_id_pressed(id: int):
	var popup = get_popup()

	# Check if the pressed item is checkable and toggle its state
	var item_index = popup.get_item_index(id)
	print(item_index)
	if item_index != -1 and popup.is_item_checkable(item_index):
		var current_checked_state = popup.is_item_checked(item_index)
		var item_text = popup.get_item_text(item_index)
		items_data[item_text]["checked"] = not current_checked_state
		
#		popup.set_item_checked(item_index, not current_checked_state)
		
		print("Item '%s' (ID: %d) toggled to: %s" % [item_text, id, not current_checked_state])
		# Emit a custom signal for the outside world to react
#		item_toggled.emit(id, not current_checked_state)
		is_custom_path = false
		_setup_menu_items()
		_update_save_path()
		
	else:
		# For non-checkable items, you might want a different signal or direct action
		print("Non-checkable item '%s' (ID: %d) pressed." % [popup.get_item_text(item_index), id])
		if id == 4 :
			_change_save_path_to_selected()

func _update_save_path():
	corresponding_data = {
		0 : global_variables.year_string + "/",
		1 : global_variables.current_selected_group + "/",
		2 : "%04d-%02d-%02d-%01d" % [global_variables.current_date.year, global_variables.current_date.month, global_variables.current_date.day, global_variables.current_date.period]
	}

	var path_element_dict = {}
	
	if not is_custom_path :
		save_path = ""
		var new_save_path = global_variables.default_user_planification_dir + "/"
		for key in items_data :
			var id = items_data[key]["id"]
			if items_data[key]["checkable"] :

				if items_data[key]["checked"] :
					if id == 3 :
						if not items_data[key]["checked"] :
							new_save_path = null
							break
						
					else :
						var info = corresponding_data[id]
						if info != "/" :
							path_element_dict[id] = info
		
		#new_save_path += "_title"
		if new_save_path != null :
			var dir_path = ""
			for i in range(0, path_element_dict.size()):
				if path_element_dict.has(i) and i != 2 :
					dir_path += path_element_dict[i]
				if path_element_dict.has(i) :
					new_save_path += path_element_dict[i]
			
			save_path = new_save_path
			_make_planification_dir_recursive(dir_path)
	
		
func _make_planification_dir_recursive(dir_path):
	
	var default_user_dir_access = DirAccess.open(global_variables.default_user_planification_dir) 
	if default_user_dir_access:
		default_user_dir_access.make_dir_recursive(dir_path) # just_directories
		
func _change_save_path_to_selected():
	file_dialog.current_dir = global_variables.default_user_planification_dir
	file_dialog.popup_centered()
	# For convenience, set up the dialog initially for directory selection
	file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	
func _on_file_dialog_file_selected(path: String):
	# This signal is emitted if FILE_MODE_OPEN_FILE or FILE_MODE_OPEN_ANY is used and a file is selected.
	items_data = {
		"Année scolaire" : {"checkable" : true, "checked" : false, "id" : 0}, 
		"Date" : {"checkable" : true, "checked" : false, "id" : 2},
		"Groupe" : {"checkable" : true, "checked" : false, "id" : 1},
		"Exporter" : {"checkable" : true, "checked" : true, "id" : 3},
		"Enregistrer sous" : {"checkable" : false, "id" : 4}
	}
	_setup_menu_items()
	is_custom_path = true
	save_path = path + ".tres"
	print("Selected file: ", path)

func _on_file_dialog_dir_selected(path: String):
	# This signal is emitted if FILE_MODE_OPEN_DIR or FILE_MODE_OPEN_ANY is used and a directory is selected.
	items_data = {
		"Année scolaire" : {"checkable" : true, "checked" : false, "id" : 0}, 
		"Date" : {"checkable" : true, "checked" : false, "id" : 2},
		"Groupe" : {"checkable" : true, "checked" : false, "id" : 1},
		"Exporter" : {"checkable" : true, "checked" : true, "id" : 3},
		"Enregistrer sous" : {"checkable" : false, "id" : 4}
	}
	_setup_menu_items()
	is_custom_path = true
	save_path = path
	print("Selected directory: ", path)
	# You can now store and use this 'path' variable for your application's logic
	# For example, save it to a variable:
	# selected_folder_path = path
