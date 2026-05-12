extends Control

@onready var main_vbox = $"."

var minus_icon = load("res://_theme/_icons/MinusIcon.png")
var plus_icon = load("res://_theme/_icons/PlusIcon.png")
var icon_theme = load("res://_theme/icons_button.tres")

var text_edit_minimum_size = 80

signal custom_text_changed

func _ready():
	print("the custom canva is ready")
	for plus_button in get_tree().get_nodes_in_group("inside_plus_buttons_v"):
		plus_button.connect("mouse_entered", _expand_plus_button.bind(plus_button))
		plus_button.connect("mouse_exited", _shrink_plus_button.bind(plus_button))
		plus_button.connect("gui_input", _on_plus_button_pressed.bind(plus_button))
		#plus_button.connect("pressed", _shrink_plus_button.bind(plus_button))
	
	for plus_button in get_tree().get_nodes_in_group("inside_plus_buttons_h"):
		plus_button.connect("mouse_entered", _expand_plus_button.bind(plus_button))
		plus_button.connect("mouse_exited", _shrink_plus_button.bind(plus_button))
		plus_button.connect("gui_input", _on_plus_button_pressed.bind(plus_button))
	
	for plus_button in get_tree().get_nodes_in_group("exterior_plus_buttons_v"):
		plus_button.connect("mouse_entered", _expand_plus_button.bind(plus_button))
		plus_button.connect("mouse_exited", _shrink_plus_button.bind(plus_button))
		plus_button.connect("gui_input", _on_plus_button_pressed.bind(plus_button))
	
	for plus_button in get_tree().get_nodes_in_group("exterior_plus_buttons_h"):
		plus_button.connect("mouse_entered", _expand_plus_button.bind(plus_button))
		plus_button.connect("mouse_exited", _shrink_plus_button.bind(plus_button))
		plus_button.connect("gui_input", _on_plus_button_pressed.bind(plus_button))
	
	for plus_button in get_tree().get_nodes_in_group("inside_minus_buttons_v"):
		plus_button.connect("mouse_entered", _expand_plus_button.bind(plus_button))
		plus_button.connect("mouse_exited", _shrink_plus_button.bind(plus_button))
		plus_button.connect("gui_input", _on_plus_button_pressed.bind(plus_button))
		#plus_button.connect("pressed", _shrink_plus_button.bind(plus_button))
	
	for plus_button in get_tree().get_nodes_in_group("inside_minus_buttons_h"):
		plus_button.connect("mouse_entered", _expand_plus_button.bind(plus_button))
		plus_button.connect("mouse_exited", _shrink_plus_button.bind(plus_button))
		plus_button.connect("gui_input", _on_plus_button_pressed.bind(plus_button))
	
	for plus_button in get_tree().get_nodes_in_group("exterior_minus_buttons_v"):
		plus_button.connect("mouse_entered", _expand_plus_button.bind(plus_button))
		plus_button.connect("mouse_exited", _shrink_plus_button.bind(plus_button))
		plus_button.connect("gui_input", _on_plus_button_pressed.bind(plus_button))
	
	for plus_button in get_tree().get_nodes_in_group("exterior_minus_buttons_h"):
		plus_button.connect("mouse_entered", _expand_plus_button.bind(plus_button))
		plus_button.connect("mouse_exited", _shrink_plus_button.bind(plus_button))
		plus_button.connect("gui_input", _on_plus_button_pressed.bind(plus_button))
	
	for separator in get_tree().get_nodes_in_group("v_separators"):
		separator.connect("gui_input", _on_separator_input.bind(separator))

	for text_edit in get_tree().get_nodes_in_group("text_edit_nodes"):
		text_edit.connect("text_changed", _emit_update_signal.bind(text_edit.text))
		
	for sub_heading in get_tree().get_nodes_in_group("sub_headings"):
		sub_heading.connect("text_changed", _emit_update_signal)
	
	for heading in get_tree().get_nodes_in_group("headings"):
		heading.connect("text_changed", _emit_update_signal)

func _update_buttons_connections(plus_button):
	plus_button.connect("mouse_entered", _expand_plus_button.bind(plus_button))
	plus_button.connect("mouse_exited", _shrink_plus_button.bind(plus_button))
	plus_button.connect("gui_input", _on_plus_button_pressed.bind(plus_button))

