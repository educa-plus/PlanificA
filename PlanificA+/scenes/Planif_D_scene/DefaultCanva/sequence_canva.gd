extends Control

@onready var everything = $"."

#These are nodes that have a link with warnings
@onready var warning_box = $WarningBox
@onready var warning_message_label = %WarningMessageLabel
@onready var no_button = %No
@onready var yes_button = %Yes

@onready var choose_name_box = $ChooseName
@onready var choose_name_label = $ChooseName/VBoxContainer/ChooseNameStatement
@onready var choose_name_line_edit = $ChooseName/VBoxContainer/LineEdit

@onready var entire_canva = $EveryThing/Canva_Planif/Canva_De_Planif
@onready var subviewport = $EveryThing/Canva_Planif/SubViewportContainer/SubViewport
@onready var planification_vbox = $EveryThing/Canva_Planif/Canva_De_Planif/Planification
@onready var custom_canva_path = "EveryThing/Canva_Planif/Canva_De_Planif/Planification/VBigBox"
@onready var custom_canva_vbigbox = load("res://scenes/Planif_D_scene/Custom_Planification/custom_canva_no_control.tscn")

@onready var sequence_menu = load("res://scenes/Sequences/SequenceMenu.tscn")

@onready var period_label = $"EveryThing/Canva_Planif/Canva_De_Planif/Planification/InfoGenerale/InfoGenerale2/DatPerDur/Période/PanelContainer/PeriodLabel"
@onready var local_label = $EveryThing/Canva_Planif/Canva_De_Planif/Planification/InfoGenerale/InfoGenerale2/DatPerDur/Local/PanelContainer/LocalLabel
@onready var group_label = %GoupLabel
@onready var duration_label = $EveryThing/Canva_Planif/Canva_De_Planif/Planification/InfoGenerale/InfoGenerale2/DatPerDur/Durée/PanelContainer/Label
@onready var date_label = $EveryThing/Canva_Planif/Canva_De_Planif/Planification/InfoGenerale/InfoGenerale2/DatPerDur/Date/PanelContainer/Date

@onready var text_edit_nodes = get_tree().get_nodes_in_group("TextEdit")
@onready var title_label_array = get_tree().get_nodes_in_group("Title")
@onready var title_label = title_label_array[0]
@onready var option_button_nodes = get_tree().get_nodes_in_group("OptionButton")

@onready var progress_bar = $EveryThing/Canva_Planif/BarreOption/Options/Progress/PanelContainer/ProgressBar
@onready var export_file_dialog = $EveryThing/Canva_Planif/BarreOption/Options/Export/FileDialog
@onready var edit_mode_button = %EditMode

var empty_save_resource = SaveCanvaData.new()
#var text_edit_line_height: int = 30
var text_edits_dict = {}

var current_path = ""
var current_user_path = ""

signal new_custom_canva_saved

func _ready():
	var _user_data_dir = OS.get_user_data_dir()
	
	title_label.text_changed.connect(func(_new_text): save_instance_data_resource())
	
	if text_edit_nodes.is_empty():
		print("Error : No node in group text_edit")
	else:
		for textedit in text_edit_nodes:
			textedit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY  # Enable word wrap
			textedit.custom_minimum_size.y = 40
			textedit.text_changed.connect(func(): _update_size(textedit))
			textedit.connect("text_changed", save_instance_data_resource)
			
			text_edits_dict[textedit.name] = textedit
	
	export_file_dialog.file_selected.connect(_on_file_dialog_file_selected)
	progress_bar.max_value = text_edit_nodes.size()
	
	for option_button in option_button_nodes:
		option_button.connect("item_selected", func(_id): save_instance_data_resource())
		option_button.connect("item_selected", _update_period)
	
	#load_instance_data_resource(date)
	for clear_button in get_tree().get_nodes_in_group("Clear_button"):
		clear_button.connect("pressed", _on_clear_button_pressed.bind(clear_button))
		
	for separator in get_tree().get_nodes_in_group("Separator"):
		separator.connect("gui_input", global_variables._on_separator_input.bind(separator))
	
