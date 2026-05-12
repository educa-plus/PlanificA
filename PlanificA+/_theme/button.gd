extends Button

@onready var anim = $"../AnimationPlayer"

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	connect("button_up", _on_button_up)

func _on_mouse_entered():
	anim.play("hover_in")

func _on_mouse_exited():
	anim.play_backwards("hover_in")

func _on_button_up():
	anim.play("hover_in") # Return to hover scale after press

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			anim.play("pressed_in")
