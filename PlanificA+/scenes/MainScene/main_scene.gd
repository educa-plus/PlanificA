extends Control

var InfoTreePath = "res://scenes/Planif_D_scene/InfoTrees/Information_Trees.tscn"
var DefaultCanvaPath = "res://scenes/Planif_D_scene/DefaultCanva/DefaultCanva.tscn"
var AgendaDisplayPath = "res://scenes/Agenda/AgendaDisplay.tscn"
var GeneralPanelPath = "res://scenes/GeneralPanel/GeneralPanel.tscn"
var ToDoPath = "res://scenes/ToDo/to_do.tscn"
var GeneralInfoSetterPath = "res://scenes/Setter/GeneralInfoSetter.tscn"
var FreeDaySetterPath = "res://scenes/Setter/FreeDaySetter.tscn"
var TimetableSetterPath = "res://scenes/Setter/TimetableSetter.tscn"
var ParameterPath = "res://scenes/Parameter/parameter_scene.tscn"
var RetroactionPath = "res://scenes/Retroaction/retroaction.tscn"
var StatisticsPath = "res://scenes/Statistics/Statistics.tscn"
var SequenceMenuPath = "res://scenes/Sequences/SequenceMenu.tscn"

@export var is_online_demo = true

@onready var UI = $EveryThing/UI
@onready var gray_box = %GrayBox
@onready var User_interface = $EveryThing/UI/User_interface
@onready var Main_UI = $EveryThing/UI/User_interface/Main_UI
@onready var warning_box = $WarningBox
@onready var warning_message_label = %WarningMessageLabel
@onready var no_button = $WarningBox/MarginContainer/VboxContainer/Buttons/No
@onready var yes_button = $WarningBox/MarginContainer/VboxContainer/Buttons/Yes
@onready var update_box = $UpdateBox
@onready var update_title_label = %UpdateTitle
@onready var ignore_update_button = %Ignore
@onready var download_update_button = %Download
@onready var splash_screen = $VideoStreamPlayer
@onready var start_screen = $StartScreenDemo

@onready var Planif = load(DefaultCanvaPath).instantiate()
@onready var InfoTree = load(InfoTreePath).instantiate()
@onready var Agenda = load(AgendaDisplayPath).instantiate()
@onready var General_Panel = load(GeneralPanelPath).instantiate()
@onready var ToDo = %ToDo
@onready var GeneralInfoSetter = load(GeneralInfoSetterPath).instantiate()
@onready var FreeDaySetter = load(FreeDaySetterPath).instantiate()
@onready var TimetableSetter = load(TimetableSetterPath).instantiate()
@onready var Parameter = load(ParameterPath).instantiate()
@onready var Retroaction = load(RetroactionPath).instantiate()
@onready var Statistics = load(StatisticsPath).instantiate()
@onready var SequenceMenu = load(SequenceMenuPath).instantiate()

enum SetterState {
	IDLE,
	TIMETABLE, 
	FREEDAY,
}
var current_state = SetterState.IDLE

var current_month = global_variables.current_date.month
var current_year = global_variables.current_date.year
var current_school_date = {"year": current_year, "month": current_month}
var school_year_name = ""

var pulse_animation
var pulse_animation_timer = Timer.new()

var local_version = global_variables.local_version

func _ready():
	_on_agenda_pressed()
	_on_hamburger_menu_l_pressed()
	
	Planif.connect("new_custom_canva_saved", InfoTree.load_instance_data_resource)
	InfoTree.connect("add_new_canva_to_tree", Planif._save_custom_canva_in_tree)
	InfoTree.connect("apply_a_canva_to_planif", Planif._apply_custom_canva)
	
	for separator in get_tree().get_nodes_in_group("Separator"):
		separator.connect("gui_input", global_variables._on_separator_input.bind(separator))
	
	var setter_node = $EveryThing/OptionsContainer/OptionR/Setter
	setter_node.add_child(pulse_animation_timer)
	pulse_animation = Anima.Node(setter_node).anima_animation("pulse", 0.7)
	pulse_animation_timer.connect("timeout", _on_pulse_animation_timer_timeout)
	pulse_animation_timer.start(1.2)
	
	if not is_online_demo :
		start_screen.hide()
		splash_screen.show()
		splash_screen.play()
	else :
		start_screen.show()
		
	#_check_for_updates()
	
func _process(_delta):
	if Input.is_action_just_pressed("Access Agenda"):
		_on_agenda_pressed()
	if Input.is_action_just_pressed("Access ToDo list"):
		_on_to_do_pressed()
	if Input.is_action_just_pressed("Access Parameter"):
		_on_parameter_pressed()
	if Input.is_action_just_pressed("Access General Panel"):
		_on_hamburger_menu_l_pressed()

func _check_for_updates():
	
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_http_request_completed)
	# L'URL qui pointe vers le fichier JSON
	http.request("https://educa-plus.github.io/PlanificA_Version/PlanificAVersion.json")
	
