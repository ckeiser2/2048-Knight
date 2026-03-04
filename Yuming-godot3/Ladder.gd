extends StaticBody2D

func _ready():
	hide()
	var playerNode = get_node("../Player")
	playerNode.connect("key_acquired", self, "_on_key_acquired")
 
func _on_key_acquired():
	show()
	$Area2D.monitoring = true 
	$Area2D.monitorable = true
