extends Control

@export var sequence_name = ""
@export var sequence_dir_path = ""
@export var sequence_array = []
@export var is_sequence_selection = false
@export var is_planif_selection = false

@export var is_sequence_selected = false

@onready var reorderable_box = $FoldableContainer/ReorderableVBox
@onready var foldable_box = $FoldableContainer
@onready var sequence_check_box = $Control/CheckBox


func _ready() -> void:
	foldable_box.title = sequence_name + " (" + str(sequence_array.size()) + ")"
	
	if is_sequence_selection == true :
		sequence_check_box.show()
	else :
		sequence_check_box.hide()
	
	_populate_reorderable_box()
	
func _populate_reorderable_box():
	for planif in sequence_array :
		var new_button = Button.new()
		new_button.text = planif.replace(".tres", "")
		new_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		new_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		reorderable_box.add_child(new_button)
	
func _update_sequence_order():
	for planif in reorderable_box.get_children():
		var old_planif_name = planif.text
		var new_planif_name = str(planif.get_index() + 1) + planif.text.substr(1)
		planif.text = new_planif_name
		var sequence_dir_access = DirAccess.open(sequence_dir_path)
		var error = sequence_dir_access.rename(old_planif_name + ".tres", new_planif_name + ".tres")
		if error == OK:
			print("File successfully renamed to: ", new_planif_name)
		else:
			print("Error renaming file. Error code: ", error)
			
func _on_reorderable_v_box_reordered(_from: int, _to: int) -> void:
	_update_sequence_order()

func _on_check_box_toggled(toggled_on: bool) -> void:
	is_sequence_selected = toggled_on
