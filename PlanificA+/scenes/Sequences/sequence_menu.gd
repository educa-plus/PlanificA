extends Control

signal selection_finished(list_of_selection)

var sequence_box_path = "res://scenes/Sequences/SequenceBox.tscn"

@export var show_bg = false
@export var is_sequence_selection = false

@onready var sequence_list_vbox = %SequenceList
@onready var bg = $BG

@onready var sequence_box_scene = load(sequence_box_path)

func _ready() -> void:
	if show_bg :
		bg.show()
	else :
		bg.hide()
		
	_populate_sequence_list()

func _populate_sequence_list():
	var sequence_dict = SequenceFunctions._get_sequence_dict()
	for sequence in sequence_dict :
		var sequence_array = sequence_dict[sequence]
		var new_sequence_box = sequence_box_scene.instantiate()
		
		new_sequence_box.add_to_group("sequence_boxes")
		
		new_sequence_box.sequence_name = sequence.substr(9)
		new_sequence_box.sequence_dir_path = "user://sequences/" + sequence + "/"
		new_sequence_box.sequence_array = sequence_array
		new_sequence_box.is_sequence_selection = is_sequence_selection
		print(new_sequence_box)
		sequence_list_vbox.add_child(new_sequence_box)
		#sequence_list_vbox.move_child(new_sequence_box, sequence_list_vbox.get_children().size() - 2)

func _on_exit_button_pressed() -> void:
	self.queue_free()

func _on_continue_button_pressed() -> void:
	if is_sequence_selection == true :
		var sequence_list = get_tree().get_nodes_in_group("sequence_boxes")
		emit_signal("selection_finished", sequence_list)
		self.queue_free()