func _update_text_edit_connections(text_edit):
	text_edit.connect("text_changed", _emit_update_signal.bind(text_edit.text))

func _update_headings_connections(heading):
	heading.connect("text_changed", _emit_update_signal)

func _update_separator_connections(separator):
	separator.connect("gui_input", _on_separator_input.bind(separator))

func _expand_plus_button(plus_button):
	plus_button.custom_minimum_size.y = 28
	plus_button.custom_minimum_size.x = 28
	if not plus_button.is_in_group("exterior_plus_buttons_v") and not plus_button.is_in_group("exterior_minus_buttons_v"):
		var parent = plus_button.get_parent()
		while parent is not InterpolatedFlowContainer :
			parent = parent.get_parent()
			if parent is InterpolatedFlowContainer :
				break
		parent.queue_sort()

func _shrink_plus_button(plus_button):
	plus_button.custom_minimum_size.y = 0
	plus_button.custom_minimum_size.x = 0
	if not plus_button.is_in_group("exterior_plus_buttons_v") and not plus_button.is_in_group("exterior_minus_buttons_v"):
		var parent = plus_button.get_parent()
		while parent is not InterpolatedFlowContainer :
			parent = parent.get_parent()
			if parent is InterpolatedFlowContainer :
				break
		parent.queue_sort()
	
func _on_plus_button_pressed(event, plus_button):
	if event is InputEventMouseButton:
		if event.pressed:

			if event.button_index == MOUSE_BUTTON_LEFT:
				if plus_button.is_in_group("inside_plus_buttons_v"):
					_add_sub_heading(plus_button)
				
				if plus_button.is_in_group("inside_minus_buttons_v"):
					_substract_sub_heading(plus_button)
					
				if plus_button.is_in_group("inside_plus_buttons_h"):
					_add_side_heading(plus_button)
					
				if plus_button.is_in_group("inside_minus_buttons_h"):
					_substract_side_heading(plus_button)
					
				if plus_button.is_in_group("exterior_plus_buttons_v"):
					_add_interpolated_container(plus_button)
					
				if plus_button.is_in_group("exterior_minus_buttons_v"):
					_substract_interpolated_container(plus_button)
					
				if plus_button.is_in_group("exterior_plus_buttons_h"):
					_add_panel_container(plus_button)
					
				if plus_button.is_in_group("exterior_minus_buttons_h"):
					_substract_panel_container(plus_button)
					
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				
				if plus_button.is_in_group("inside_plus_buttons_v"):
					plus_button.remove_from_group("inside_plus_buttons_v")
					plus_button.add_to_group("inside_minus_buttons_v")
					plus_button.icon = minus_icon
				
				elif plus_button.is_in_group("inside_minus_buttons_v"):
					plus_button.remove_from_group("inside_minus_buttons_v")
					plus_button.add_to_group("inside_plus_buttons_v")
					plus_button.icon = plus_icon
				
				elif plus_button.is_in_group("inside_plus_buttons_h"):
					plus_button.remove_from_group("inside_plus_buttons_h")
					plus_button.add_to_group("inside_minus_buttons_h")
					plus_button.icon = minus_icon
				
				elif plus_button.is_in_group("inside_minus_buttons_h"):
					plus_button.remove_from_group("inside_minus_buttons_h")
					plus_button.add_to_group("inside_plus_buttons_h")
					plus_button.icon = plus_icon
				
				elif plus_button.is_in_group("exterior_plus_buttons_h"):
					plus_button.remove_from_group("exterior_plus_buttons_h")
					plus_button.add_to_group("exterior_minus_buttons_h")
					plus_button.icon = minus_icon
					
				elif plus_button.is_in_group("exterior_minus_buttons_h"):
					plus_button.remove_from_group("exterior_minus_buttons_h")
					plus_button.add_to_group("exterior_plus_buttons_h")
					plus_button.icon = plus_icon
				
				elif plus_button.is_in_group("exterior_plus_buttons_v"):
					plus_button.remove_from_group("exterior_plus_buttons_v")
					plus_button.add_to_group("exterior_minus_buttons_v")
					plus_button.icon = minus_icon
				
				elif plus_button.is_in_group("exterior_minus_buttons_v"):
					plus_button.remove_from_group("exterior_minus_buttons_v")
					plus_button.add_to_group("exterior_plus_buttons_v")
					plus_button.icon = plus_icon
				