func _on_export_pressed() -> void:
	export_file_dialog.current_dir = global_variables.default_user_planification_dir
	export_file_dialog.popup_centered()
	# For convenience, set up the dialog initially for directory selection
	export_file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	export_file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	
func _on_file_dialog_file_selected(path: String):
	# This signal is emitted if FILE_MODE_OPEN_FILE or FILE_MODE_OPEN_ANY is used and a file is selected.
	if !entire_canva or !subviewport:
		print("Error: ScrollContainer or SubViewport not set up.")
		return
	
	var content_node = entire_canva.get_child(0).duplicate()
	if !content_node:
		push_error("ScrollContainer has no child content to export.")
		return
	
	var content_full_size = content_node.get_minimum_size()
	
	content_node.set_position(Vector2.ZERO)
	#content_node.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	#content_node.set_grow_direction(Control.GROW_DIRECTION_END)
	content_node.set_size(content_full_size)
	content_node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_node.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	content_node.visible = true
	subviewport.add_child(content_node)
	subviewport.set_size(content_full_size)
	print(subviewport.get_children())
	print("SubViewport size set to: ", subviewport.size)
	print(subviewport)
	#subviewport.transparent_bg = true
	subviewport.set_update_mode(SubViewport.UPDATE_ALWAYS)
	
	for i in range(5):
		await get_tree().process_frame
	#subviewport.force_update_texture()
	
	var image = subviewport.get_texture().get_image()
	
	if image:
		# Save the image
		var is_image_empty = true
		for y in range(min(image.get_height(), 100)): # Check first 100 rows for performance
			for x in range(min(image.get_width(), 100)): # Check first 100 columns
				if image.get_pixel(x, y).a > 0.001: # Check if alpha is greater than near-zero
					is_image_empty = false
					break
			if not is_image_empty:
				break
		if is_image_empty && image.get_width() > 0 && image.get_height() > 0 :
			push_error("Warning: Image captured but appears to be empty/fully transparent. This could indicate a rendering issue.")
		elif image.get_width() == 0 || image.get_height() == 0 :
			push_error("Error: Captured image has zero width or height.")
			
		var save_path = ""
		
		path = path + ".png"
		var error = image.save_png(path)
		if error == OK:
			print("Successfully exported scroll content to: %s" % path)
		else:
			push_error("Error saving image: %s" % str(error))
	else:
		push_error("Could not get image from SubViewport texture.")
	
	print("Selected file: ", path)
	
	for child in subviewport.get_children():
		child.queue_free()
		
	#original_parent.add_child(content_node)
	#content_node.set_position(Vector2.ZERO)
	
func _new_planif():
	current_path = ""
	current_user_path = ""
	load_instance_data_resource(global_variables.current_date)
	
	if edit_mode_button.button_pressed :
		get_node(custom_canva_path)._switch_mode(true)
	else :
		get_node(custom_canva_path)._switch_mode(false)
	print(current_user_path)
	
	
func _update_period(id):
	if global_variables.current_date.period > global_variables.number_of_period_AM:
		global_variables.current_date.period = id + 2
	else:
		global_variables.current_date.period = id + 1
	
func _update_size(textedit):
	var lines = textedit.get_total_visible_line_count()
	var height = textedit.get_line_height()
	var new_height = max(40, (lines * height)+ 16)  # Ensure a minimum height

	textedit.custom_minimum_size.y = new_height

func save_instance_data_resource():
	var save_resource = collect_save_data_into_resource()
	var filename = generate_date_coded_filename_resource()
	var school_year = global_variables.current_school_year_dir
	var group = global_variables.current_selected_group
	var file_path = school_year + "/" + group + "/" + filename
	if group == "" :
		file_path = school_year + "/" + "no_group" + "/" + filename
	var error = ResourceSaver.save(save_resource, file_path, ResourceSaver.FLAG_COMPRESS) # Optionnel: ajouter FLAG_COMPRESS
	if error == OK:
		print("Planification save in : ", file_path)
		print(global_variables.current_selected_group)
	else:
		print("Error during the save of : ", file_path, " Erreur: ", error)
	
	#delete older file to not have a 5x files when writing the title
	if FileAccess.file_exists(current_user_path):
		DirAccess.remove_absolute(current_user_path)
	

