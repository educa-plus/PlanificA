extends CanvasLayer

@export var tutorial_sequence : PackedStringArray = []

@onready var dimmer_node = %Dimmer
@onready var tuto_text_label = %TutoTextLabel
@onready var bubble_container = %BubbleContainer

@onready var tuto_lbutton = %TutoLButton
@onready var tuto_rbutton = %TutoRButton

var circular_spot_light = load("res://Shaders/CircularSpotlight.gdshader")
var rectangular_spot_light = load("res://Shaders/RectangularSpotlight.gdshader")

var current_step_index = -1
var current_step = null
var current_target = null
var current_pass_throuht = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	get_window().size_changed.connect(_on_dimmer_item_rect_changed)
	
	_start_tuto_sequence()
	

func _start_tuto_sequence():
	if tutorial_sequence.size() > 0 :
		current_step_index = 0
		var step = load(tutorial_sequence[current_step_index])
		show_step(step)

func show_step(step: TutorialStepData):
	var main_node = get_tree().current_scene
	#print(step.tutorial_node_name)
	var target = main_node.find_child(step.tutorial_node_name, true, false)
	var trigger_node = main_node.find_child(step.trigger_node_name, true, false)
	current_step = step
	if target:
		current_target = target
		# On déplace la bulle près du bouton cible
		var pass_throuht = target == trigger_node
		current_pass_throuht = pass_throuht
		_update_target_position(target, pass_throuht, step)

		if step.rbutton_text != "" :
			tuto_rbutton.text = step.rbutton_text
		else :
			tuto_rbutton.hide()
			
		if step.lbutton_text != "" :
			tuto_lbutton.text = step.lbutton_text
		else :
			tuto_lbutton.hide()
		
		await trigger_node.connect(step.trigger_signal, _on_step_completed.bind(trigger_node, step.trigger_signal))

func _update_target_position(target, pass_throuht, step):
	var viewport_rect = get_viewport().get_visible_rect()
	var target_pos = target.global_position

	bubble_container.global_position = target_pos + Vector2(0, target.size.y + 10)
	tuto_text_label.text = step.tutorial_text_indication
	
	await get_tree().process_frame
	
	var bubble_container_limit_point_x = Vector2(bubble_container.global_position.x + bubble_container.size.x, 0)
	var bubble_container_limit_point_y = Vector2(0, bubble_container.global_position.y + bubble_container.size.y)
	if not viewport_rect.encloses(bubble_container.get_global_rect()):
		if not viewport_rect.has_point(bubble_container_limit_point_x) :
			bubble_container.global_position.x -= bubble_container.size.x
		if not viewport_rect.has_point(bubble_container_limit_point_y) :
			bubble_container.global_position.y -= bubble_container.size.y + target.size.y + 20
	
	_update_dimmer(step.is_shader_circular, target, pass_throuht)
	
func _update_dimmer(is_shader_circular, target_node, pass_throuht):
	var target_rect = target_node.get_global_rect()
	if pass_throuht :
		dimmer_node.exclusion_rect = target_rect
	else :
		dimmer_node.exclusion_rect = Rect2(Vector2(0, 0), Vector2(0, 0))
	
	var material = dimmer_node.material as ShaderMaterial
	var center = target_rect.position + (target_rect.size / 2.0)
	
	if is_shader_circular == true :
		dimmer_node.material.shader = circular_spot_light
		material.set_shader_parameter("target_pos", center)
		material.set_shader_parameter("target_radius", (max(target_rect.size.x, target_rect.size.y)/2) + 8)
		
	if is_shader_circular == false :
		dimmer_node.material.shader = rectangular_spot_light
		material.set_shader_parameter("target_pos", center)
		material.set_shader_parameter("target_size", target_rect.size + Vector2(10, 10))

func _on_step_completed(trigger_node, trigger_signal):
	#print("completed")
	trigger_node.disconnect(trigger_signal, _on_step_completed)
	current_step_index += 1
	if tutorial_sequence.size() > current_step_index :
		var step = load(tutorial_sequence[current_step_index])
		show_step(step)
	else :
		self.hide()

func _on_dimmer_item_rect_changed() -> void:
	if current_target != null and current_step != null :
		await get_tree().process_frame
		_update_target_position(current_target, current_pass_throuht, current_step)
