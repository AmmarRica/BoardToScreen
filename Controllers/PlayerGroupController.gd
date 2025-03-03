extends Node

@export var SelectedPlayer: int = 1  # Start with player 1

func _process(delta: float) -> void:
	if Input.is_physical_key_pressed(KEY_1):
		SelectedPlayer = 1
	elif Input.is_physical_key_pressed(KEY_2):
		SelectedPlayer = 2
	elif Input.is_physical_key_pressed(KEY_3):
		SelectedPlayer = 3
	elif Input.is_physical_key_pressed(KEY_4):
		SelectedPlayer = 4