func _add_sub_heading(plus_button):
	var vlittlebox = plus_button.get_parent()
	#var h_separator = HSeparator.new()
	var sub_heading = LineEdit.new()
	sub_heading.placeholder_text = "Sous-titre"
	sub_heading.expand_to_text_length = true
	sub_heading.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	sub_heading.connect("text_changed", _emit_update_signal)
	sub_heading.add_to_group("sub_headings")
	
	var text_edit = TextEdit.new()
	text_edit.placeholder_text = "Texte de substitution"
	text_edit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	text_edit.custom_minimum_size.y = text_edit_minimum_size
	text_edit.size_flags_vertical = Control.SIZE_EXPAND_FILL
	text_edit.connect("text_changed", _emit_update_signal.bind(text_edit.text))
	text_edit.add_to_group("text_edit_nodes")
	
	vlittlebox.add_child(sub_heading)
	vlittlebox.move_child(sub_heading, vlittlebox.get_child_count() - 2)
	
	vlittlebox.add_child(text_edit)
	vlittlebox.move_child(text_edit, vlittlebox.get_child_count() - 2)
	
	sub_heading.owner = main_vbox
	text_edit.owner = main_vbox
	
func _substract_sub_heading(plus_button):
	var vlittlebox = plus_button.get_parent()
	var children_count = vlittlebox.get_children().size()
	if children_count <= 4 :
		vlittlebox.get_parent().get_parent().get_parent().get_parent().queue_free() #VBigBox
	else :
		for i in range(2):
			var children = vlittlebox.get_children()
			var node_to_remove = children[children.size() - 2]
			vlittlebox.remove_child(node_to_remove)
			node_to_remove.queue_free()
			print(get_tree().get_nodes_in_group("text_edit_nodes"))
	
func _add_side_heading(plus_button):
	var hlittlebox = plus_button.get_parent()
	
	var v_separator = VSeparator.new()
	v_separator.add_theme_constant_override("separation", 12)
	#v_separator.connect("gui_input", global_variables._on_separator_input.bind(v_separator))
	
	var new_plus_button = Button.new()
	new_plus_button.theme = icon_theme
	new_plus_button.icon = plus_icon
	new_plus_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	new_plus_button.expand_icon = true
	new_plus_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	new_plus_button.connect("mouse_entered", _expand_plus_button.bind(new_plus_button))
	new_plus_button.connect("mouse_exited", _shrink_plus_button.bind(new_plus_button))
	new_plus_button.connect("gui_input", _on_plus_button_pressed.bind(new_plus_button))
	new_plus_button.add_to_group("inside_plus_buttons_v")
	
	var new_vlittlebox = VBoxContainer.new()
	new_vlittlebox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	new_vlittlebox.add_theme_constant_override("separation", 5)
	
	var heading = LineEdit.new()
	heading.placeholder_text = "Titre"
	heading.alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.expand_to_text_length = true
	heading.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	heading.add_theme_font_size_override("font_size", 16)
	heading.connect("text_changed", _emit_update_signal)
	heading.add_to_group("headings")
	
	var sub_heading = LineEdit.new()
	sub_heading.placeholder_text = "Sous-titre"
	sub_heading.expand_to_text_length = true
	sub_heading.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	sub_heading.connect("text_changed", _emit_update_signal)
	sub_heading.add_to_group("sub_headings")
	
	var text_edit = TextEdit.new()
	text_edit.placeholder_text = "Texte de substitution"
	text_edit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	text_edit.custom_minimum_size.y = text_edit_minimum_size
	text_edit.size_flags_vertical = Control.SIZE_EXPAND_FILL
	text_edit.connect("text_changed", _emit_update_signal.bind(text_edit.text))
	text_edit.add_to_group("text_edit_nodes")
	
	new_vlittlebox.add_child(heading)
	new_vlittlebox.add_child(sub_heading)
	new_vlittlebox.add_child(text_edit)
	new_vlittlebox.add_child(new_plus_button)
	
	hlittlebox.add_child(v_separator)
	hlittlebox.move_child(v_separator, hlittlebox.get_child_count() - 2)
	
	hlittlebox.add_child(new_vlittlebox)
	hlittlebox.move_child(new_vlittlebox, hlittlebox.get_child_count() - 2)
	
	new_vlittlebox.owner = main_vbox
	heading.owner = main_vbox
	sub_heading.owner = main_vbox
	text_edit.owner = main_vbox
	new_plus_button.owner = main_vbox
	v_separator.owner = main_vbox
	
