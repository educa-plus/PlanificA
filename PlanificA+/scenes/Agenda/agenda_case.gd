extends PanelContainer

signal text_modified

@export var date = {}
@export var type = ""
@export var loaded_text = ""
@export var modulation = Color(1,1,1,0.3)
@export var lines_visibles = false

@onready var heading_label = %Heading
@onready var text_edit = %PlanifTextEdit
@onready var rich_text_label = %PlanifRichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_edit.connect("item_rect_changed", _on_window_size_changed)
	text_edit.connect("text_changed", _update_lines.bind(rich_text_label))
	call_deferred("_update_lines", rich_text_label)
	#call_deferred("_adjust_size", text_edit)


func _on_window_size_changed():
	await get_tree().process_frame
	call_deferred("_update_lines", rich_text_label)

func _update_lines(label: RichTextLabel) :
	# Get the theme font and font size currently used by the label
	var font = label.get_theme_font("main_font")
	var font_size = text_edit.get_theme_font_size("font_size")
	# Calculate the width of one underscore character in pixels
	var long_char_width = font.get_string_size("_".repeat(100), HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	var char_width = long_char_width / 100
	# Get the available width of the label (subtracting any padding/margins)
	var label_width = label.size.x

	var num_by_line = floor(label_width / char_width)
	var num_ = num_by_line * text_edit.get_visible_line_count()
	if lines_visibles :
		rich_text_label.text = "_".repeat(num_)
	else :
		rich_text_label.text = ""
	
func _update_values():
	if loaded_text == "" :
		self.modulate = modulation
	else :
		self.modulate = Color(1,1,1,1)
	text_edit.text = loaded_text
	text_edit.connect("text_changed", _save_instance_agenda_resource.bind(text_edit, type))

func _save_instance_agenda_resource(text_edit, type):
	emit_signal("text_modified")
	if text_edit.text == "" :
		self.modulate = modulation
	else :
		self.modulate = Color(1,1,1,1)
		
	var filename = generate_agenda_coded_filename_resource(type)
	var school_year = global_variables.current_school_year_dir
	var file_path = school_year + "/" + "agenda_folder" + "/" + filename
	var data_resource = null
	if FileAccess.file_exists(file_path):
		var loaded_resource = load(file_path)
		if loaded_resource is SaveAgendaData :
			data_resource = loaded_resource
	else :
		data_resource = SaveAgendaData.new()
	
	data_resource.text_data = text_edit.text
	
	var error = ResourceSaver.save(data_resource, file_path) # Optionnel: ajouter FLAG_COMPRESS
	if error != OK:
		print("Error during the save of : ", file_path, " Erreur: ", error)

func generate_agenda_coded_filename_resource(type):
	var day = date.day
	var month = date.month
	var year = date.year
	var filename = ""
	if type == "noon" or type == "evening" :
		filename = "agenda_" + type + "_data_%04d-%02d-%02d.tres" % [year, month, day]
	if type == "empty_period" :
		var period = date.period
		filename = "agenda_" + type + "_data_%04d-%02d-%02d-%01d.tres" % [year, month, day, period]
	return filename
