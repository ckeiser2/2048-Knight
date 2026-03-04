extends KinematicBody2D

onready var ray = $RayCast2D
onready var area2d = $Area2D
var grid_movement = 64
var inputs = {
	'ui_up': Vector2.UP,
	'ui_down': Vector2.DOWN,
	'ui_left': Vector2.LEFT,
	'ui_right': Vector2.RIGHT
}
var walk_animations = {
	'ui_up': "walk_up",
	'ui_down': "walk_down",
	'ui_left': "walk_left",
	'ui_right': "walk_right"
}
var latestPlayerHealth = GlobalNode.PlayerHealth
var move_triggered = false
signal player_moved()
signal key_acquired()
var last_vector = Vector2.ZERO

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	var vector_pos = inputs[dir] * grid_movement
	ray.cast_to = vector_pos
	ray.force_raycast_update()
	var collider = ray.get_collider()
	if !ray.is_colliding():
		last_vector = vector_pos
		move_triggered = true
		emit_signal("player_moved")
		$AnimatedSprite.play(walk_animations[dir])
		$WalkAudio.play()
		if (latestPlayerHealth != GlobalNode.PlayerHealth):
			print("Player Health is now:" + str(GlobalNode.PlayerHealth))
	elif ray.is_colliding() && collider.is_in_group("Enemy"):
		last_vector = vector_pos
		move_triggered = true
		$WalkAudio.play()
	elif collider.is_in_group("torch"):
		SignalBus.emit_signal("display_dialog", "torch")
	elif collider.is_in_group("Chest"):
		$ChestOpenAudio.play()
		yield(get_tree().create_timer(0.09), "timeout")
		SignalBus.emit_signal("display_dialog_dynamic")
		var chest_sprite = collider.get_node_or_null("AnimatedSprite")
		if chest_sprite:
			chest_sprite.play("open")
	elif collider.is_in_group("NPC"):
		SignalBus.emit_signal("display_dialog", "blacksmith")
		GlobalNode.PlayerHealth = 100 # TODO: Change to MaxHealth
	else:
		print(ray.get_collider())
		print(ray.get_collider().get_groups())
		$FailAudio.play()

func _physics_process(delta):
	if move_triggered == true:
		move_triggered = false
		position += last_vector
		
func _ready():
	var playerNode = get_node("./Area2D")
	playerNode.connect("area_entered", self, "_on_Area2D_area_entered")
	playerNode.connect("area_exited", self, "_on_Area2D_area_exited")

func _on_Area2D_area_entered(area):
	if area.is_in_group("Enemy"):  # Assuming you've added your targets to a group called "specific_type"
		var groups = area.get_groups()
		groups.erase("Enemy")
		SignalBus.emit_signal("display_battle", true, groups[0])
		$EncounterAudio.play()
		area.get_parent().visible = false
		area.set_collision_layer_bit(0, false)
		area.set_collision_mask_bit(0, false)
	elif area.is_in_group("Key"):
		emit_signal("key_acquired")
		$KeyAudio.play()
	elif area.is_in_group("Ladder"):
		$FloorCompleteAudio.play()	

func _on_Area2D_area_exited(area):
	$EncounterAudio.stop()
