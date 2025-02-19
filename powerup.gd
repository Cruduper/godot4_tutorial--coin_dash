extends Area2D

var screensize = Vector2.ZERO
var is_in_pickup = false



#//***** ENGINE FUNCTIONS *****//#	
func _ready():
	$AnimatedSprite2D.play("pwrup_shine")
	


#//***** CUSTOM FUNCTIONS *****//#	
func pickup():
	is_in_pickup = true
	$"pwrup hitbox".set_deferred("disabled", true)
	var ser_twn = create_tween().set_trans((Tween.TRANS_CIRC))
	ser_twn.tween_property(self, "scale", scale * 0.69, 0.1)
	await ser_twn.finished
	var para_twn = create_tween().set_parallel().set_trans((Tween.TRANS_LINEAR))
	para_twn.tween_property(self, "scale", scale * 4.20, 1.666)
	blink(self)
	await para_twn.finished
	queue_free()
	is_in_pickup = false
	
func blink(node):
	var para_twn = create_tween().set_trans(Tween.TRANS_QUART)
	para_twn.tween_property(node, "modulate:a", 0.25, frames_to_seconds(3))  # Fade out
	para_twn.tween_property(node, "modulate:a", 0.75, frames_to_seconds(3))  # Fade in
	#para_twn.tween_property(self, "modulate:a", 0.69, .1)
	para_twn.connect("finished", Callable(self, "blink").bind(node))  # Repeat to keep blinking

func frames_to_seconds(frames) -> float:
	return float(frames) / 60.0
	


#//***** SIGNAL CONNECTIONS *****//#	
func _on_lifetime_timeout() -> void:
	if !is_in_pickup:
		queue_free()
		
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("obstacles"):
		position = Vector2(randi_range(0, screensize.x),
			randi_range(0, screensize.y))
