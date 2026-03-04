extends Node

signal display_battle(show, enemy_type)
signal display_dialog(text_key)
signal display_dialog_dynamic()
signal update_battle_text(text)
signal player_click_move()
signal regular_enemy_attack()
signal update_battle_text_enemy(text)
signal player_move_complete()
signal update_secondary_text(text)
signal player_health_changed(new_health)
signal enemy_health_changed(new_health)

signal item_selected(item)
signal item_type_changed(new_type)
#signal death_battle_text_enemy(text)

var in_progress = false
var dialogue_key = "player"

func _input(event):
	if event.is_action_pressed("ui_accept") && !in_progress:
		SignalBus.emit_signal("display_dialog", dialogue_key)
