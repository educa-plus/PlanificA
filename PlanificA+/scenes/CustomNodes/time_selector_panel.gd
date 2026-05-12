extends PopupPanel

signal time_selected(time_str)

@onready var up_hour = %UpHour
@onready var up_minute = %UpMinute
@onready var down_hour = %DownHour
@onready var down_minute = %DownMinute

@onready var hour_label = %HourEdit
@onready var minute_label = %MinuteEdit

@onready var back = %Back
@onready var next = %Next

@onready var up_hour_repeat_timer = %UpHourRepeatTimer
@onready var up_minute_repeat_timer = %UpMinuteRepeatTimer
@onready var down_hour_repeat_timer = %DownHourRepeatTimer
@onready var down_minute_repeat_timer = %DownMinuteRepeatTimer

const INITIAL_REPEAT_DELAY = 0.4 # Seconds before repeating starts
const REPEAT_INTERVAL = 0.05     # Seconds between subsequent repeats

func _ready():
	next.connect("pressed", _on_next_pressed)
	back.connect("pressed", _on_back_pressed)
	
	hour_label.connect("text_changed", _on_time_text_changed.bind(hour_label, 0, 24))
	minute_label.connect("text_changed", _on_time_text_changed.bind(minute_label, 0, 60))
	
	up_hour.connect("button_down", Callable(self, "_start_repeat_timer").bind(up_hour_repeat_timer, "_on_up_hour_pressed"))
	up_hour.connect("button_up", Callable(self, "_stop_repeat_timer").bind(up_hour_repeat_timer))

	up_minute.connect("button_down", Callable(self, "_start_repeat_timer").bind(up_minute_repeat_timer, "_on_up_minute_pressed"))
	up_minute.connect("button_up", Callable(self, "_stop_repeat_timer").bind(up_minute_repeat_timer))

	down_hour.connect("button_down", Callable(self, "_start_repeat_timer").bind(down_hour_repeat_timer, "_on_down_hour_pressed"))
	down_hour.connect("button_up", Callable(self, "_stop_repeat_timer").bind(down_hour_repeat_timer))

	down_minute.connect("button_down", Callable(self, "_start_repeat_timer").bind(down_minute_repeat_timer, "_on_down_minute_pressed"))
	down_minute.connect("button_up", Callable(self, "_stop_repeat_timer").bind(down_minute_repeat_timer))

	# --- Configure Timers (in editor or code) ---
	# Ensure the timers are one-shot and not autostarting by default in the editor
	# Or set it in code here for consistency:
	up_hour_repeat_timer.one_shot = true
	up_hour_repeat_timer.wait_time = INITIAL_REPEAT_DELAY
	up_hour_repeat_timer.connect("timeout", Callable(self, "_on_repeat_timeout").bind(up_hour_repeat_timer, "_on_up_hour_pressed"))

	up_minute_repeat_timer.one_shot = true
	up_minute_repeat_timer.wait_time = INITIAL_REPEAT_DELAY
	up_minute_repeat_timer.connect("timeout", Callable(self, "_on_repeat_timeout").bind(up_minute_repeat_timer, "_on_up_minute_pressed"))

	down_hour_repeat_timer.one_shot = true
	down_hour_repeat_timer.wait_time = INITIAL_REPEAT_DELAY
	down_hour_repeat_timer.connect("timeout", Callable(self, "_on_repeat_timeout").bind(down_hour_repeat_timer, "_on_down_hour_pressed"))

	down_minute_repeat_timer.one_shot = true
	down_minute_repeat_timer.wait_time = INITIAL_REPEAT_DELAY
	down_minute_repeat_timer.connect("timeout", Callable(self, "_on_repeat_timeout").bind(down_minute_repeat_timer, "_on_down_minute_pressed"))


# --- Generic Functions for Hold-to-Repeat Logic ---
func _start_repeat_timer(timer: Timer, action_func_name: String):
	# Call the action once immediately on button_down (for the initial press)
	call(action_func_name)
	timer.start() # Start the initial delay timer

func _stop_repeat_timer(timer: Timer):
	timer.stop()
	# Reset timer to initial delay for next press
	timer.one_shot = true
	timer.wait_time = INITIAL_REPEAT_DELAY

func _on_repeat_timeout(timer: Timer, action_func_name: String):
	# This function is called when the timer times out.
	# Call the action again.
	call(action_func_name)
	
	# If the button is still down, set timer for rapid repeat
	# and restart it.
	timer.one_shot = false # Make it repeat continuously after initial delay
	timer.wait_time = REPEAT_INTERVAL
	timer.start()

func _on_up_hour_pressed():
	var hour = int(hour_label.text)
	hour += 1
	if hour > 23:
		hour = 0
	hour_label.text = "%02d" % hour
	
func _on_up_minute_pressed():
	var minute = int(minute_label.text)
	minute += 1
	if minute > 59: # Wrap around from 59 to 0
		minute = 0
	minute_label.text = "%02d" % minute

func _on_down_hour_pressed():
	var hour = int(hour_label.text)
	hour -= 1
	if hour < 0:
		hour = 23
	hour_label.text = "%02d" % hour
	
func _on_down_minute_pressed():
	var minute = int(minute_label.text)
	minute -= 1
	if minute < 0: # Wrap around from 0 to 59
		minute = 59
	minute_label.text = "%02d" % minute
	
func _on_next_pressed():
	var hour = int(hour_label.text)
	var minute = int(minute_label.text)
	var time_str = "%02d:%02d" % [hour, minute]
	emit_signal("time_selected", time_str)
	#time_button.text = "%02d:%02d" % [hour, minute]
	self.queue_free()

func _on_time_text_changed(label, min, max):
	var text = label.text
	var new_text = text
	if text.length() > 0 :
		var last_letter = text[-1]
		var valid = false
		if text.length() <= 2 :
			if new_text.is_valid_int() and int(new_text) >= min and int(new_text) < max :
				valid = true
		if not valid :
			for i in text.length() :
				var caracter = text[i]
				if not caracter.is_valid_int() :
					label.text = ""
					return
			new_text = text.left(-1)
			label.text = new_text
		
func _on_back_pressed():
	self.queue_free()
