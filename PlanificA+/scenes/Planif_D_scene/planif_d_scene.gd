extends Control

@onready var resize_handle = $Everything/ResizeHandle
var is_resizing = false
var text_edit_line_height: int = 30

func _ready():
	
	for textedit in get_tree().get_nodes_in_group("TextEdit"):
		textedit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY  # Enable word wrap
		textedit.custom_minimum_size.y = 35
		textedit.text_changed.connect(func(): _update_size(textedit))
		textedit.text_set.connect(func(): _update_size(textedit))
	
	for separator in get_tree().get_nodes_in_group("Separator"):
		separator.connect("gui_input", _on_separator_input.bind(separator))
		print("ok")
		
	resize_handle.connect("gui_input", _on_resize_handle_input)

func _update_size(textedit):
	var lines = textedit.get_total_visible_line_count()
	var height = textedit.get_line_height()
	var new_height = max(35, (lines * height)+10)  # Ensure a minimum height
	textedit.custom_minimum_size.y = new_height
	
func _on_resize_handle_input(event):
	if event is InputEventMouseMotion:
		resize_handle.mouse_default_cursor_shape = Control.CURSOR_HSIZE
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_resizing = event.pressed
			 # Start or stop resizing
	elif event is InputEventMouseMotion and is_resizing:
		# Calculate new size based on mouse position
		var new_size = get_local_mouse_position()
		# Ensure minimum size
		new_size.x = max(new_size.x, 50)  # Minimum width
		new_size.y = max(new_size.y, 20)  # Minimum height
		var parent_node = resize_handle.get_parent()  # Get the parent of the resize_handle
		var sibling : Node = null
		if parent_node:
				# Loop through all children of the parent node
			for child in parent_node.get_children():
					# Find the sibling (other than the resize_handle itself)
				if child != resize_handle:
					sibling = child
					break
		sibling.custom_minimum_size = new_size
		print(new_size)
		
func _on_separator_input(event, separator):
	if event is InputEventMouseMotion:
		if separator is VSeparator:
			separator.mouse_default_cursor_shape = Control.CURSOR_HSIZE
		if separator is HSeparator:
			separator.mouse_default_cursor_shape = Control.CURSOR_VSIZE
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_resizing = event.pressed
			 # Start or stop resizing
	elif event is InputEventMouseMotion and is_resizing:
		# Calculate new size based on mouse position
		var new_size = get_global_mouse_position()
		# Ensure minimum size
		new_size.x = max(new_size.x, 50)  # Minimum width
		new_size.y = max(new_size.y, 20)  # Minimum height
		var parent_node = separator.get_parent()  # Get the parent of the resize_handle
		var sibling : Node = null
		var last_child = null
		var initial_minimum = null
		if parent_node:
				# Loop through all children of the parent node
			for child in parent_node.get_children():
				if child == separator:
					sibling = last_child  # The last visited child is the one above the separator
					initial_minimum = sibling.size.x + 5 # 5 is only a security threshold
					break  # Stop searching once we found the separator
				last_child = child  # Update last_child before moving to the next one
		
		if separator is VSeparator:
			sibling.custom_minimum_size.x = new_size.x - sibling.global_position.x -10 #Éventuellement améliorer pour prendre en compte l'espacement
			if sibling.custom_minimum_size.x < initial_minimum :
				sibling.set_h_size_flags(Control.SIZE_SHRINK_BEGIN)
		if separator is HSeparator:
			sibling.custom_minimum_size.y = new_size.y - sibling.global_position.y -10
		
		
