extends Label

@export var display_duration: float = 2.0 # How long the message stays fully visible
@export var fade_duration: float = 1.5   # How long the fading takes

var current_tween: Tween = null # To keep track of the active tween
var follow = false

func _ready():
	# Ensure the label is hidden initially by setting its alpha to 0
	# (You might have already set this in the Inspector, but this confirms it)
	modulate.a = 0.0
	# Also hide the node itself when not displaying a message
	hide()

# Call this function from another script to show a message
func show_and_fade(message: String, coordinate):
	set_position(coordinate)
	if current_tween != null and current_tween.is_valid():
		current_tween.kill()

	# Set the new message text
	text = message

	# Make the label visible and fully opaque instantly
	show()
	modulate.a = 1.0

	# Create a new tween
	current_tween = create_tween()

	# 1. Wait for the display duration
	current_tween.tween_interval(display_duration)

	# 2. Animate the alpha value from 1 (opaque) to 0 (transparent) over the fade_duration
	# The property path is "modulate:alpha" to specifically target the alpha channel of the modulate color
	current_tween.tween_property(self, "modulate", Color(1,1,1,0), fade_duration)

	# 3. Once the fade is complete, hide the label node
	# This callback runs after the property tween finishes
	current_tween.tween_callback(Callable(self, "hide"))

	# Optional: Clear the text after hiding if you prefer
	# current_tween.tween_callback(Callable(self, "_clear_text"))


func show_to_user(message):
	show()
	modulate.a = 1.0
	text = message
	follow = true

func stop_showing_to_user():
	hide()
	follow = false

func _input(event: InputEvent):
	if event is InputEventMouseMotion and follow:
		global_position = event.position
