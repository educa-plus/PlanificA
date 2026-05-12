extends Control

@onready var tab_container = %TabContainer
@onready var to_do_tab = $"TabContainer/À faire"
@onready var finished_tab = $"TabContainer/Terminé"
@onready var task_vbox = %TaskVbox
@onready var task_container = %TaskBox
@onready var finished_task_container = %FinishedTaskVbox
@onready var task_scene = load("res://scenes/ToDo/task.tscn")

func _ready():
	#This is a way to make it force update so the task's size fit in the container
	to_do_tab.show()
	await get_tree().process_frame
	finished_tab.show()
	await get_tree().process_frame
	to_do_tab.show()
	#load_instance_data_resource()

func _on_add_task_pressed():
	_add_task(task_container)
	_update_task_order()
	#for i in range(4):
	#	await get_tree().process_frame
	#task_container.queue_sort()
	
func _add_task(container, loaded_resource=null):
	var new_task = task_scene.instantiate()
	new_task.connect("tree_exited", _reorganise_task_container)
	if loaded_resource != null :
		new_task.task_code = loaded_resource.task_code
		new_task.task_order = loaded_resource.task_order
	
	container.add_child(new_task)
	new_task._load_instance_task_resource()

func _on_basket_pressed() -> void:
	for task in finished_task_container.get_children():
		task._on_delete_task_pressed()
	#save_instance_data_resource()

func load_instance_data_resource():
	var to_do_dir_path = "user://" + "to_do_list" + "/"
	var to_do_files = global_variables._find_all_files_in_dir(to_do_dir_path)
	for file in to_do_files :
		var file_path = to_do_dir_path + file
		var loaded_resource = load(file_path)
		apply_save_data_from_resource(loaded_resource)
	
	_reorganise_task_container()
			
			
func apply_save_data_from_resource(loaded_resource):
	if loaded_resource.task_progress < 100:
		_add_task(task_container, loaded_resource)
	else :
		_add_task(finished_task_container, loaded_resource)
	
	#for i in range(2):
	#	await get_tree().process_frame

func _reorganise_task_container():
	var task_list = task_container.get_children()
	for task in task_list :
		if task.task_order != -1 and task.task_order < task_list.size() :
			task_container.move_child(task, task.task_order)

func _on_task_box_reordered(_from: int, _to: int) -> void:
	_update_task_order()

func _update_task_order():
	for task in task_container.get_children() :
		task.task_order = task.get_index()
		task._save_instance_task_resource()

func _on_tab_container_tab_changed(tab: int) -> void:
	if finished_task_container != null and task_container != null :
		for child in finished_task_container.get_children() :
			child.queue_free()
		for child in task_container.get_children() :
			child.queue_free()
		load_instance_data_resource()
	#for i in range(10):
	#	tab_container.queue_sort()
	#	await get_tree().process_frame