func _substract_side_heading(plus_button):
	print(get_tree().get_nodes_in_group("text_edit_nodes"))
	var hlittlebox = plus_button.get_parent()
	var children_count = hlittlebox.get_children().size()
	if children_count <= 2 :
		hlittlebox.get_parent().get_parent().get_parent().queue_free() #VBigBox
	else :
		#It need to be two to queue_free() the separator too
		for i in range(2):
			var children = hlittlebox.get_children()
			var node_to_remove = children[children.size() - 2]
			#node_to_remove.queue_free()
			hlittlebox.remove_child(node_to_remove)
			node_to_remove.queue_free()
		print(get_tree().get_nodes_in_group("text_edit_nodes"))

func _add_interpolated_container(_plus_button):
	var new_interpolated_container = InterpolatedFlowContainer.new()
	new_interpolated_container.allow_drag_transfer = true
	new_interpolated_container.allow_drag_insert = true
	new_interpolated_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	new_interpolated_container.connect("drag_transfered_out", _on_interpolated_flow_container_drag_transfered_out.bind(new_interpolated_container))
	new_interpolated_container.add_to_group("interpolated_containers")
	
	var new_hbigbox = HBoxContainer.new()
	new_hbigbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var new_ext_h_plus_button = Button.new()
	new_ext_h_plus_button.theme = icon_theme
	new_ext_h_plus_button.icon = plus_icon
	new_ext_h_plus_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	new_ext_h_plus_button.expand_icon = true
	new_ext_h_plus_button.connect("mouse_entered", _expand_plus_button.bind(new_ext_h_plus_button))
	new_ext_h_plus_button.connect("mouse_exited", _shrink_plus_button.bind(new_ext_h_plus_button))
	new_ext_h_plus_button.connect("gui_input", _on_plus_button_pressed.bind(new_ext_h_plus_button))
	new_ext_h_plus_button.add_to_group("exterior_plus_buttons_h")
	
	var new_panel_container = PanelContainer.new()
	new_panel_container.mouse_filter = Control.MOUSE_FILTER_PASS
	new_panel_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var new_hlittlebox = HBoxContainer.new()
	
	var new_h_plus_button = Button.new()
	new_h_plus_button.theme = icon_theme
	new_h_plus_button.icon = plus_icon
	new_h_plus_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	new_h_plus_button.expand_icon = true
	new_h_plus_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
	new_h_plus_button.connect("mouse_entered", _expand_plus_button.bind(new_h_plus_button))
	new_h_plus_button.connect("mouse_exited", _shrink_plus_button.bind(new_h_plus_button))
	new_h_plus_button.connect("gui_input", _on_plus_button_pressed.bind(new_h_plus_button))
	new_h_plus_button.add_to_group("inside_plus_buttons_h")
	
	var new_vlittlebox = VBoxContainer.new()
	new_vlittlebox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	new_vlittlebox.add_theme_constant_override("separation", 5)
	
	var new_v_plus_button = Button.new()
	new_v_plus_button.theme = icon_theme
	new_v_plus_button.icon = plus_icon
	new_v_plus_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	new_v_plus_button.expand_icon = true
	new_v_plus_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	new_v_plus_button.connect("mouse_entered", _expand_plus_button.bind(new_v_plus_button))
	new_v_plus_button.connect("mouse_exited", _shrink_plus_button.bind(new_v_plus_button))
	new_v_plus_button.connect("gui_input", _on_plus_button_pressed.bind(new_v_plus_button))
	new_v_plus_button.add_to_group("inside_plus_buttons_v")
	
	var heading = LineEdit.new()
	heading.placeholder_text = "Titre"
	heading.alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.expand_to_text_length = true
	heading.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	heading.add_theme_font_size_override("font_size", 16)
	heading.connect("text_changed", _emit_update_signal)
	heading.add_to_group("headings")
	
	var sub_heading = LineEdit.new()
	sub_heading.placeholder_text = "Sous-titre"
	sub_heading.expand_to_text_length = true
	sub_heading.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	sub_heading.connect("text_changed", _emit_update_signal)
	sub_heading.add_to_group("sub_headings")
	
	var text_edit = TextEdit.new()
	text_edit.placeholder_text = "Texte de substitution"
	text_edit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	text_edit.custom_minimum_size.y = text_edit_minimum_size
	text_edit.size_flags_vertical = Control.SIZE_EXPAND_FILL
	text_edit.connect("text_changed", _emit_update_signal.bind(text_edit.text))
	text_edit.add_to_group("text_edit_nodes")
	
	new_vlittlebox.add_child(heading)
	new_vlittlebox.add_child(sub_heading)
	new_vlittlebox.add_child(text_edit)
	new_vlittlebox.add_child(new_v_plus_button)
	
	new_hlittlebox.add_child(new_vlittlebox)
	new_hlittlebox.add_child(new_h_plus_button)
	
	new_panel_container.add_child(new_hlittlebox)
	
	new_hbigbox.add_child(new_panel_container)
	new_hbigbox.add_child(new_ext_h_plus_button)
	
	new_interpolated_container.add_child(new_hbigbox)
	
	var separator = HSeparator.new()
	main_vbox.add_child(separator)
	main_vbox.move_child(separator, main_vbox.get_child_count() - 2)
	main_vbox.add_child(new_interpolated_container)
	main_vbox.move_child(new_interpolated_container, main_vbox.get_child_count() - 2)
	
	new_interpolated_container.owner = main_vbox
	new_hbigbox.owner = main_vbox
	new_ext_h_plus_button.owner = main_vbox
	new_panel_container.owner = main_vbox
	new_hlittlebox.owner = main_vbox
	new_h_plus_button.owner = main_vbox
	new_vlittlebox.owner = main_vbox
	new_v_plus_button.owner = main_vbox
	heading.owner = main_vbox
	sub_heading.owner = main_vbox
	text_edit.owner = main_vbox
	separator.owner = main_vbox
	
	#Without this update, the interpolated_container stay shrunk till a button is entered
	for i in range(2):
		await get_tree().process_frame
	new_interpolated_container.queue_sort()
	
