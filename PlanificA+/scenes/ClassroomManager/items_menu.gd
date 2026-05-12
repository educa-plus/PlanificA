extends VBoxContainer

@export var item_selected = ""



func _on_simple_desk_toggled(toggled_on: bool) -> void:
	if toggled_on :
		item_selected = "simple_desk"
	if not toggled_on and item_selected != "":
		item_selected = ""

func _on_double_desk_toggled(toggled_on: bool) -> void:
	if toggled_on :
		item_selected = "double_desk"
	if not toggled_on and item_selected != "":
		item_selected = ""
