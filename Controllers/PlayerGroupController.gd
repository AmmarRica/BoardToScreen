extends Node

@export var SelectedPlayer1: bool = false
@export var SelectedPlayer2: bool = false
@export var SelectedPlayer3: bool = false
@export var SelectedPlayer4: bool = false

func _process(delta: float) -> void:
	SelectedPlayer1 = Input.is_action_pressed("player1") 
	SelectedPlayer2 = Input.is_action_pressed("player2")
	SelectedPlayer3 = Input.is_action_pressed("player3")
	SelectedPlayer4 = Input.is_action_pressed("player4")