func _substract_interpolated_container(plus_button):
	var vbigbox = plus_button.get_parent()
	for i in range(2):
		var siblings = vbigbox.get_children()
		var node_to_remove = siblings[siblings.size() - 2]
		#node_to_remove.queue_free()
		vbigbox.remove_child(node_to_remove)
		node_to_remove.queue_free()

func _add_panel_container(plus_button):
	var interplated_container = plus_button.get_parent().get_parent()
	
	var new_hbigbox = HBoxContainer.new()
	new_hbigbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var new_ext_h_plus_button = Button.new()
	new_ext_h_plus_button.theme = icon_theme
	new_ext_h_plus_button.icon = plus_icon
	new_ext_h_plus_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	new_ext_h_plus_button.expand_icon = true
	new_ext_h_plus_button.connect("mouse_entered", _expand_plus_button.bind(new_ext_h_plus_button))
	new_ext_h_plus_button.connect("mouse_exited", _shrink_plus_button.bind(new_ext_h_plus_button))
	new_ext_h_plus_button.connect("gui_input", _on_plus_button_pressed.bind(new_ext_h_plus_button))
	new_ext_h_plus_button.add_to_group("exterior_plus_buttons_h")
	
	var new_panel_container = PanelContainer.new()
	new_panel_container.mouse_filter = Control.MOUSE_FILTER_PASS
	new_panel_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var new_hlittlebox = HBoxContainer.new()
	
	var new_h_plus_button = Button.new()
	new_h_plus_button.theme = icon_theme
	new_h_plus_button.icon = plus_icon
	new_h_plus_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	new_h_plus_button.expand_icon = true
	new_h_plus_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
	new_h_plus_button.connect("mouse_entered", _expand_plus_button.bind(new_h_plus_button))
	new_h_plus_button.connect("mouse_exited", _shrink_plus_button.bind(new_h_plus_button))
	new_h_plus_button.connect("gui_input", _on_plus_button_pressed.bind(new_h_plus_button))
	new_h_plus_button.add_to_group("inside_plus_buttons_h")
	
	var new_vlittlebox = VBoxContainer.new()
	new_vlittlebox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	new_vlittlebox.add_theme_constant_override("separation", 5)
	
	var new_v_plus_button = Button.new()
	new_v_plus_button.theme = icon_theme
	new_v_plus_button.icon = plus_icon
	new_v_plus_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	new_v_plus_button.expand_icon = true
	new_v_plus_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	new_v_plus_button.connect("mouse_entered", _expand_plus_button.bind(new_v_plus_button))
	new_v_plus_button.connect("mouse_exited", _shrink_plus_button.bind(new_v_plus_button))
	new_v_plus_button.connect("gui_input", _on_plus_button_pressed.bind(new_v_plus_button))
	new_v_plus_button.add_to_group("inside_plus_buttons_v")
	
	var heading = LineEdit.new()
	heading.placeholder_text = "Titre"
	heading.alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.expand_to_text_length = true
	heading.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	heading.add_theme_font_size_override("font_size", 16)
	heading.connect("text_changed", _emit_update_signal)
	heading.add_to_group("headings")
	
	var sub_heading = LineEdit.new()
	sub_heading.placeholder_text = "Sous-titre"
	sub_heading.expand_to_text_length = true
	sub_heading.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	sub_heading.connect("text_changed", _emit_update_signal)
	sub_heading.add_to_group("sub_headings")
	
	var text_edit = TextEdit.new()
	text_edit.placeholder_text = "Texte de substitution"
	text_edit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	text_edit.custom_minimum_size.y = text_edit_minimum_size
	text_edit.size_flags_vertical = Control.SIZE_EXPAND_FILL
	text_edit.connect("text_changed", _emit_update_signal.bind(text_edit.text))
	text_edit.add_to_group("text_edit_nodes")
	
	new_vlittlebox.add_child(heading)
	new_vlittlebox.add_child(sub_heading)
	new_vlittlebox.add_child(text_edit)
	new_vlittlebox.add_child(new_v_plus_button)
	
	new_hlittlebox.add_child(new_vlittlebox)
	new_hlittlebox.add_child(new_h_plus_button)
	
	new_panel_container.add_child(new_hlittlebox)
	
	new_hbigbox.add_child(new_panel_container)
	new_hbigbox.add_child(new_ext_h_plus_button)
	

	
	var separator = VSeparator.new()
	
	separator.mouse_filter = Control.MOUSE_FILTER_STOP
	
	separator.connect("gui_input", _on_separator_input.bind(separator))
	interplated_container.add_child(separator)
	interplated_container.add_child(new_hbigbox)
	
	new_hbigbox.owner = main_vbox
	new_ext_h_plus_button.owner = main_vbox
	new_panel_container.owner = main_vbox
	new_hlittlebox.owner = main_vbox
	new_h_plus_button.owner = main_vbox
	new_vlittlebox.owner = main_vbox
	new_v_plus_button.owner = main_vbox
	heading.owner = main_vbox
	sub_heading.owner = main_vbox
	text_edit.owner = main_vbox
	separator.owner = main_vbox
	
