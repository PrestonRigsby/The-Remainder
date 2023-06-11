extends Control

@onready var click = $Click

signal upgrade(upgrade)

func _on_button_pressed():
	click.play()
	emit_signal("upgrade", 1)

func _on_button_2_pressed():
	click.play()
	emit_signal("upgrade", 2)

func _on_button_3_pressed():
	click.play()
	emit_signal("upgrade", 3)
