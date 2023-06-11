extends CharacterBody2D

@export var speed = 1000

@onready var mouse_position: Vector2 = get_global_mouse_position()
@onready var angle = deg_to_rad(rotation_degrees)
@onready var direction = Vector2(cos(angle), sin(angle)).normalized()

func _process(delta):
	rotation_degrees = rad_to_deg(angle)
	
	var collider = move_and_collide(direction * speed * delta)
	
	if collider: # Collision
		queue_free()
