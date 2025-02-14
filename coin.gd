extends Area2D

var screensize = Vector2.ZERO


func _ready():
	$AnimatedSprite2D.play("shine")
	
func pickup():
	queue_free()
