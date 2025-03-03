extends CharacterBody2D

@export var player_number: int

const SPEED = 100
var screen_size: Vector2
var last_direction: Vector2 = Vector2.DOWN  # Default to facing down

func _ready() -> void:
	screen_size = get_viewport_rect().size 
	var center_x = screen_size.x / 2
	var center_y = screen_size.y / 2
	
	# Define offsets for 4 players (adjust as needed)
	var spawn_offsets = [
		Vector2(5, 5),  # Player 1
		Vector2(5, -5), # Player 2
		Vector2(-5, 5), # Player 3
		Vector2(-5, -5) # Player 4
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

func get_Input():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	if input_dir != Vector2.ZERO:
		last_direction = input_dir  # Store last direction
	velocity = input_dir.normalized() * SPEED

func _physics_process(delta: float) -> void:
	if player_number != $"..".SelectedPlayer:
		return

	get_Input()
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
