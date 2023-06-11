extends Control

@onready var click = $Click

func _on_toggle_fullscreen_toggled(button_pressed):
	click.play()
	if button_pressed:
		DisplayServer.window_set_mode(3)
	else:
		DisplayServer.window_set_mode(0)

func _on_play_pressed():
	click.play()
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_pressed():
	click.play()
	get_tree().quit()
	print("QUIT")
	
