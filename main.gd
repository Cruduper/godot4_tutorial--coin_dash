extends Node

@export var coin_scene : PackedScene
@export var powerup_scene : PackedScene
@export var playtime = 5
@export var time_bonus = 5
@export var start_coins = 1

var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false



#//***** ENGINE FUNCTIONS *****//#
func _ready():
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	
	
	
func _process(delta):
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time_left += time_bonus
		$LevelSound.play()
		random_time_powerup()
		spawn_coins()
		



#//***** CUSTOM FUNCTIONS *****//#
func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	$UI.update_score(score)
	$UI.update_timer(time_left)
	random_time_powerup()
	spawn_coins()
	
func random_time_powerup():
	if randf() < 0.25:
		$PowerupTimer.stop()
		$PowerupTimer.wait_time = 2
		$PowerupTimer.start()
		
func game_over():
	playing = false
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	$UI.show_game_over()
	$Player.die()
	$EndSound.play()
	
func spawn_coins():
	for i in level + start_coins - 1:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x), 
			randi_range(0, screensize.y))




#//***** SIGNAL CONNECTIONS *****//#
func _on_game_timer_timeout():
	time_left -= 1
	$UI.update_timer(time_left)
	if time_left <= 0:
		game_over()
		
func _on_player_hurt():
	game_over()
	
func _on_player_pickup(type):
	match type:
		"coin":
			score += 1
			$UI.update_score(score)
			$CoinSound.play()
		"powerup":
			time_left += 5
			$UI.update_score(score)
			$PowerupSound.play()
	
func _on_ui_start_game():
	new_game()

func _on_powerup_timer_timeout() -> void:
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(0, screensize.x), 
		randi_range(0, screensize.y))
	
