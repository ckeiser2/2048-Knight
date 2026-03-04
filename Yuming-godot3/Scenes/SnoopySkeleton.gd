extends KinematicBody2D

onready var leftRay = $LeftRay
onready var rightRay = $RightRay
var grid_movement = 64
# Called when the node enters the scene tree for the first time.
func _ready():
	var playerNode = get_node("../Player")
	playerNode.connect("player_moved", self, "_on_player_moved")
	pass # Replace with function body.

func _on_player_moved():
	var left_movement = grid_movement * Vector2.LEFT
	var right_movement = grid_movement * Vector2.RIGHT
	if leftRay.is_colliding() && leftRay.get_collider().name == "Player":
		position += left_movement
	elif rightRay.is_colliding() && rightRay.get_collider().name == "Player":
		position += right_movement
		 
