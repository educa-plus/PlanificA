extends HBoxContainer

signal modified
signal completed
signal was_completed

@export var current_value = 0

@onready var progress_slider = %ProgressSlider
@onready var percent_label = %Percent



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	percent_label.text = str(int(progress_slider.value)) + "%"

func _on_progress_slider_value_changed(value: float) -> void:
	percent_label.text = str(int(value)) + "%"

func _on_progress_slider_drag_ended(_value_changed: bool) -> void:
	if _value_changed :
		emit_signal("modified")
	
	if current_value == progress_slider.max_value and progress_slider.value != progress_slider.max_value :
		emit_signal("was_completed")
	else :
		if progress_slider.value >= progress_slider.max_value and current_value != progress_slider.max_value:
			emit_signal("completed")
		
	
