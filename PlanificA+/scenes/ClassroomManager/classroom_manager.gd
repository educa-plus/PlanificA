extends PanelContainer

@onready var group_selector = %GroupSelector
@onready var edition_mode_selector = %EditionModeSelector
@onready var desk_size_selector = %DeskSizeSelector
@onready var orientation_selector = %OrientationSelector
@onready var background_selector = %BackgroundSelector
@onready var item_menu_all = %ItemsMenuAll
@onready var class_background_node = %ClassBackGround
@onready var control_choose_name_node = %ControlChooseName
@onready var line_edit_choose_name = %LineEditChooseName

@onready var graph = $MainVbox/ClassConstructor/GraphEdit
@onready var class_manager_panel = %ClassManagerPanel
@onready var class_manager_node = %ClassManager
@onready var class_manager_path = "MainVbox/ClassConstructor/ClassManagerPanel/ClassManager"
#@onready var test = $MainVbox/PanelContainer/ClassManager/Button

var simple_desk_icon = load("res://assets/simple_desk.png")
var simple_desk_scene = load("res://scenes/ClassroomManager/ClassManagerItems/simple_desk_item.tscn")
var double_desk_icon = load("res://assets/double_desk.png")
var star_icon = load("res://assets/Gemini_Generated_Image_7lyslc7lyslc7lys.png")
var desk_theme = load("res://_theme/icon_desks.tres")

var dotted_grid_bg = load("res://assets/ClassManagerBackgrounds/grid.png")


var position_before_drag

var desk_sizes = {
	"Très petit" : Vector2(96,80),
	"Petit" : Vector2(120,100),
	"Moyen" : Vector2(150,125),
	"Grand" : Vector2(180,150),
	"Très grand" : Vector2(210,175)
}

var double_desk_sizes = {
	"Très petit" : Vector2(192,80),
	"Petit" : Vector2(240,100),
	"Moyen" : Vector2(300,125),
	"Grand" : Vector2(360,150),
	"Très grand" : Vector2(420,175)
}

var object_sizes = {
	"simple_desk" : desk_sizes,
	"double_desk" : double_desk_sizes
}

var desk_sizes_index = {
	"Très petit" : 0,
	"Petit" : 1,
	"Moyen" : 2,
	"Grand" : 3,
	"Très grand" : 4
}

var photos_relative_desk_sizes = {
	Vector2(96,80) : Vector2(36,36),
	Vector2(120,100) : Vector2(44,44),
	Vector2(150,125) : Vector2(54,54),
	Vector2(180,150) : Vector2(66,66),
	Vector2(210,175) : Vector2(78,78)
}

var font_size_relative_desk_sizes = {
	Vector2(96,80) : 10,
	Vector2(120,100) : 12,
	Vector2(150,125) : 14,
	Vector2(180,150) : 16,
	Vector2(210,175) : 18
}

var class_background_dict = {
	"Aucun" : null,
	"Grille pointillée" : dotted_grid_bg
}

var orientations = ["Vue élèves", "Vue enseignant"]

var current_object = "simple_desk"
var current_object_size_str = ""
var current_object_size = Vector2(150,125)
var desk_inversed = false

var is_custom_mode = false

func _ready() -> void:
	graph.get_v_scroll_bar().hide()
	for group in global_variables.groups :
		print(group)
		var group_code = group.name + " " + group.level + " " + group.year
		group_selector.add_item(group_code)
	
	for desk_size in desk_sizes :
		desk_size_selector.add_item(desk_size, desk_sizes_index[desk_size])
	desk_size_selector.selected = 2
	
	for orientation in orientations :
		orientation_selector.add_item(orientation)
	
	for bg in class_background_dict :
		background_selector.add_item(bg)
	
	edition_mode_selector.button_pressed = is_custom_mode
	
	class_manager_node.connect("gui_input", _on_class_manager_gui_input)

	
	
	
func _on_edition_mode_selector_toggled(toggled_on: bool) -> void:
	is_custom_mode = toggled_on
	class_manager_node.allow_drag_reorder = toggled_on
	
func _on_class_manager_gui_input(event):
	if event is InputEventMouseButton:

		for desk in get_tree().get_nodes_in_group("desk"):
			desk._hide_turn_button()
			
		if event.button_index == MOUSE_BUTTON_LEFT:
			if is_custom_mode :
				#_create_object("object", Vector2(0,0))
				_create_new_item()
		if event.button_index == MOUSE_BUTTON_RIGHT:
			print(class_manager_node.size.y/2)
			var event_position = get_global_mouse_position()
			if is_custom_mode :
				for child in class_manager_node.get_children():
					#class_manager_panel.update_targets()
					# Check if the click position is within the child's rect
					print("rect")
					print(child.get_rect())
					if child.get_rect().has_point(event_position):
						child.queue_free()
						

