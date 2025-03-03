extends CharacterBody2D


const SPEED = 100
var screen_size : Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	position = screen_size / 2
	

func get_Input():
	var input_dir = Input.get_vector("left","right","up","down")
	velocity = input_dir.normalized() * SPEED

func _physics_process(delta: float) -> void:
	# Add the gravity.
	get_Input()
	move_and_slide()

# will axdd different directions later
	var mouse = get_local_mouse_position()
	var mousy = velocity/SPEED
	var angle = snappedf(mousy.angle(), PI/4) / (PI/4)
	angle = wrapi(int(angle), 0 , 8)
	$AnimatedSprite2D.animation = "walk"+ str(angle)
		
	if velocity.length() != 0:
		$AnimatedSprite2D.play()
	else :
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.animation = "walk2"
		$AnimatedSprite2D.frame = 1
	