func collect_save_data_into_resource():
	var save_resource = SaveCanvaData.new()
	var texts_to_save = {}
	var text_sizes_to_save = {}
	var duration_string = duration_label.text
	var parts = duration_string.split(" ")
	var number_string = parts[0]
	var full_textedit_count = 0
	
	
	
	for node_name in text_edits_dict:
		var text_edit_node = text_edits_dict[node_name]
		texts_to_save[node_name] = text_edit_node.text
		if text_edit_node.text.length() > 5 :
				full_textedit_count += 1
		text_sizes_to_save[node_name] = text_edit_node.custom_minimum_size.y
	save_resource.text_entries = texts_to_save
	save_resource.text_sizes = text_sizes_to_save
	save_resource.title = title_label.text
	save_resource.duration = number_string.to_int()
	
	var custom_canva_packed_scene = PackedScene.new()
	var target_node: Node = get_node(custom_canva_path)
	target_node.queue_sort()
	for group_member in get_tree().get_nodes_in_group("inside_plus_buttons_v") :
		print(group_member.owner == target_node)
	var pack_error = custom_canva_packed_scene.pack(target_node)
	print(pack_error)
	if pack_error != OK:
		print("ERROR: PackedScene.pack() failed with code", pack_error)
	
	var local_groups_dict = {}
	for group_member in get_tree().get_nodes_in_group("inside_plus_buttons_v"):
		local_groups_dict[group_member.name] = "inside_plus_buttons_v"
	for group_member in get_tree().get_nodes_in_group("inside_plus_buttons_h"):
		local_groups_dict[group_member.name] = "inside_plus_buttons_h"
	#for group_member in get_tree().get_nodes_in_group("exterior_plus_buttons_v"):
	#	local_groups_dict[group_member.name] = "exterior_plus_buttons_v"
	for group_member in get_tree().get_nodes_in_group("exterior_plus_buttons_h"):
		local_groups_dict[group_member.name] = "exterior_plus_buttons_h"
	
	for group_member in get_tree().get_nodes_in_group("inside_minus_buttons_v"):
		local_groups_dict[group_member.name] = "inside_minus_buttons_v"
	for group_member in get_tree().get_nodes_in_group("inside_minus_buttons_h"):
		local_groups_dict[group_member.name] = "inside_minus_buttons_h"
	for group_member in get_tree().get_nodes_in_group("exterior_minus_buttons_v"):
		local_groups_dict[group_member.name] = "exterior_minus_buttons_v"
	for group_member in get_tree().get_nodes_in_group("exterior_minus_buttons_h"):
		local_groups_dict[group_member.name] = "exterior_minus_buttons_h"
	
	for group_member in get_tree().get_nodes_in_group("text_edit_nodes"):
		local_groups_dict[group_member.name] = "text_edit_nodes"
	
	for group_member in get_tree().get_nodes_in_group("headings"):
		local_groups_dict[group_member.name] = "headings"
		
	for group_member in get_tree().get_nodes_in_group("sub_headings"):
		local_groups_dict[group_member.name] = "sub_headings"
	
	for group_member in get_tree().get_nodes_in_group("interpolated_containers"):
		local_groups_dict[group_member.name] = "interpolated_containers"
	
	print(local_groups_dict)
	
	save_resource.local_groups_dict = local_groups_dict
	save_resource.custom_canva = custom_canva_packed_scene

	progress_bar.value = full_textedit_count
	#duration_label.text = str(loaded_duration) + " minutes"
	return save_resource

func generate_date_coded_filename_resource():
	var date = global_variables.current_date
	var day = date.day
	var month = date.month
	var year = date.year
	var period = date.period

	return "planification_%04d-%02d-%02d-%01d.tres" % [year, month, day, period]
	
