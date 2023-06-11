extends Area2D

@export var speed = 100

var is_game_paused = false

var game_node = null
var player = null

var connected = false

var health = 2

signal _enemy_body_entered(body, emiter)

func _ready():
	var packed_scene = get_parent()
	player = packed_scene.get_parent().get_player()
	game_node = player.get_game_node()
	
func _process(delta):
	if game_node != null and !connected:
		game_node.connect("get_is_game_paused", get_is_game_paused)
		connected = true

func _physics_process(delta):
	if is_instance_valid(player) and !is_game_paused:
		position = position.move_toward(player.position, delta * speed)
		look_at(player.position)
		
func get_health():
	return health
	
func set_health(health_):
	health = health_
	
func _on_body_entered(body):
	emit_signal("_enemy_body_entered", body, self)
	health -= 1
	
func get_is_game_paused(game_paused):
	is_game_paused = game_paused
