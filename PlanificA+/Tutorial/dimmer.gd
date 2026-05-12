extends ColorRect

@export var exclusion_rect = Rect2(Vector2(0, 0), Vector2(0, 0))

func _has_point(point: Vector2) -> bool:
	# Définir une zone d'exclusion locale (ex: un trou au centre)
	if exclusion_rect.has_point(point):
		return false
	return true
