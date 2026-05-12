extends TextureButton

@onready var line = $Line2D
@onready var turn_button = $TurnButton

var allow_turn
var turn_axis_point = Vector2(0,0)

func _on_turn_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton :
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.pressed:
				allow_turn = true
				var original_rotation = self.rotation
				self.rotation = 0
				turn_axis_point = self.global_position + self.pivot_offset
				self.rotation = original_rotation
			elif not event.pressed:
				allow_turn = false
				
	if event is InputEventMouseMotion and allow_turn :
		var mouse_pos = get_viewport().get_mouse_position()
		var direction_vector = mouse_pos - turn_axis_point
		var new_angle = direction_vector.angle()
		self.rotation = new_angle + PI/2

func _show_turn_button() -> void:
	print("show")
	line.show()
	turn_button.show()
	
func _hide_turn_button() -> void:
	print("hide")
	line.hide()
	turn_button.hide()
	
