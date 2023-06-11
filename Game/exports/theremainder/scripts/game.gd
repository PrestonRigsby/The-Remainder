extends Node2D

@onready var bullet = load("res://scenes/bullet.tscn")
@onready var enemy = load("res://scenes/enemy.tscn")

@onready var bullets = $Bullets
@onready var player = $Player
@onready var enemies = $Enemies
@onready var shoottimer = $ShootTimer
@onready var hud = $HUD
@onready var upgradeselection = $HUD/UpgradeSelection
@onready var wavecountdown = $HUD/WaveCountdown 
@onready var wavetimer = $WaveTimer
@onready var healthlabel = $HUD/Health
@onready var ring = $Ring
@onready var enemyspawntimer = $EnemySpawnTimer
@onready var shoot = $Shoot

signal get_is_game_paused(is_game_paused)

var is_game_paused = false

var player_damage = 1

var enemy_instance = null

var health = 2

var fire_rate = null

@onready var enemyspawnrate = enemyspawntimer.wait_time

var has_ring = false
var ring_damage = .5

func _ready():
	hud.visible = true
	fire_rate = shoottimer.wait_time * 100
	shoottimer.start()
	
func _process(delta):
	emit_signal("get_is_game_paused", is_game_paused)
	
	enemyspawntimer.wait_time = enemyspawnrate
	
	ring.position = player.position

	var camera_position = Vector2(player.get_node("Camera2D").get_screen_center_position().x - 576, player.get_node("Camera2D").get_screen_center_position().y - 324)
	hud.position = camera_position
	
	if is_game_paused:
		wavetimer.stop()
	elif wavetimer.is_stopped():
		wavetimer.start()
		
	wavecountdown.text = str(round(wavetimer.time_left)) + " seconds left"
	
	if !is_game_paused:
		wavecountdown.visible = true
		healthlabel.visible = true
	else:
		wavecountdown.visible = false
		healthlabel.visible = false
		
	if health == 2:
		healthlabel.text = "❤❤️"
	elif health == 1:
		healthlabel.text = "❤️️"
	else:
		healthlabel.text = ""
		
	if has_ring:
		hud.get_node("UpgradeSelection/Button3").text = "Upgrade ring"
		
	if fire_rate <= 10:
		hud.get_node("UpgradeSelection").get_node("Button2").disabled = true
		
func get_player(): #Player
	return player

func _on_enemy_spawn_timer_timeout():
	if !is_game_paused:
		enemy_instance = enemy.instantiate()
		enemy_instance.position = Vector2(randi_range(-1792, 2875), randi_range(1829, -1193))
		enemies.add_child(enemy_instance)
		enemy_instance.connect("_enemy_body_entered", _enemy_body_entered)

func _on_shoot_timer_timeout():
	if !is_game_paused:
		shoot.play()
		shoottimer.wait_time = fire_rate/100
		shoottimer.start()
		var instance = bullet.instantiate()
		instance.position = player.position
		instance.look_at(get_global_mouse_position())
		instance.rotation_degrees = player.rotation_degrees
		bullets.add_child(instance)
	
func _enemy_body_entered(body, emiter):
	var enemyhealth = emiter.get_health()
		
	if !is_game_paused:
		if body.name == "Ring":
			enemyhealth -= ring_damage
		elif !body.name == "Player":
			body.queue_free()
			enemyhealth -= 1
		else:
			enemyhealth -= player_damage
			if health > 1:
				health -= 1
			else:
				health = 0
				#death sequence
				get_tree().change_scene_to_file("res://scenes/menu.tscn")
				
		emiter.set_health(enemyhealth)
		if enemyhealth <= 0:
			emiter.queue_free()
		

func _on_wave_timer_timeout():
	#Show HUD
	is_game_paused = true
	emit_signal("get_is_game_paused", is_game_paused)
	upgradeselection.visible = true
			
	if enemyspawnrate > .1:
		enemyspawnrate -= .05
	elif enemyspawnrate >.05:
		enemyspawnrate -= .02

func _on_hud_upgrade(upgrade):
	if upgrade == 1:
		player_damage += .5
		
	if upgrade == 2: #Increase Firerate
		if fire_rate > 60:
			fire_rate -= 20
		else:
			fire_rate -= 10
		
	if upgrade == 3: #Ring
		if has_ring == false:
			has_ring = true
			ring.visible = true
			ring.get_node("CollisionShape2D").disabled = false
		else:
			ring_damage += .5
			
			
		
	is_game_paused = false
	emit_signal("get_is_game_paused", is_game_paused)
	upgradeselection.visible = false
