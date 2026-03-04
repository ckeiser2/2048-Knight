extends Node2D


func _ready():
	SignalBus.connect("switch_to_battle_scene", self, "on_switch_to_battle_scene")
#	yield(get_tree().create_timer(2.0), "timeout")
#	get_tree().change_scene("res://Room2.tscn")
	
func on_switch_to_battle_scene(enemy_type):
	print("switch to battle scene")
	print(enemy_type)
	get_tree().change_scene("res://MainBattleNode.tscn")
#	SignalBus.emit_signal("display_battle", true, enemy_type)
