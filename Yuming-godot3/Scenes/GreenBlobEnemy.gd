extends KinematicBody2D

onready var ray = $GreenRay
var directions = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]
var grid_movement = 64

# Declare member variables here. Examples:
var playerMoveCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var playerNode = get_node("../Player")
	playerNode.connect("player_moved", self, "_on_player_moved")
	pass  # Replace with function body.

func _on_player_moved():
	playerMoveCount += 1
	var random_index = randi() % 4 - 1
	var vector_pos = directions[random_index] * grid_movement
	ray.cast_to = vector_pos
	ray.force_raycast_update()
	if (ray.is_colliding() && ray.get_collider().name == "Player"):
		position += vector_pos
	elif (ray.is_colliding()):
		vector_pos = vector_pos * -1;
		ray.cast_to = vector_pos
		ray.force_raycast_update()
		if (ray.is_colliding() && ray.get_collider().name == "Player"):
			position += vector_pos
		else:
			pass
	else:
		position += vector_pos
