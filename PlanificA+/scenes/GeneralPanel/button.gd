extends Button

func _ready():
	self.connect("pressed", _on_pressed)
	
func _on_pressed():
	print(self.position)