func load_instance_data_resource(date):
	var day = date.day
	var month = date.month
	var year = date.year
	var period = date.period
	var filename = "planification_%04d-%02d-%02d-%01d.tres" % [year, month, day, period]
	var school_year = global_variables.current_school_year_dir
	var group = global_variables.current_selected_group
	var file_path = school_year + "/" + group + "/" + filename
	
	if group == "" :
		file_path = school_year + "/" + "no_group" + "/" + filename
		
	if FileAccess.file_exists(file_path):
		var loaded_resource = load(file_path)
		if loaded_resource is SaveCanvaData:
			apply_save_data_from_resource(loaded_resource)
			print("Resource loaded with success : ", file_path)
			return true
		else:
			print("The resource is not valid : ", file_path)
			return false
	else:
		apply_save_data_from_resource(empty_save_resource)
		return false
		
func apply_save_data_from_resource(save_resource: SaveCanvaData):
	var loaded_texts = save_resource.text_entries
	var loaded_sizes = save_resource.text_sizes
	var loaded_title = save_resource.title
	var loaded_duration = save_resource.duration
	var loaded_items_data = save_resource.items_data
	var loaded_is_custom_path = save_resource.is_custom_path
	var loaded_custom_path = save_resource.custom_path
	var loaded_custom_canva = save_resource.custom_canva
	var loaded_local_groups_dict = save_resource.local_groups_dict
	
	
	if loaded_custom_canva != null :
		_add_custom_canva(loaded_custom_canva, loaded_local_groups_dict)
	else :
		var custom_canva = custom_canva_vbigbox.instantiate()
		planification_vbox.add_child(custom_canva)
		planification_vbox.move_child(custom_canva, planification_vbox.get_child_count() - 2)
		var target_node: Node = get_node(custom_canva_path)
		target_node.queue_free()
		custom_canva_path = get_path_to(custom_canva)
		custom_canva.connect("custom_text_changed", save_instance_data_resource)
	
	var date = global_variables.current_date
	var day = date.day
	var month = date.month
	var year = date.year
	var period = date.period
	date_label.text = "%04d-%02d-%02d" % [year, month, day]
	
	var date_dict = {"day": day, "month": month, "year":year}
	var schedule = 0
	var subject = ""
	var local = ""
	
	if global_variables.filtered_dict_of_school_days.has(date_dict):
		schedule = global_variables.filtered_dict_of_school_days[date_dict]

	for group in global_variables.groups :
		var group_code = group.name + " " + group.level + " " + group.year
		if group_code == global_variables.current_selected_group :
			subject = group.subject

	for schedule_dict in global_variables.group_schedules :
		if schedule_dict.day == schedule and schedule_dict.group == global_variables.current_selected_group and schedule_dict.period == period :
			local = schedule_dict.local
	
	title_label.text = loaded_title
	group_label.text =  str(global_variables.current_selected_group) + " - " + subject
	period_label.text = str(global_variables.current_date.period)
	local_label.text = local
	duration_label.text = str(loaded_duration) + " minutes"
	
	var full_textedit_count = 0
	for node_name in text_edits_dict:
		var text_edit_node = text_edits_dict[node_name]
		
		if loaded_texts.has(node_name):
			text_edit_node.text = loaded_texts[node_name]
			if text_edit_node.text.length() > 5 :
				full_textedit_count += 1
			
			text_edit_node.custom_minimum_size.y = loaded_sizes[node_name]
			text_edit_node.update_minimum_size()

		else:
			text_edit_node.text = "" 
			
	progress_bar.value = full_textedit_count

func _add_custom_canva(loaded_custom_canva, loaded_local_groups_dict):
		var recreated_ui_instance = loaded_custom_canva.instantiate()
		planification_vbox.add_child(recreated_ui_instance)
		planification_vbox.move_child(recreated_ui_instance, planification_vbox.get_child_count() - 2)
		var target_node: Node = get_node(custom_canva_path)
		target_node.queue_free()
		custom_canva_path = get_path_to(recreated_ui_instance)
		recreated_ui_instance.connect("custom_text_changed", save_instance_data_resource)
		
		for node in loaded_local_groups_dict :
			var child = _iterate_all_descendants(recreated_ui_instance, node)
			var group = loaded_local_groups_dict[node]
			child.add_to_group(group)
			if child is Button :
				recreated_ui_instance._update_buttons_connections(child)
			if child is TextEdit :
				recreated_ui_instance._update_text_edit_connections(child)
			if child is LineEdit :
				
				if child.editable == true :
					edit_mode_button.button_pressed = true
				if child.editable == false :
					edit_mode_button.button_pressed = false
					
				recreated_ui_instance._update_headings_connections(child)
			
			if child is InterpolatedFlowContainer :
				for i in range(2):
					await get_tree().process_frame
				child.queue_sort()
			#print(loaded_local_groups_dict[child])
			print()
			print(child)
			print()
		
		
		
