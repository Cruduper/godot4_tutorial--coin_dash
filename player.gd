extends Area2D

signal pickup
signal hurt

@export var speed = 350
var velocity = Vector2.ZERO
var screensize = Vector2.ZERO



#//***** ENGINE FUNCTIONS *****//#
func _process(delta: float) -> void:
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += velocity * speed * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0 , screensize.y)
	
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
	else: 
		$AnimatedSprite2D.animation = "idle"
		
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
		
	
	
#//***** CUSTOM FUNCTIONS *****//#	
func start():
	set_process(true)
	position = screensize / 2
	$AnimatedSprite2D.animation = "idle"
	
func die():
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)
	


#//***** SIGNAL CONNECTIONS *****//#
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")
	if area.is_in_group("powerup"):
		area.pickup()
		pickup.emit("powerup")
	if area.is_in_group("obstacles"):
		hurt.emit()
		die()
