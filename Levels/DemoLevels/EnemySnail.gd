extends CharacterBody2D

var player_group
@export var speed : float

func _ready():
	player_group = get_node("../PlayerGroup")  # Get the player group node

func _process(delta):
	var closest_player = get_closest_player()
	if closest_player:
		var direction = (closest_player.position - position).normalized()
		velocity = direction * speed
		move_and_slide()
	else :
		print("not found ")

func get_closest_player() -> Node:
	var closest_player = null
	var min_distance = INF  # Start with a very large number
	
	for i in range(1, 5):  # Assuming players are named Player1 to Player4
		var player = player_group.get_node("Player" + str(i))
		if player:
			var distance = position.distance_to(player.position)
			if distance < min_distance:
				min_distance = distance
				closest_player = player
	
	return closest_player
