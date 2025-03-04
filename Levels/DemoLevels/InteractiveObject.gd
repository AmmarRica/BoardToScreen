extends Area2D

@export var object_opened: bool = false
@export var hold_time_required: float = 3.0  # Time in seconds to hold the button before interaction (e.g., 3 seconds)
@onready var interact_text: Label = $Label  # Reference to the Label node
@onready var object_sprite: AnimatedSprite2D = $AnimatedSprite2D  # Reference to the AnimatedSprite2D node

var player_in_range: bool = false
var holding_time: float = 0.0  # Time accumulated while holding the button
var countdown: float = hold_time_required  # Countdown timer (starts at the required hold time)
var is_counting_down: bool = false  # Flag to check if the countdown is active

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Ensure interact_text is assigned correctly
	if interact_text:
		interact_text.text = ""  # Initially no interaction text
		interact_text.visible = false  # Make sure the text is hidden
	else:
		print("Error: Label node not found!")  # Debug message if the Label node isn't found

# Detect when any player enters the object's area
func _on_InteractiveObject_area_entered(body: Node) -> void:
	if body.is_in_group("player") and not object_opened:  # Check if the body that entered is part of the player group
		player_in_range = true
		interact_text.text = "Hold Z to Interact"
		interact_text.visible = true

# Detect when any player exits the object's area
func _on_InteractiveObject_area_exited(body: Node) -> void:
	if body.is_in_group("player"):  # Check if the body that exited is part of the player group
		player_in_range = false
		interact_text.visible = false
		holding_time = 0.0  # Reset hold time if the player leaves the area
		countdown = hold_time_required  # Reset the countdown timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Start counting down when the player is within range and holding Z, but only if the object is not opened
	if player_in_range and Input.is_physical_key_pressed(KEY_Z) and not object_opened:  
		if not is_counting_down:
			is_counting_down = true  # Start the countdown when Z is pressed
		holding_time += delta  # Increment the holding time
		countdown = max(0, hold_time_required - holding_time)  # Decrease the countdown
		
		# Display the countdown in the label, starting from 1 second to hold_time_required
		interact_text.text = str(int(countdown) + 1)  # Add 1 to prevent showing 0 or negative numbers
		
		# If the hold time exceeds the required time, open the object
		if holding_time >= hold_time_required:
			if not object_opened:
				open_object()
	else:
		holding_time = 0.0  # Reset the holding time if the player stops holding Z
		countdown = hold_time_required  # Reset the countdown to the initial value
		if is_counting_down:
			is_counting_down = false  # Stop the countdown when Z is released

# Function to "open" or "interact" with the object
func open_object() -> void:
	object_opened = true  # Mark the object as opened
	object_sprite.play("open")  # Play the "open" animation (make sure the animation exists)
	
	interact_text.text = "Object Interacted!"  # Update the text when the object is opened
	interact_text.visible = true  # Ensure the text is visible after the interaction

	# Disable further interaction
	player_in_range = false  # Stop interaction since the object is opened
	

func _on_body_entered(body: Node2D) -> void:
	_on_InteractiveObject_area_entered(body)

func _on_body_exited(body: Node2D) -> void:
	_on_InteractiveObject_area_exited(body)
