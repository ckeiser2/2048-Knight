extends Area2D

export var dialogue_key = "player"
var area_active = false

func _input(event):
	pass
#	if area_active and event.is_action_pressed("ui_accept"):
#		SignalBus.emit_signal("display_dialog", dialogue_key)

func _on_DialogueArea_area_entered(area):
	area_active = true

func _on_DialogueArea_area_exited(area):
	area_active = false
