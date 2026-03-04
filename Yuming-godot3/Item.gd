extends Node2D

var item_type = "none" # Possible values: "none", "potion", "weapon", etc.

func _ready():
	if randi() % 2 == 0:
		$TextureRect.texture = load("res://Slime Potion.png")
		item_type = "potion"
	else:
		$TextureRect.texture = load("res://Tree Branch.png")
		item_type = "treeBranch"
	SignalBus.emit_signal("item_type_changed", item_type)

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT: 
		SignalBus.emit_signal("item_selected", self)
