extends Node2D

var dialogue_key = "player"

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(2.0), "timeout")
#	SignalBus.emit_signal("display_dialog", dialogue_key)
#	yield(get_tree().create_timer(2.0), "timeout")
#	get_tree().change_scene("res://Room2.tscn")
