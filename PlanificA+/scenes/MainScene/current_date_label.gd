extends Label

@onready var current_date_label = $"."

func _ready():
	# Update the time immediately on start
	update_date(global_variables.current_date)
	#global_variables.connect("date_changed", Callable(self, "update_date"))

func update_date(current_date):
	var month = global_variables.months[current_date.month - 1]
	var formatted_date = str(current_date.day) + " " + str(month) + " " + str(current_date.year)
	current_date_label.text = formatted_date
