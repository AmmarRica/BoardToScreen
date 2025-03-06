extends Area2D

@export var object_opened: bool = false
@export var hold_time_required: float = 3.0  # Time in seconds before interaction
@onready var interact_text: Label = $Label  # Reference to the Label node
@onready var object_sprite: AnimatedSprite2D = $AnimatedSprite2D  # Reference to the AnimatedSprite2D node

var player_in_range: bool = false
var holding_time: float = 0.0  # Time accumulated
var countdown: float = hold_time_required  # Countdown timer
var is_counting_down: bool = false  # Flag for countdown
var button_pressed: bool = false  # Tracks if the button was pressed

func _ready() -> void:
	if interact_text:
		interact_text.text = ""
		interact_text.visible = false
	else:
		print("Error: Label node not found!")

func _on_InteractiveObject_area_entered(body: Node) -> void:
	if body.is_in_group("player") and not object_opened:
		player_in_range = true
		interact_text.text = "Press A to Interact"
		interact_text.visible = true

func _on_InteractiveObject_area_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		interact_text.visible = false
		holding_time = 0.0
		countdown = hold_time_required
		is_counting_down = false
		button_pressed = false  # Reset the button press when leaving

func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("A") and not object_opened:
		button_pressed = true  # Player has pressed the button
		is_counting_down = true  # Start the countdown

	if button_pressed and player_in_range and not object_opened:  
		holding_time += delta  
		countdown = max(0, hold_time_required - holding_time)  

		interact_text.text = str(int(countdown) + 1)  

		if holding_time >= hold_time_required:
			open_object()

func open_object() -> void:
	object_opened = true  
	object_sprite.play("open")  
	interact_text.text = "Object Interacted!"  
	interact_text.visible = true  
	is_counting_down = false  
	player_in_range = false  

func _on_body_entered(body: Node2D) -> void:
	_on_InteractiveObject_area_entered(body)

func _on_body_exited(body: Node2D) -> void:
	_on_InteractiveObject_area_exited(body)