func _create_new_item(desk_pos = Vector2(0,0), item_rotation = 0):
	var new_item = simple_desk_scene.instantiate()
	new_item.connect("focus_entered", new_item._show_turn_button)
	#new_item.connect("focus_exited", new_item._hide_turn_button)
	new_item.connect("button_down", _manage_drag.bind("down", new_item))
	new_item.connect("button_up", _manage_drag.bind("up", new_item))
	new_item.connect("gui_input", _delete_object.bind(new_item))
	new_item.rotation = item_rotation
	var mouse_pos = get_global_mouse_position()
	if get_tree().get_nodes_in_group("desk").size() == 0 :
		class_manager_node.add_child(new_item)
		new_item.add_to_group("desk")
		if desk_inversed :
			_update_item_orientation(new_item)
		if desk_pos == Vector2(0,0) :
			new_item.position = mouse_pos - Vector2(new_item.size.x /2, new_item.size.y /2)
		else :
			new_item.position = desk_pos - Vector2(new_item.size.x /2, new_item.size.y /2)
		
		
	else :
		var is_intersecting = false
		for desk in get_tree().get_nodes_in_group("desk") :
			if get_intersection(desk, mouse_pos, new_item.get_combined_minimum_size()) == true :
				is_intersecting = true
				break
							
		if is_intersecting == false:
			class_manager_node.add_child(new_item)
			new_item.add_to_group("desk")
			new_item.owner = class_manager_node
			if desk_inversed :
				_update_item_orientation(new_item)
			if desk_pos == Vector2(0,0) :
				new_item.global_position = mouse_pos - Vector2(new_item.size.x /2, new_item.size.y /2)
			else :
				new_item.position = desk_pos - Vector2(new_item.size.x /2, new_item.size.y /2)
			
			
		else :
			if desk_pos != Vector2(0,0) :
				class_manager_node.add_child(new_item)
				new_item.add_to_group("desk")
				if desk_inversed :
					_update_item_orientation(new_item)
				new_item.position = desk_pos - Vector2(new_item.size.x /2, new_item.size.y /2)
				
				#class_manager_node.add_child(new_button)
			else :
				new_item.queue_free()
	
	
func _delete_object(event, object):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			object.queue_free()

func get_intersection(node, item_position, necessary_space) -> bool:
	var rect_size = necessary_space
	var item_rect = Rect2(item_position - rect_size / 2, rect_size)
	#var mouse_rect = Rect2(rect_size.get_center(), rect_size)
	var node_rect = node.get_global_rect()
	#print(node_rect)
	return item_rect.intersects(node_rect)

func get_intersection_drag(node, current_node) -> bool:
	var current_node_rect = current_node.get_global_rect()
	var new_size = current_node_rect.size * 0.95

# Create a new Rect2 with the same position but the new size
	var smaller_rect = Rect2(current_node_rect.position, new_size)
	#var mouse_rect = Rect2(rect_size.get_center(), rect_size)
	var node_rect = node.get_global_rect()
	#print(mouse_rect)
	#print(node_rect)
	return smaller_rect.intersects(node_rect)

func _manage_drag(type, desk):
	if type == "down" :
		position_before_drag = desk.position
		#for group_desk in get_tree().get_nodes_in_group("desk") :
		#	group_desk
	if type == "up" :
		var is_intersecting = false
		if get_tree().get_nodes_in_group("desk").size() != 0 :
			for other_desk in get_tree().get_nodes_in_group("desk") :
				if other_desk != desk and get_intersection_drag(other_desk, desk) == true:
					is_intersecting = true
					break
					
		if is_intersecting == true :
			desk.position = position_before_drag
			
func _on_group_selector_item_selected(index: int) -> void:
	var selected_group = group_selector.get_item_text(index)
	global_variables.current_selected_group = selected_group
	load_instance_data_resource()

func _on_desk_size_selector_item_selected(index: int) -> void:
	var desk_size = desk_size_selector.get_item_text(index)
	current_object_size = desk_sizes[desk_size]
	
	for desk in get_tree().get_nodes_in_group("desk") :
		desk.custom_minimum_size = current_object_size
		desk.size = desk.custom_minimum_size
		for child in desk.get_children() :
			_update_desk_children(child)


func _on_orientation_selector_item_selected(index: int) -> void:
	if index == 0 : #Vue élèves 
		desk_inversed = false
		for desk in get_tree().get_nodes_in_group("desk") :
			_update_item_orientation(desk)
				
	if index == 1 : #Vue enseignant
		desk_inversed = true
		for desk in get_tree().get_nodes_in_group("desk") :
			_update_item_orientation(desk)

