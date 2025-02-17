extends Area2D

var screensize = Vector2.ZERO


func _ready():
	$AnimatedSprite2D.play("shine")
	
func pickup():
	$"coin hitbox".set_deferred("disabled", true)
	var ser_twn = create_tween().set_trans((Tween.TRANS_CIRC))
	ser_twn.tween_property(self, "scale", scale * 0.75, 0.1)
	await ser_twn.finished
	var para_twn = create_tween().set_parallel().set_trans((Tween.TRANS_LINEAR))
	para_twn.tween_property(self, "scale", scale * 2.2, 0.3)
	para_twn.tween_property(self, "modulate:a", 0.2, 0.3)
	await para_twn.finished
	queue_free()
	
