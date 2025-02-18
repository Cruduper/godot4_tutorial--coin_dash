extends Area2D

var screensize = Vector2.ZERO
var first_anim_loop = true

func _ready():
	random_shine_animation()
	first_anim_loop = false
	
	
	
func pickup():
	$"coin hitbox".set_deferred("disabled", true)
	var ser_twn = create_tween().set_trans((Tween.TRANS_CIRC))
	ser_twn.tween_property(self, "scale", scale * 0.75, 0.1)
	await ser_twn.finished
	var para_twn = create_tween().set_parallel().set_trans((Tween.TRANS_LINEAR))
	para_twn.tween_property(self, "scale", scale * 2, 0.2)
	para_twn.tween_property(self, "modulate:a", 0.2, 0.2)
	await para_twn.finished
	queue_free()
	
func random_shine_animation():
	if first_anim_loop == false:
		$AnimatedSprite2D.frame = 0
		$AnimatedSprite2D.play("shine")
		first_anim_loop = !first_anim_loop
	$Timer.start(randf_range(1, 4))



func _on_timer_timeout() -> void:
	random_shine_animation()
	
