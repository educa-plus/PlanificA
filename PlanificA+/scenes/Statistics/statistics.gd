extends Control

@onready var bad_cloud_node = $VBoxContainer/Commentary/Bad/VBoxContainer/BadCloud
@onready var good_cloud_node = $VBoxContainer/Commentary/Good/VBoxContainer/GoodCloud
@onready var amelioration_cloud_node = $VBoxContainer/Commentary/Amelioration/VBoxContainer/AmeliorationCloud

@onready var chart_node = $VBoxContainer/BarChart/HBoxContainer2/YearEvolution/AnnualRetroaction

@onready var objective_progress_bar = %learning_objective
@onready var management_progress_bar = %classroom_management
@onready var motivation_progress_bar = %motivation
@onready var relation_progress_bar = %positive_relations
@onready var preparation_progress_bar = %preparation
@onready var average_progress_bar = %average

@onready var refresh_button = %Refresh

func _ready() -> void:
	refresh_button.connect("pressed", _on_refresh_pressed)
	_on_refresh_pressed()
	
func _on_refresh_pressed():
	var path = global_variables.current_school_year_dir + "/" + "retroaction"
	var dir_access = DirAccess.open(path)

	if dir_access:
		var num_retroaction = 0
		
		var objective_offset = 0
		var management_offset = 0
		var motivation_offset = 0
		var relation_offset = 0
		var preparation_offset = 0
		var average_offset = 0
		
		var good_text = ""
		var bad_text = ""
		var amelioration_text = ""
		
		var year_retroaction_progression = {}
		var previous_month_index = -1
		var monthly_average = []
		# Start listing directory contents
		dir_access.list_dir_begin()
		var file_name = dir_access.get_next()
		
		while file_name != "":
			
			var month = file_name.substr(17, 2)
			if month[0] == "0" :
				month = month.substr(1)
			var month_index = int(month) - 1
			var month_name_abbr = global_variables.months_abbr[month_index]

			print(month_name_abbr)
			# Exclude "." and ".." entries
			if file_name != "." and file_name != "..":
				var file_path = path + "/" + file_name
				if FileAccess.file_exists(file_path):
					var loaded_resource = load(file_path)
					if loaded_resource is SaveRetroactionData:
						num_retroaction += 1
						var percent = float(loaded_resource.average_offset * 100/220 )

						if month_index != previous_month_index and previous_month_index != -1 :
							year_retroaction_progression[global_variables.months_abbr[previous_month_index]] = monthly_average
							monthly_average = []
							monthly_average.append(percent)
						else :
							monthly_average.append(percent)
							
						previous_month_index = month_index
						
						good_text += " "
						good_text += loaded_resource.text_edit_content.Good
						
						bad_text += " "
						bad_text += loaded_resource.text_edit_content.Bad
						
						amelioration_text += " "
						amelioration_text += loaded_resource.text_edit_content.Commentary
						
						objective_offset += loaded_resource.stars_offset_results.classroom_management
						management_offset += loaded_resource.stars_offset_results.learning_objective
						motivation_offset += loaded_resource.stars_offset_results.motivation
						relation_offset += loaded_resource.stars_offset_results.positive_relations
						preparation_offset += loaded_resource.stars_offset_results.preparation
						average_offset += loaded_resource.average_offset
						
			file_name = dir_access.get_next()

		dir_access.list_dir_end() # Important to call this to clean up
		
		year_retroaction_progression[global_variables.months_abbr[previous_month_index]] = monthly_average
		
		var total_average_by_month = []
		for month in year_retroaction_progression.keys() :
			var sum = 0
			var number = 0
			for num in year_retroaction_progression[month]:
				sum += num
				number += 1
			if number != 0 :
				total_average_by_month.append(sum/number)
		
		if total_average_by_month != [] :
			chart_node._update_chart(year_retroaction_progression.keys(), total_average_by_month)
		
		good_cloud_node.text_to_cloud = good_text
		good_cloud_node._update_cloud()
		
		bad_cloud_node.text_to_cloud = bad_text
		bad_cloud_node._update_cloud()
		
		amelioration_cloud_node.text_to_cloud = amelioration_text
		amelioration_cloud_node._update_cloud()
		
		if num_retroaction != 0 :
			objective_progress_bar.value = objective_offset / num_retroaction
			management_progress_bar.value = management_offset / num_retroaction
			motivation_progress_bar.value = motivation_offset / num_retroaction
			relation_progress_bar.value = relation_offset / num_retroaction
			preparation_progress_bar.value = preparation_offset / num_retroaction
			average_progress_bar.value = average_offset / num_retroaction
		
		print(year_retroaction_progression)