func _iterate_all_descendants(node: Node, target_node):
	var children = node.get_children()

	# Recursively call this function for each child
	for child in children:
		
		if child.name == target_node :
			#print("true")
			return child
		
		var child_in_child_branch = _iterate_all_descendants(child, target_node)
		if child_in_child_branch :
			return child_in_child_branch 
	
	return null

func _on_button_pressed() -> void:
	var pos = get_global_mouse_position()
	var text_edit = TextEdit.new()
	var parent = $"."
	text_edit.position = pos
	text_edit.custom_minimum_size = Vector2(160, 30)
	
	text_edit.connect("focus_exited", _on_focus_exited.bind(text_edit, parent))
	
	parent.add_child(text_edit)
	text_edit.grab_focus()

func _on_focus_exited(text_edit, _parent) :
	text_edit.queue_free()
	print("exit")

func _on_clear_button_pressed(clear_button) -> void:
	var container = clear_button.get_parent().get_parent()
	for child in container.get_children():
		if child is TextEdit :
			child.text = ""
			_update_size(child)
	print("clear")
	save_instance_data_resource()
	
func _on_edit_mode_toggled(toggled_on: bool) -> void:
	var custom_canva_node = get_node(custom_canva_path)
	
	if toggled_on :
		warning_message_label.text = "En passant en mode éditeur, vous pourrez modifier les titres et les textes de substitution de votre gabarit"
		warning_message_label.text += "\n[font_size=12][color=red](Tous les textes contenues dans les boites de textes seront perdus)[/color][/font_size]"
		warning_box.show()
		
		#It is good practice to disconnect the existing connections to avoid calling multiple functions
		var no_button_connections = no_button.pressed.get_connections()
		for connection in no_button_connections:
			var callable_to_disconnect = connection.callable
			no_button.pressed.disconnect(callable_to_disconnect)
		#This function mean stop
		no_button.connect("pressed", _go_to_edit_mode.bind(false))
		
		#It is good practice to disconnect the existing connections to avoid calling multiple functions
		var yes_button_connections = yes_button.pressed.get_connections()
		for connection in yes_button_connections:
			var callable_to_disconnect = connection.callable
			yes_button.pressed.disconnect(callable_to_disconnect)
		#This function mean go forward
		yes_button.connect("pressed", _go_to_edit_mode.bind(true))
	
	if not toggled_on :
		custom_canva_node._switch_mode(toggled_on)
		
func _go_to_edit_mode(go_forward):
	if go_forward :
		get_node(custom_canva_path)._switch_mode(true)
		edit_mode_button.button_pressed = true
	else :
		get_node(custom_canva_path)._switch_mode(false)
		edit_mode_button.button_pressed = false
	warning_box.hide()

func _save_custom_canva_in_tree():
		warning_message_label.text = "Voulez-vous sauvegarder ce gabarit ?"
		warning_message_label.text += "\n[font_size=12][color=red](Tous les textes contenues dans les boites de textes seront également sauvegardés)[/color][/font_size]"
		warning_box.show()
		
		#It is good practice to disconnect the existing connections to avoid calling multiple functions
		var no_button_connections = no_button.pressed.get_connections()
		for connection in no_button_connections:
			var callable_to_disconnect = connection.callable
			no_button.pressed.disconnect(callable_to_disconnect)
		#This function mean stop
		no_button.connect("pressed", _save_new_custom_canva.bind("", false))
		
		#It is good practice to disconnect the existing connections to avoid calling multiple functions
		var yes_button_connections = yes_button.pressed.get_connections()
		for connection in yes_button_connections:
			var callable_to_disconnect = connection.callable
			yes_button.pressed.disconnect(callable_to_disconnect)
		#This function mean go forward
		yes_button.connect("pressed", _choose_name.bind("new_custom_canva"))

