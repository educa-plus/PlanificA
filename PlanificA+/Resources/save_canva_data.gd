extends Resource

class_name SaveCanvaData

@export var text_entries: Dictionary = {}
@export var text_sizes: Dictionary = {}
@export var title = ""
@export var notes = "" #The text that is shown in the agenda
@export var duration = "" #not necessary
@export var items_data = {
	"Année scolaire" : {"checkable" : true, "checked" : true, "id" : 0}, 
	"Date" : {"checkable" : true, "checked" : true, "id" : 2},
	"Groupe" : {"checkable" : true, "checked" : true, "id" : 1},
	"Exporter" : {"checkable" : true, "checked" : true, "id" : 3},
	"Enregistrer sous" : {"checkable" : false, "id" : 4}
	}
@export var is_custom_path = false
@export var custom_path = ""

@export var empty = true

@export var custom_canva: PackedScene = null
@export var local_groups_dict = {}
