extends CharacterBody2D

@export var player_number: int
@export var SelectedPlayer1: bool = false
@export var SelectedPlayer2: bool = false
@export var SelectedPlayer3: bool = false
@export var SelectedPlayer4: bool = false

const SPEED = 100
var screen_size: Vector2
var last_direction: Vector2 = Vector2.DOWN  # Default to facing down

func _ready() -> void:
	add_to_group("player")
	screen_size = get_viewport_rect().size 
	var center_x = screen_size.x / 2
	var center_y = screen_size.y / 2
	
	# Define offsets for 4 players (adjust as needed)
	var spawn_offsets = [
		Vector2(10, 10),  # Player 1
		Vector2(10, -10), # Player 2
		Vector2(-10, 10), # Player 3
		Vector2(-10, -10) # Player 4
	]

	# Apply spawn offset based on player number
	if player_number >= 1 and player_number <= spawn_offsets.size():
		position = Vector2(center_x, center_y) + spawn_offsets[player_number - 1]
	
	# Assign a color based on player_number
	assign_player_color()

func assign_player_color() -> void:
	# Change the color for each player
	match player_number:
		1:
			$AnimatedSprite2D.modulate = Color(1, 0, 0)  # Red
		2:
			$AnimatedSprite2D.modulate = Color(0, 1, 0)  # Green
		3:
			$AnimatedSprite2D.modulate = Color(0, 0, 1)  # Blue
		4:
			$AnimatedSprite2D.modulate = Color(1, 1, 0)  # Yellow
		_:
			$AnimatedSprite2D.modulate = Color(1, 1, 1)  # Default (White)

func _get_input():
	# Determine if this player is selected
	var is_selected = (
		(player_number == 1 and $"..".SelectedPlayer1) or
		(player_number == 2 and $"..".SelectedPlayer2) or
		(player_number == 3 and $"..".SelectedPlayer3) or
		(player_number == 4 and $"..".SelectedPlayer4)
	)

	# Only process movement if the player is selected
	if is_selected:
		var input_dir = Input.get_vector("left", "right", "up", "down")
		if input_dir != Vector2.ZERO:
			last_direction = input_dir  # Store last direction
		velocity = input_dir.normalized() * SPEED
	else:
		velocity = Vector2.ZERO  # Stop movement if not selected

func _physics_process(delta: float) -> void:
	_get_input()
	move_and_slide()

	# Determine animation direction based on movement or last direction
	var dir = velocity if velocity.length() != 0 else last_direction
	var angle = snappedf(dir.angle(), PI/4) / (PI/4)
	angle = wrapi(int(angle), 0, 8)
	$AnimatedSprite2D.animation = "walk" + str(angle)
		
	if velocity.length() != 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.animation = "walk" + str(angle)  # Use last direction
		$AnimatedSprite2D.frame = 1
