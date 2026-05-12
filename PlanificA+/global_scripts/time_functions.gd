extends Node
var first_weekday: Time.Weekday

func is_leap_year(year: int) -> bool:
	return (year % 4 == 0 and (year % 100 != 0 or year % 400 == 0))
	
func get_days_in_month(date) -> int:
	var year = date.year
	var month = date.month
	var days_in_month: Array[int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	if month == 2 and is_leap_year(year):
		return 29
	return days_in_month[month - 1]

# next_week_wednesday = { "year": 2025, "month": 4, "day": 30, "weekday": 3 }
func get_next_week_date(date):
	date.day += 7
	var days_in_month = get_days_in_month(date)
	if date.day > days_in_month:
		date.day -= days_in_month
		if date.month == 12:
			date.month = 1
			date.year += 1
		else :
			date.month += 1
	global_variables.emit_date_changed_signal()
	return date

func get_previous_week_date(date):
	date.day -= 7
	if date.day < 1 :
		date.month -= 1
		date.day += get_days_in_month(date)
		if date.month < 1:
			date.month = 12
			date.year -= 1
	global_variables.emit_date_changed_signal()
	return date

func _get_week_list(date):
	var week_list = []
	var sunday_day = (date.day - date.weekday)
	var sunday_month = date.month
	var sunday_year = date.year
	var period = date.period
	
	if sunday_day < 1 :
		sunday_month -= 1 # get previous month
		# previous month sunday
		sunday_day = get_days_in_month({ "year": date.year, "month": sunday_month, "day": date.day, "weekday": date.weekday }) + sunday_day # get day in previous month
	
	var sunday = { "year": date.year, "month": sunday_month, "day": sunday_day, "weekday": 0 }
	var next_day = sunday_day + 1
	var next_weekday = sunday.weekday + 1
	
	for i in range(global_variables.DAYS_IN_WEEK):
		if next_day > get_days_in_month(sunday):
			next_day = 1 # we restart the month, so 1 
			sunday_month += 1 # we get the next month
			if sunday_month > 12:
				sunday_year += 1
				sunday_month = 1
			week_list.append({ "year": sunday_year, "month": sunday_month, "day": next_day, "weekday": next_weekday, "period": period })
		else:
			week_list.append({ "year": sunday_year, "month": sunday_month, "day": next_day, "weekday": next_weekday, "period": period })
		next_day += 1
		next_weekday += 1
	return week_list
	
func _get_complete_week_list(date):
	var week_list = []
	var sunday_day = (date.day - date.weekday)
	var sunday_month = date.month
	var sunday_year = date.year
	var period = date.period
	
	if sunday_day < 1 :
		sunday_month -= 1 # get previous month
		# previous month sunday
		sunday_day = get_days_in_month({ "year": date.year, "month": sunday_month, "day": date.day, "weekday": date.weekday }) + sunday_day # get day in previous month
	
	var sunday = { "year": date.year, "month": sunday_month, "day": sunday_day, "weekday": 0 }
	var next_day = sunday_day + 1
	var next_weekday = sunday.weekday + 1
	
	for i in range(7):
		if next_day > get_days_in_month(sunday):
			next_day = 1 # we restart the month, so 1 
			sunday_month += 1 # we get the next month
			if sunday_month > 12:
				sunday_year += 1
				sunday_month = 1
			week_list.append({ "year": sunday_year, "month": sunday_month, "day": next_day, "weekday": next_weekday, "period": period })
		else:
			week_list.append({ "year": sunday_year, "month": sunday_month, "day": next_day, "weekday": next_weekday, "period": period })
		next_day += 1
		next_weekday += 1
	return week_list
	
@warning_ignore("int_as_enum_without_cast")
func get_calendar_month(year: int, month: int, include_adjacent_days: bool = false, force_six_weeks: bool = false) -> Array:
	var date = {"year": year, "month": month}
	var days_in_month: int = get_days_in_month(date)
	var first_day_weekday = get_weekday(year, month, 1)
	
	# Adjust for the first weekday setting
	first_day_weekday = (first_day_weekday - first_weekday + 7) % 7
	
	var calendar: Array = []
	var week: Array = [0, 0, 0, 0, 0, 0, 0]
	var day: int = 1 - first_day_weekday
	
	while day <= days_in_month or (force_six_weeks and calendar.size() < 6):
		for i in range(7):
			if day > 0 and day <= days_in_month:
				week[i] = {"year": year, "month": month, "day": day}
			elif include_adjacent_days:
				var adj_year = year
				var adj_month = month
				var adj_day = day
				if day <= 0:
					adj_month -= 1
					if adj_month < 1:
						adj_month = 12
						adj_year -= 1
					var adj_date = {"year": adj_year, "month": adj_month}
					var prev_month_days: int = get_days_in_month(adj_date)
					adj_day = prev_month_days + day
				elif day > days_in_month:
					adj_day = day - days_in_month
					adj_month += 1
					if adj_month > 12:
						adj_month = 1
						adj_year += 1
				
				week[i] = {"year": adj_year, "month": adj_month, "day": adj_day}
			else:
				week[i] = 0
			
			day += 1
		
		calendar.append(week.duplicate())
		week.fill(0)
	
	return calendar
	
@warning_ignore("integer_division")
func get_weekday(year, month, day) -> Time.Weekday:
		# Zeller's Congruence algorithm to find the day of the week
	if month < 3:
		month += 12
		year -= 1
	var k: int = year % 100
	var j: int = int(year / 100)
	var f = day + (13 * (month + 1) / 5) + k + (k / 4) + (j / 4) - 2 * j
		# Adjusted Zeller's Congruence for Godot's Sunday = 0
	return (f + 6) % 7 as Time.Weekday


func get_first_school_month(year, month):
	while month != 7:
		month -= 1
		if month < 1:
			year -= 1
			month = 12
	return {"year": year, "month": month}
		
func _find_last_period_of_current_time():
	var today = Time.get_time_dict_from_system()
	print(today)
	var current_hour = today.hour
	var current_minute = today.minute
	var period_duration = global_variables.period_duration
	var passed_period = []
	for duration in period_duration :
		var formatted_current_time = "%02d:%02d" % [current_hour, current_minute]
		if duration.end <= formatted_current_time:
			passed_period.append(duration.period)
	
	passed_period.sort()
	var last_period = 0
	if passed_period.size() != 0 :
		last_period = passed_period[-1]
	return last_period
