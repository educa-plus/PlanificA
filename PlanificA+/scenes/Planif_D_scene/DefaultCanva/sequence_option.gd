extends MenuButton

signal create_sequence
signal add_sequence
# {id : nom}

var sequence_options = {
	0 : "Créer une séquence",
	1 : "Ajouter à une séquence",
	}

func _ready():
	# Ensure the popup is created
	if get_popup() == null:
		print("Warning: MenuButton's popup is not set. Please assign a PopupMenu.")
		return
	
	var popup = get_popup()
	for id in sequence_options :
		var text = sequence_options[id]
		popup.add_item(text, id)
		
	popup.id_pressed.connect(_on_popup_id_pressed)
	
func _on_popup_id_pressed(id):
	match id :
		0 :
			emit_signal("create_sequence")
		1 :
			emit_signal("add_sequence")
		