func _on_http_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var json_text = body.get_string_from_utf8()
		var json_result = JSON.parse_string(json_text)
		
		if json_result is Dictionary:
			var latest_version = json_result.version
			var download_link = json_result.download_url

			if latest_version > local_version:
				print(json_result.release_notes)
				update_title_label.text = "Nouvelle version disponible !" + " v" + latest_version
				ignore_update_button.connect("pressed", _close_update_box)
				download_update_button.connect("pressed", _download_new_version.bind(latest_version, download_link))
				if not is_online_demo :
					update_box.show()
					gray_box.show()
				else :
					update_box.hide()
					gray_box.hide()
				#show_update_dialog(latest_version, download_link)

func _download_new_version(latest_version, download_link):
	var file_path = "user://" + "global_parameters" + ".tres"
	if FileAccess.file_exists(file_path):
		var parameter_resource = ResourceLoader.load(file_path)
		parameter_resource.local_version = latest_version
		var error = ResourceSaver.save(parameter_resource, file_path) # Optionnel: ajouter FLAG_COMPRESS
		if error != OK:
			print("Error during the save of : ", file_path, " Erreur: ", error)
	
	#OS.shell_open(download_link)
	OS.shell_open("https://www.planificaplus.com/télécharger") 
	get_tree().quit()
	
func _close_update_box():
	update_box.hide()
	gray_box.hide()


func _on_pulse_animation_timer_timeout():
	if not global_variables.is_set_for_the_year :
		pulse_animation.play()
	else :
		pulse_animation_timer.stop()

func _on_planif_detail_pressed() -> void:
	var canva_present = is_scene_present(Main_UI, DefaultCanvaPath)
	var tree_present = is_scene_present(Main_UI, InfoTreePath)
	if not canva_present and not tree_present and current_state == SetterState.IDLE:
		for child in Main_UI.get_children():
			if child != General_Panel:
				Main_UI.remove_child(child)
		Main_UI.add_child(Planif)
		Planif.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		Planif.size_flags_stretch_ratio = 0.7
		Planif._new_planif()
		
		var separator = VSeparator.new()  # Create an instance
		Main_UI.add_child(separator)
		separator.connect("gui_input", global_variables._on_separator_input.bind(separator))
		
		Main_UI.add_child(InfoTree)
		InfoTree.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		InfoTree.size_flags_stretch_ratio = 0.3
		InfoTree._update_trees()
		
		
	elif canva_present or tree_present:
		for child in Main_UI.get_children():
			Main_UI.remove_child(child)
			
func _on_agenda_pressed() -> void:
	var present = is_scene_present(Main_UI, AgendaDisplayPath)
	print(present)
	if not present and current_state == SetterState.IDLE:
		for child in Main_UI.get_children():
			if child != General_Panel or child != ToDo :
				Main_UI.remove_child(child)
		Main_UI.add_child(Agenda)
		Agenda.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		Agenda._populate_day()
	elif present:
		pass
		#Main_UI.remove_child(Agenda)

func _update_agenda():
	Agenda._populate_day()
	
func _on_to_do_pressed() -> void:
	#var present = is_scene_present(User_interface, ToDoPath)
	var present = ToDo.visible
	if not present and current_state == SetterState.IDLE:
		ToDo.visible = true
	elif present:
		ToDo.visible = false

func _on_hamburger_menu_l_pressed() -> void:
	var present = is_scene_present(User_interface, GeneralPanelPath)
	if not present and current_state == SetterState.IDLE :
		#General_Panel.size_flags_stretch_ratio = 0.4
		User_interface.add_child(General_Panel)
		User_interface.move_child(General_Panel, 0)
	elif present:
		User_interface.remove_child(General_Panel)

func _on_satistics_pressed() -> void:
	var present = is_scene_present(Main_UI, StatisticsPath)
	if not present and current_state == SetterState.IDLE:
		for child in Main_UI.get_children():
			if child != General_Panel or child != ToDo :
				Main_UI.remove_child(child)
		Main_UI.add_child(Statistics)
		Statistics.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	elif present:
		pass
		#Main_UI.remove_child(Statistics)

func _on_parameter_pressed() -> void:
	var present = is_scene_present(gray_box, ParameterPath)
	gray_box.show()
	if not present :
		gray_box.add_child(Parameter)
	else :
		gray_box.remove_child(Parameter)
		gray_box.hide()
	
func _on_sequence_menu_pressed() -> void:

	#for child in Main_UI.get_children():
	#	Main_UI.remove_child(child)
	
	SequenceMenu = load(SequenceMenuPath).instantiate()
	SequenceMenu.show_bg = false
	UI.add_child(SequenceMenu)
	
func _start_retroaction():
	gray_box.show()
	for child in User_interface.get_children():
		if child != Main_UI :
			User_interface.remove_child(child)
	for child in Main_UI.get_children():
		Main_UI.remove_child(child)
	gray_box.add_child(Retroaction)
	
	Retroaction.load_instance_data_resource()
	Retroaction.set_h_size_flags(Control.SIZE_SHRINK_CENTER)
	Retroaction.set_v_size_flags(Control.SIZE_SHRINK_CENTER)

