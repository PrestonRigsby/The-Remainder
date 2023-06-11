extends CharacterBody2D

@export var speed = 1.5

@onready var game_node = get_parent()

func get_game_node():
	return game_node

func _physics_process(delta):
	look_at(get_global_mouse_position())
	var horizontal = Input.get_axis("move_left", "move_right") * speed * delta * 10000
	var vertical = Input.get_axis("move_up", "move_down") * speed * delta * 10000
	
	velocity = Vector2(horizontal, vertical)
	
	move_and_slide()
	