func _choose_name(name_function):
	warning_box.hide()
	for connection in choose_name_line_edit.get_signal_connection_list("text_submitted"):
			var callable = connection.callable
			choose_name_line_edit.disconnect("text_submitted", callable)
	
	choose_name_line_edit.text = ""
	
	if name_function == "new_custom_canva" :
		choose_name_label.text = "Comment voulez-vous nommer ce gabarit ?"
		choose_name_line_edit.connect("text_submitted", _save_new_custom_canva.bind(true))
	choose_name_box.show()

func _save_new_custom_canva(choosen_name, go_forward):
	choose_name_box.hide()
	if go_forward == true :
		var custom_canva_packed_scene = PackedScene.new()
		var target_node: Node = get_node(custom_canva_path)

		var pack_error = custom_canva_packed_scene.pack(target_node)
		if pack_error != OK:
			print("ERROR: PackedScene.pack() failed with code", pack_error)
		
		var local_groups_dict = {}
		for group_member in get_tree().get_nodes_in_group("inside_plus_buttons_v"):
			local_groups_dict[group_member.name] = "inside_plus_buttons_v"
		for group_member in get_tree().get_nodes_in_group("inside_plus_buttons_h"):
			local_groups_dict[group_member.name] = "inside_plus_buttons_h"
		#for group_member in get_tree().get_nodes_in_group("exterior_plus_buttons_v"):
		#	local_groups_dict[group_member.name] = "exterior_plus_buttons_v"
		for group_member in get_tree().get_nodes_in_group("exterior_plus_buttons_h"):
			local_groups_dict[group_member.name] = "exterior_plus_buttons_h"
		
		for group_member in get_tree().get_nodes_in_group("inside_minus_buttons_v"):
			local_groups_dict[group_member.name] = "inside_minus_buttons_v"
		for group_member in get_tree().get_nodes_in_group("inside_minus_buttons_h"):
			local_groups_dict[group_member.name] = "inside_minus_buttons_h"
		for group_member in get_tree().get_nodes_in_group("exterior_minus_buttons_v"):
			local_groups_dict[group_member.name] = "exterior_minus_buttons_v"
		for group_member in get_tree().get_nodes_in_group("exterior_minus_buttons_h"):
			local_groups_dict[group_member.name] = "exterior_minus_buttons_h"
		
		for group_member in get_tree().get_nodes_in_group("text_edit_nodes"):
			local_groups_dict[group_member.name] = "text_edit_nodes"
		
		for group_member in get_tree().get_nodes_in_group("headings"):
			local_groups_dict[group_member.name] = "headings"
			
		for group_member in get_tree().get_nodes_in_group("sub_headings"):
			local_groups_dict[group_member.name] = "sub_headings"
		
		for group_member in get_tree().get_nodes_in_group("interpolated_containers"):
			local_groups_dict[group_member.name] = "interpolated_containers"
		
		var file_path = "user://" + "tree_data.tres"
		if FileAccess.file_exists(file_path):
			var loaded_resource = load(file_path)
			loaded_resource.custom_canvas_dict[choosen_name] = custom_canva_packed_scene
			loaded_resource.custom_local_group_dict[choosen_name] = local_groups_dict
			var error = ResourceSaver.save(loaded_resource, file_path) # Optionnel: ajouter FLAG_COMPRESS
			if error == OK:
				print("Planification save in : ", file_path)
			else:
				print("Error during the save of : ", file_path, " Erreur: ", error)
		new_custom_canva_saved.emit()
		
	warning_box.hide()
		
func _apply_custom_canva(packed_scene, local_groups):
	var vbigbox = get_node(custom_canva_path)
	var vbigbox_size = vbigbox.get_children().size()
	var children = vbigbox.get_children()
	if vbigbox_size > 1 :
		for i in range(vbigbox_size - 1) :
			children[i].queue_free()
	
	_add_custom_canva(packed_scene, local_groups)
