extends Node

@export var coin_scene : PackedScene
@export var powerup_scene : PackedScene
@export var cactus_scene: PackedScene
@export var playtime = 5
@export var time_bonus = 5
@export var pwrup_time_bonus = 5
@export var start_coins = 1
@export var start_cactus = 1
@export var cactii_incr_interval = 5

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
		level_up()
		



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
	spawn_cactii()
	spawn_coins()
	
func level_up():
		level += 1
		time_left += time_bonus
		$LevelSound.play()
		random_time_powerup()
		spawn_coins()
		if int(level) % cactii_incr_interval == 0:
			spawn_cactii()
	
func random_time_powerup():
	if randf() < 0.25:
		$PowerupTimer.stop()
		$PowerupTimer.wait_time = 2
		$PowerupTimer.start()
		
func game_over():
	playing = false
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	get_tree().call_group("obstacles", "queue_free")
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
			
func spawn_cactii():
	get_tree().call_group("obstacles", "queue_free")
	for i in  (level / cactii_incr_interval) + start_cactus:
		var potential_position = Vector2(randi_range(0, screensize.x), 
			randi_range(0, screensize.y))
		var player_position = $Player.position
		var c = cactus_scene.instantiate()
		add_child(c)
		while is_colliding(potential_position, player_position, 60):
			potential_position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
		c.position = potential_position

func is_colliding(area: Vector2, area2: Vector2, safety_margin: int) -> bool:
	if abs(area.x - area2.x) < safety_margin and abs(area.y - area2.y) < safety_margin:
		return true
	else:
		return false




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
			time_left += pwrup_time_bonus
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
		
		
