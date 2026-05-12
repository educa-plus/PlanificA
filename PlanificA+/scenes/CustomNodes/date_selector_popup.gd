extends PopupPanel

@export var date_font_size = 10
@export var choosen_date = {}

@onready var month_grid_container = %MonthGridContainer
@onready var month_label = %MonthLabel

var current_month
var current_year

func _on_about_to_popup() -> void:
	var today_date = Time.get_date_dict_from_system()
	current_month = today_date.month
	current_year = today_date.year
	populate_month_calendar()

func populate_month_calendar():
	
	month_label.text = global_variables.months_abbr[current_month - 1] + " " + str(current_year)
	
	for child in month_grid_container.get_children():
		month_grid_container.remove_child(child)
		child.queue_free()
		
	var month_calendar = time_functions.get_calendar_month(current_year, current_month, true, true)
	
	for weekday in global_variables.days_of_week_abbr:
		var weekday_label = Label.new()

		weekday_label.add_theme_font_size_override("font_size", date_font_size)
		weekday_label.text = weekday
		weekday_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		weekday_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		month_grid_container.add_child(weekday_label)
	
	for week in month_calendar:
		for day in week:
			
			var date_button = Button.new()
			date_button.text = str(day.day)
			
			date_button.connect("pressed", _on_date_choosen.bind(day))
			
			date_button.theme = load("res://_theme/button-calendar-gray.tres")
			date_button.add_theme_font_size_override("font_size", date_font_size)
				
			if global_variables.list_of_free_day.has(day):
				date_button.theme = load("res://_theme/button-calendar-green.tres")
				
			if global_variables.list_of_teacher_workday.has(day):
				date_button.theme = load("res://_theme/button-calendar-yellow.tres")
				
			var first_day = global_variables.first_day.duplicate()
			first_day.erase("jour")
			if day == first_day :
				date_button.theme = load("res://_theme/button-calendar-first.tres")
			
				
			var last_day = global_variables.last_day.duplicate()
			last_day.erase("jour")
			if day == last_day :
				date_button.theme = load("res://_theme/button-calendar-last.tres")

			month_grid_container.add_child(date_button)

func _on_date_choosen(date):
	choosen_date = date
	self.hide()

func _on_previous_month_pressed() -> void:
	current_month -= 1
	if current_month == 0:
		current_year -= 1
		current_month = 12
	populate_month_calendar()
	
func _on_next_month_pressed() -> void:
	current_month += 1
	if current_month > 12:
		current_year += 1
		current_month = 1
	populate_month_calendar()
