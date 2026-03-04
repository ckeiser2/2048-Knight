extends StaticBody2D

func _ready():
	var playerNode = get_node("../Player")
	playerNode.connect("key_acquired", self, "_on_key_acquired")

func _on_key_acquired():
	hide()
	$Area2D.remove_from_group("Key")
