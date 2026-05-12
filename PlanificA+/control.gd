extends Control

var pulse_animation
var timer = Timer.new()

func _ready() -> void:
	var setter_node = $Button
	setter_node.add_child(timer)
	pulse_animation = Anima.Node(setter_node).anima_animation("heartbeat", 0.7)
	timer.connect("timeout", _on_timer_timeout)
	
	# Start the timer for the first time
	timer.start(5)

func _process(delta: float) -> void:
	print(timer.time_left)

func _on_timer_timeout():
	# This function will be called when the timer finishes its countdown
	pulse_animation.play()

#func _on_button_pressed() -> void:
#	pulse_animation.play()
