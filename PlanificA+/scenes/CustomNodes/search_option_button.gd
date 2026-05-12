extends Control

#@export var group = ""
enum DataType { PDA, PFEQ, STRAT }

@export var data_type = DataType.PDA
@export var info_name = "Progression des apprentissages"
@export var popup_max_size_y = 400

@onready var search_bar = %SearchBar
@onready var option_button = $OptionButton

var total_data_dict = {}
var search_bar_duplicate = null
var item_list = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	option_button.get_popup().connect("about_to_popup", _on_popup_ready)
	option_button.get_popup().connect("visibility_changed", _on_popup_visibility_changed)
	
	search_bar_duplicate = search_bar.duplicate()
	search_bar_duplicate.connect("text_changed", _on_search_bar_text_changed)
	option_button.get_popup().add_child(search_bar_duplicate)
	
	search_bar.hide()
	
	_find_data_dict()
	_populate_option_button(total_data_dict)

func _find_data_dict():
	var corresponding_PDA = {}
	for group in global_variables.groups :
		var year_code = group.level + " " + group.year
		var subject_code = group.subject + " " + year_code
		corresponding_PDA[group.subject] = GouvDocumentation.domaine_apprentissage_dict[group.level][group.subject][group.year]
	total_data_dict = GouvDocumentation.science_et_technologie_sec_4_ST_STE

func _populate_option_button(data):
	if data is Dictionary:
		for key in data.keys():
			var value = data[key]
			# If it's a container, keep digging (Recursion)
			if value is Dictionary :
				_populate_option_button(value)
			# If it's a leaf (not null), add it to the flat list
			elif value == []:
				item_list.append(str(key))
				option_button.add_item(str(key))
			
	
	
func _on_search_bar_text_changed(new_text: String) -> void:
	if new_text == "" :
		_on_option_button_pressed()
	else :
		var search_results = _search_in_dict(new_text.to_lower())
		option_button.clear()
		option_button.add_item("")
		option_button.add_item("")
		_update_option_button_title()
		for result in search_results :
			option_button.add_item(result)

func _search_in_dict(text):
	var result_list = []
	for item in item_list :
		var lowered_item_text = item.to_lower()
		if lowered_item_text.contains(text):
			result_list.append(item)
	return result_list

func _on_popup_ready():
	var popup = option_button.get_popup()
	popup.max_size.x = option_button.size.x
	popup.max_size.y = popup_max_size_y

	
func _on_popup_visibility_changed():
	var popup = option_button.get_popup()
	
	if popup.visible == true :
		_update_option_button_title()
			
		search_bar_duplicate.grab_focus()
		
	elif popup.visible == false :
		_update_option_button_title()

	
func _on_option_button_pressed() -> void:
	item_list = []
	option_button.clear()
	option_button.add_item("")
	option_button.add_item("")
	_populate_option_button(total_data_dict)

func _update_option_button_title():
	await get_tree().process_frame
	var idx = option_button.selected
	if idx == -1 or option_button.get_item_text(idx) == "":
		option_button.text = info_name