func _quit_retroaction():
	gray_box.remove_child(Retroaction)
	gray_box.hide()
	_on_agenda_pressed()
	_on_hamburger_menu_l_pressed()

func _on_setter_pressed() -> void:
	if current_state == SetterState.IDLE :
		_setter_check()

func _setter_check():
	print(current_state)
	match current_state:
		SetterState.IDLE:
			warning_box.show()
			#[font_size=12][color=red](Si une planification n'est pas sauvegardée, elle sera perdue)[/color][/font_size]
			warning_message_label.text = "Voulez-vous générer une planification complète de votre année scolaire ?"
			warning_message_label.text += "\n\nPour compléter le générateur, vous aurez [font_size=16][u]besoin[/u][/font_size] de votre [font_size=16][u]horaire[/u][/font_size] et [font_size=16][u]calendrier scolaire[/u][/font_size]"
			warning_message_label.text += "\nLe processus complet prend généralement entre 5 et 15 minutes"
			warning_message_label.text += "\n[font_size=12][color=red](Pour réajuster les valeurs entrées dans le générateur, vous devrez recommencer le processus à zéro)[/color][/font_size]"
			
			#It is good practice to disconnect the existing connections to avoid calling multiple functions
			var no_button_connections = no_button.pressed.get_connections()
			for connection in no_button_connections:
				var callable_to_disconnect = connection.callable
				no_button.pressed.disconnect(callable_to_disconnect)
			no_button.connect("pressed", _no_setter)
			
			yes_button.connect("pressed", _set_timetable)
			print("IDLE")
			
		SetterState.TIMETABLE:
			warning_box.show()
			warning_message_label.text = "Nous vous demandons de bien vouloir vérifier l'exactitude des informations que vous avez entrées.\nConfirmez-vous que ces données sont correctes ?"
			warning_message_label.text += "\n[font_size=12][color=red](Pour réajuster ces valeurs, vous devrez recommencer le processus à zéro)[/color][/font_size]"
			
			#It is good practice to disconnect the existing connections to avoid calling multiple functions
			var yes_button_connections = yes_button.pressed.get_connections()
			for connection in yes_button_connections:
				var callable_to_disconnect = connection.callable
				yes_button.pressed.disconnect(callable_to_disconnect)
			yes_button.connect("pressed", _set_free_day)
			print("TIMETABLE")
		
		SetterState.FREEDAY:
			warning_box.show()
			warning_message_label.text = "Nous vous demandons de bien vouloir vérifier l'exactitude des informations que vous avez entrées.\nConfirmez-vous que ces données sont correctes ?"
			warning_message_label.text += "\n[font_size=12][color=red](Pour réajuster ces valeurs, vous devrez recommencer le processus à zéro)[/color][/font_size]"
			
			#It is good practice to disconnect the existing connections to avoid calling multiple functions
			var yes_button_connections = yes_button.pressed.get_connections()
			for connection in yes_button_connections:
				var callable_to_disconnect = connection.callable
				yes_button.pressed.disconnect(callable_to_disconnect)
			yes_button.connect("pressed", _complete_setter)

func _no_setter():
	warning_box.hide()

func _set_timetable():
	current_state = SetterState.TIMETABLE
	warning_box.hide()
	gray_box.show()
	for child in gray_box.get_children():
		gray_box.remove_child(child)
			
	for child in User_interface.get_children():
		if child != Main_UI :
			if child == ToDo :
				child.hide()
			else :
				User_interface.remove_child(child)
	
	for child in Main_UI.get_children():
		Main_UI.remove_child(child)
	
	TimetableSetter = load(TimetableSetterPath).instantiate()
	gray_box.add_child(TimetableSetter)
	
func _set_free_day():
	current_state = SetterState.FREEDAY
	warning_box.hide()
	for child in User_interface.get_children():
		if child != Main_UI :
			if child == ToDo :
				child.hide()
			else :
				User_interface.remove_child(child)
			
	for child in Main_UI.get_children():
		Main_UI.remove_child(child)
	
	for child in gray_box.get_children():
		gray_box.remove_child(child)

	FreeDaySetter = load(FreeDaySetterPath).instantiate()
	gray_box.add_child(FreeDaySetter)

	print("it_work")

func _complete_setter():
	warning_box.hide()
	for child in gray_box.get_children():
		gray_box.remove_child(child)
	gray_box.hide()
	print(Agenda)
	print(Main_UI)
	current_state = SetterState.IDLE
	global_variables._update_all_value()
	_on_agenda_pressed()
	#_on_agenda_pressed()
	Agenda._update_all_value()
	General_Panel._update_general_panel()
	_on_hamburger_menu_l_pressed()
	

func is_scene_present(parent: Node, scene_path: String) -> bool:
	print(parent)
	for child in parent.get_children():
		print(child)
		if child.scene_file_path == scene_path:
			return true
	return false


func _on_start_planific_a_pressed() -> void:
	splash_screen.play()
	splash_screen.show()
	start_screen.hide()


func _on_video_stream_player_finished() -> void:
	splash_screen.hide()


func _on_support_pressed() -> void:
	OS.shell_open("https://www.planificaplus.com/communaut%C3%A9")