func _substract_panel_container(plus_button):
	var interpolated_container = plus_button.get_parent().get_parent()
	var children_count = interpolated_container.get_children().size()
	if children_count <= 1 :
		interpolated_container.queue_free()
	else :
		
		var node_to_remove = plus_button.get_parent()
		var separator_index = node_to_remove.get_index() - 1
		var separator_node = interpolated_container.get_child(separator_index)
		interpolated_container.remove_child(node_to_remove)
		interpolated_container.remove_child(separator_node)
		node_to_remove.queue_free()
		separator_node.queue_free()

func _on_interpolated_flow_container_drag_transfered_out(_node: Control, _into: InterpolatedContainer, from: InterpolatedContainer) -> void:
	var child_count = from.get_child_count()
	if child_count == 0 :
		from.queue_free()



var is_resizing = false
var separator_id = 0
var _resize_start_global_mouse_pos = Vector2.ZERO
var number_of_child = 0
var left_node = null
var right_node = null
var left_original_size = 0
func _on_separator_input(event, separator):
	var parent_node = separator.get_parent()  # Get the parent of the resize_handle
	
	
	var current_global_mouse_pos = get_viewport().get_mouse_position()
	var delta = current_global_mouse_pos - _resize_start_global_mouse_pos
	
	if event is InputEventMouseMotion:
		if separator is VSeparator:
			separator.mouse_default_cursor_shape = Control.CURSOR_HSIZE
		if separator is HSeparator:
			separator.mouse_default_cursor_shape = Control.CURSOR_VSIZE
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			 # Start or stop resizing
			_resize_start_global_mouse_pos = get_viewport().get_mouse_position()

			if parent_node:
				# Loop through all children of the parent node
				var children = parent_node.get_children()
				for i in range(children.size()):
					var child = children[i]
					if child == separator:
						separator_id = i
						break  # Stop searching once we found the separator
			
			left_node = parent_node.get_child(separator_id - 1)
			left_original_size = left_node.size.x
			right_node = parent_node.get_child(separator_id + 1)
			
			is_resizing = event.pressed
			if parent_node is InterpolatedFlowContainer :
				print("drag_off")
				parent_node.allow_drag_reorder = !parent_node.allow_drag_reorder
				parent_node.allow_drag_transfer = !parent_node.allow_drag_transfer
				parent_node.allow_drag_insert = !parent_node.allow_drag_insert
				
				
	if event is InputEventMouseMotion and is_resizing:
		
		var minimum_left = left_node.get_minimum_size()
		var minimum_right = right_node.get_minimum_size()
		
		var minimum_ratio = 0
		var new_x_size = left_original_size + delta.x
		#print(new_x_size)
		
		#print(new_ratio)
		
		number_of_child = parent_node.get_children().size()
		var float_number_of_panel = ceil(float(number_of_child) / 2)
		#var float_number_of_separator = number_of_child - float_number_of_panel
		#print(int_number_of_panel)
		var new_size_ratio = new_x_size / (parent_node.size.x) # - (float_number_of_separator * 22))
		#print(new_size_ratio)
		# 1/float_number_of_panel = 0.33
		#print(new_ratio)
		#var total_ratio = ((1.0 / float_number_of_panel) * 2) #- (float_number_of_separator * 0.1)
		#print(left_node.size_flags_stretch_ratio)
		#print(right_node.size_flags_stretch_ratio)
		var total_ratio = left_node.size_flags_stretch_ratio + right_node.size_flags_stretch_ratio
		
		var new_ratio = new_size_ratio * float_number_of_panel
		
		#for child in parent_node.get_children() :
			#print(child.size_flags_stretch_ratio)
		#print(total_ratio)
		#print(delta.x)
		#print(new_ratio)
		#if left_node is Control :
		#	minimum_left.x += 200
		#print(separator.size.x)
		if separator is VSeparator :
			if delta.x > 0 and right_node.size.x > minimum_right.x :
				left_node.size_flags_stretch_ratio = new_ratio
				right_node.size_flags_stretch_ratio = total_ratio - new_ratio
				
			elif delta.x < 0 and new_x_size >= minimum_left.x :
				left_node.size_flags_stretch_ratio = new_ratio
				right_node.size_flags_stretch_ratio = total_ratio - new_ratio

