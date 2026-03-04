extends KinematicBody2D

onready var ray = $BlueRay
var grid_movement = 64
var tick = 1;
var inputs = [Vector2.LEFT,Vector2.RIGHT]

# Called when the node enters the scene tree for the first time.
func _ready():
	var playerNode = get_node("../Player")
	playerNode.connect("player_moved", self, "_on_player_moved")

func _on_player_moved():
	tick += 1;
	var vector_pos = inputs[tick % 2] * grid_movement
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
		position += vector_pos