func _on_background_selector_item_selected(index: int) -> void:
	var background_name = background_selector.get_item_text(index)
	var background_image = class_background_dict[background_name]
	class_background_node.texture = background_image

func _update_item_orientation(item):
	item.flip_v = desk_inversed
	var offset = 16 + item.get_combined_minimum_size().y/2 + 42
	item.position.y = class_manager_node.size.y - item.position.y - offset
	for child in item.get_children() :
		_update_desk_children(child)

func _update_desk_children(child):
	var item = child.get_parent()
	if child is TextureRect or child is Label :
		var item_size_y = item.size.y
		var previous_child_pos_y = child.position.y
		
		child.position.y = item_size_y - (previous_child_pos_y + child.size.y)

func _ordered_populate_class_manager(width_desks, height_desks):
	var class_size = class_manager_node.get_size()
	print(class_size)
	var horizontal_space = class_size.x / (width_desks + 1)
	var vertical_space = class_size.y / (height_desks + 1)
	var desk_position = Vector2(0,0)
	for w_desk in width_desks :
		desk_position.x += horizontal_space
		for h_desk in height_desks :
			desk_position.y += vertical_space
			print(desk_position)
			_create_new_item(desk_position)
		desk_position.y = 0

func _on_item_expander_pressed() -> void:
	if item_menu_all.is_visible_in_tree() :
		item_menu_all.hide()
	else :
		item_menu_all.show()

func _on_save_button_pressed() -> void:
	print(global_variables.current_selected_group)
	var plan_name = ""
	_save_new_group_plan(plan_name)

func _save_new_group_plan(plan_name):
	var save_resource = collect_save_data_into_resource()
	var filename = generate_date_coded_filename_resource(plan_name)
	var school_year = global_variables.current_school_year_dir
	var group = global_variables.current_selected_group
	var file_path = ""
	
	if plan_name == "" :
		file_path = school_year + "/" + "class_plan" + "/" + filename
	else :
		file_path = "user://" + "class_plan_models" + "/" + filename
		
	var error = ResourceSaver.save(save_resource, file_path) # Optionnel: ajouter FLAG_COMPRESS
	if error == OK:
		print("Planification save in : ", file_path)
	else:
		print("Error during the save of : ", file_path, " Erreur: ", error)
		
func collect_save_data_into_resource():
	var save_resource = SaveClassPlanData.new()
	var desk_info_dict = {}
	
	for desk in get_tree().get_nodes_in_group("desk") :
		desk_info_dict[desk.name] = {"position" : desk.position, "rotation" : desk.rotation}
		
	print(desk_info_dict)
	save_resource.desk_info_dict = desk_info_dict
	save_resource.current_size = current_object_size
	save_resource.current_orientation = desk_inversed
	
	return save_resource

func generate_date_coded_filename_resource(plan_name):
	var group = global_variables.current_selected_group
	
	if plan_name == "" :
		return "class_plan" + group + ".tres"
	else :
		return "class_plan" + plan_name + ".tres"

func load_instance_data_resource():
	var school_year = global_variables.current_school_year_dir
	var group = global_variables.current_selected_group
	if group == "" :
		group = group_selector.get_item_text(-1)
		
	var filename = "class_plan" + group + ".tres"
	var file_path = school_year + "/" + "class_plan" + "/" + filename
		
	if FileAccess.file_exists(file_path):
		var loaded_resource = load(file_path)
		if loaded_resource is SaveClassPlanData:
			apply_save_data_from_resource(loaded_resource)
			print("Resource loaded with success : ", file_path)
			
func apply_save_data_from_resource(save_resource: SaveClassPlanData):
	var loaded_desk_info_dict = save_resource.desk_info_dict
	current_object_size = save_resource.current_size
	desk_inversed = save_resource.current_orientation
	for child in class_manager_node.get_children() :
		child.queue_free()
	
	for desk_key in loaded_desk_info_dict :
		var desk_info = loaded_desk_info_dict[desk_key]
		#_create_object("object", desk_info.position)
		_create_new_item(desk_info.position, desk_info.rotation)


func _on_button_pressed() -> void:
	_ordered_populate_class_manager(6, 6)

func _on_add_class_plan_pressed() -> void:
	control_choose_name_node.show()
	line_edit_choose_name.text = ""

func _on_line_edit_choose_name_text_submitted(new_text: String) -> void:
	var plan_name = new_text
	_save_new_group_plan(plan_name)

func _populate_class_plan_models():
	var path = "user://" + "class_plan_models" + "/"
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

		dir_access.list_dir_end()
