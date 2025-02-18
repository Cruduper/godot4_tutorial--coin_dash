extends Area2D

var screensize = Vector2.ZERO

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		position = Vector2(randi_range(0, screensize.x),
			randi_range(0, screensize.y))
