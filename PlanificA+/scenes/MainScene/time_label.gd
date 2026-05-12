extends Node

@onready var time_label = $TimeLabel
# @onready var date_label = $DateLabel

func _ready():
	# Update the time immediately on start
	update_time()

	# Create a Timer node to update the time every second
	var timer = Timer.new()
	timer.wait_time = 1.0  # Update every second
	timer.autostart = true
	timer.timeout.connect(update_time)
	add_child(timer)

func update_time():
	var time_data = Time.get_datetime_dict_from_system()
	var formatted_time = "%02d:%02d" % [time_data.hour, time_data.minute]
	time_label.text = formatted_time
	# var formatted_date = "%02d-%02d-%02d" % [time_data.year, time_data.month, time_data.day]
	# date_label.text = formatted_date
	
