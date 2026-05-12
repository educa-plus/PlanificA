extends Label

var flash_animation
var flash_animation_timer = Timer.new()

func _ready() -> void:
	flash_animation = Anima.Node(self).anima_animation("flash", 5.0)
	
	self.add_child(flash_animation_timer)
	flash_animation_timer.connect("timeout", _on_flash_animation_timer_timeout)
	flash_animation_timer.start(6.0)
	
func _on_flash_animation_timer_timeout():
	flash_animation.play()