func _switch_mode(toggled_on):
	if toggled_on :
		for plus_button in get_tree().get_nodes_in_group("inside_plus_buttons_v"):
			plus_button.connect("mouse_entered", _expand_plus_button.bind(plus_button))
			plus_button.connect("mouse_exited", _shrink_plus_button.bind(plus_button))
		
		for plus_button in get_tree().get_nodes_in_group("inside_plus_buttons_h"):
			plus_button.connect("mouse_entered", _expand_plus_button.bind(plus_button))
			plus_button.connect("mouse_exited", _shrink_plus_button.bind(plus_button))
		
		for plus_button in get_tree().get_nodes_in_group("exterior_plus_buttons_v"):
			plus_button.connect("mouse_entered", _expand_plus_button.bind(plus_button))
			plus_button.connect("mouse_exited", _shrink_plus_button.bind(plus_button))
		
		for plus_button in get_tree().get_nodes_in_group("exterior_plus_buttons_h"):
			plus_button.connect("mouse_entered", _expand_plus_button.bind(plus_button))
			plus_button.connect("mouse_exited", _shrink_plus_button.bind(plus_button))
		
		for plus_button in get_tree().get_nodes_in_group("inside_minus_buttons_v"):
			plus_button.connect("mouse_entered", _expand_plus_button.bind(plus_button))
			plus_button.connect("mouse_exited", _shrink_plus_button.bind(plus_button))
		
		for plus_button in get_tree().get_nodes_in_group("inside_minus_buttons_h"):
			plus_button.connect("mouse_entered", _expand_plus_button.bind(plus_button))
			plus_button.connect("mouse_exited", _shrink_plus_button.bind(plus_button))
		
		for plus_button in get_tree().get_nodes_in_group("exterior_minus_buttons_v"):
			plus_button.connect("mouse_entered", _expand_plus_button.bind(plus_button))
			plus_button.connect("mouse_exited", _shrink_plus_button.bind(plus_button))
		
		for plus_button in get_tree().get_nodes_in_group("exterior_minus_buttons_h"):
			plus_button.connect("mouse_entered", _expand_plus_button.bind(plus_button))
			plus_button.connect("mouse_exited", _shrink_plus_button.bind(plus_button))
			
		for text_edit in get_tree().get_nodes_in_group("text_edit_nodes"):
			var placeholder_text = text_edit.placeholder_text
			text_edit.placeholder_text = "Texte de substitution"
			text_edit.text = placeholder_text
			
		for sub_heading in get_tree().get_nodes_in_group("sub_headings"):
			sub_heading.editable = true
			sub_heading.flat = false
			
		for heading in get_tree().get_nodes_in_group("headings"):
			heading.editable = true
			heading.flat = false
	
	if not toggled_on :
		
		for plus_button in get_tree().get_nodes_in_group("inside_plus_buttons_v"):
			plus_button.disconnect("mouse_entered", _expand_plus_button.bind(plus_button))
			plus_button.disconnect("mouse_exited", _shrink_plus_button.bind(plus_button))
		
		for plus_button in get_tree().get_nodes_in_group("inside_plus_buttons_h"):
			plus_button.disconnect("mouse_entered", _expand_plus_button.bind(plus_button))
			plus_button.disconnect("mouse_exited", _shrink_plus_button.bind(plus_button))
		
		for plus_button in get_tree().get_nodes_in_group("exterior_plus_buttons_v"):
			plus_button.disconnect("mouse_entered", _expand_plus_button.bind(plus_button))
			plus_button.disconnect("mouse_exited", _shrink_plus_button.bind(plus_button))
		
		for plus_button in get_tree().get_nodes_in_group("exterior_plus_buttons_h"):
			plus_button.disconnect("mouse_entered", _expand_plus_button.bind(plus_button))
			plus_button.disconnect("mouse_exited", _shrink_plus_button.bind(plus_button))
		
		for plus_button in get_tree().get_nodes_in_group("inside_minus_buttons_v"):
			plus_button.disconnect("mouse_entered", _expand_plus_button.bind(plus_button))
			plus_button.connect("mouse_exited", _shrink_plus_button.bind(plus_button))
		
		for plus_button in get_tree().get_nodes_in_group("inside_minus_buttons_h"):
			plus_button.disconnect("mouse_entered", _expand_plus_button.bind(plus_button))
			plus_button.disconnect("mouse_exited", _shrink_plus_button.bind(plus_button))
		
		for plus_button in get_tree().get_nodes_in_group("exterior_minus_buttons_v"):
			plus_button.disconnect("mouse_entered", _expand_plus_button.bind(plus_button))
			plus_button.disconnect("mouse_exited", _shrink_plus_button.bind(plus_button))
		
		for plus_button in get_tree().get_nodes_in_group("exterior_minus_buttons_h"):
			plus_button.disconnect("mouse_entered", _expand_plus_button.bind(plus_button))
			plus_button.disconnect("mouse_exited", _shrink_plus_button.bind(plus_button))
		
		for text_edit in get_tree().get_nodes_in_group("text_edit_nodes"):
			var placeholder_text = text_edit.text
			text_edit.placeholder_text = placeholder_text
			text_edit.text = ""
			#print("switch")
			
		for sub_heading in get_tree().get_nodes_in_group("sub_headings"):
			sub_heading.editable = false
			sub_heading.flat = true
			
		for heading in get_tree().get_nodes_in_group("headings"):
			heading.editable = false
			heading.flat = true
		#	sub_heading.connect("text_changed", _emit_update_signal)
		
		#for heading in get_tree().get_nodes_in_group("headings"):
		#	heading.connect("text_changed", _emit_update_signal)

func _emit_update_signal(_text):
	custom_text_changed.emit()
