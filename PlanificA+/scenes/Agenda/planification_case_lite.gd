extends VBoxContainer

signal retroaction_pressed
signal planif_d_pressed
signal open_menu
signal text_modified

@export var group_code = ""
@export var title = ""
@export var date = {}
@export var notes = ""
@export var type = "period"
@export var heading_modulation = Color(1,1,1,1)
@export var retroaction_visible = false
@export var existing_retroaction = false

@onready var heading_panel = %HeadingPanel
@onready var heading = %Heading
@onready var title_line_edit = %TitleLineEdit

@onready var hard_line = %HardLine

@onready var detail_button = %DetailsButton
@onready var retroaction_button = %RetroactionButton

@onready var text_edit = %PlanifTextEdit
@onready var rich_text_label = %PlanifRichTextLabel

var empty_star_icon = load("res://assets/empty_star.png")
var yellow_star_icon = load("res://assets/yellow_star.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_tree().get_root().size_changed.connect(_on_window_size_changed)
	text_edit.connect("item_rect_changed", _on_window_size_changed)
	#text_edit.connect("item_rect_changed", _adjust_size.bind(text_edit))
	text_edit.connect("text_changed", _update_lines.bind(rich_text_label))
	call_deferred("_update_lines", rich_text_label)
	#call_deferred("_adjust_size", text_edit)


func _on_window_size_changed():
	await get_tree().process_frame
	call_deferred("_update_lines", rich_text_label)

func _update_lines(label: RichTextLabel) :
	# Get the theme font and font size currently used by the label
	var font = label.get_theme_font("main_font")
	var font_size = 12
	# Calculate the width of one underscore character in pixels
	var long_char_width = font.get_string_size("_".repeat(100), HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	var char_width = long_char_width / 100
	# Get the available width of the label (subtracting any padding/margins)
	var label_width = label.size.x

	var num_by_line = floor(label_width / char_width)
	var num_ = num_by_line * text_edit.get_visible_line_count()
	rich_text_label.text = "_".repeat(num_)
	
func _adjust_size(text_edit) :
	var current_height = text_edit.size.y
	var step_size = text_edit.get_line_height()
	var snapped_height = (round(current_height / step_size) * step_size) - 8

	text_edit.size.y = snapped_height

func _update_values() :
	heading.text = group_code
	title_line_edit.text = title
	text_edit.text = notes
	
	retroaction_button.visible = retroaction_visible
	if existing_retroaction :
		retroaction_button.icon = yellow_star_icon
	else :
		retroaction_button.icon = empty_star_icon
	retroaction_button.modulate = Color(1.0 / heading_modulation.r, 1.0 / heading_modulation.g, 1.0 / heading_modulation.b, 1.0 / heading_modulation.a)
	
	heading_panel.modulate = heading_modulation
	hard_line.modulate = heading_modulation
	
	title_line_edit.visible = global_variables.show_title_activated
	
func _on_details_button_pressed() -> void:
	emit_signal("planif_d_pressed")

func _on_retroaction_button_pressed() -> void:
	emit_signal("retroaction_pressed")

func _on_menu_button_pressed() -> void:
	emit_signal("open_menu")

func _on_title_line_edit_text_changed(new_text: String) -> void:
	var filename = "planification_%04d-%02d-%02d-%01d.tres" % [date.year, date.month, date.day, date.period]
	var school_year = global_variables.current_school_year_dir
	var file_path = school_year + "/" + group_code + "/" + filename
		
	if FileAccess.file_exists(file_path):
		var loaded_resource = load(file_path)
		if loaded_resource is SaveCanvaData :
			loaded_resource.title = new_text
			var user_path_error = ResourceSaver.save(loaded_resource, file_path, ResourceSaver.FLAG_COMPRESS)

func _on_planif_text_edit_text_changed() -> void:
	emit_signal("text_modified")
	
	var filename = "planification_%04d-%02d-%02d-%01d.tres" % [date.year, date.month, date.day, date.period]
	var school_year = global_variables.current_school_year_dir
	var file_path = school_year + "/" + group_code + "/" + filename
		
	if FileAccess.file_exists(file_path):
		var loaded_resource = load(file_path)
		if loaded_resource is SaveCanvaData :
			loaded_resource.notes = text_edit.text
			var user_path_error = ResourceSaver.save(loaded_resource, file_path, ResourceSaver.FLAG_COMPRESS)
