extends CharacterBody2D


const SPEED = 100
var screen_size : Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	position = screen_size / 2
	

func get_Input():
	var input_dir = Input.get_vector("left","right","up","down")
	velocity = input_dir * SPEED

func _physics_process(delta: float) -> void:
	# Add the gravity.
	get_Input()

	move_and_slide()
	
	if velocity.length() != 0:
		$AnimatedSprite2D.play()
	else :
		$AnimatedSprite2D.stop()
	
