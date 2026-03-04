extends CanvasLayer

onready var text_label = $MainBattleLabel
onready var animation_player = get_node("MainBattleLabel/AnimationPlayer")
onready var text_label2 = $SecondaryLabel
onready var animation_player2 = get_node("SecondaryLabel/AnimationPlayer")
var in_progress = false
var is_player_turn = false
var enemy_death = false

func _ready():
	hide()
	SignalBus.connect("display_battle", self, "on_display_battle")
	SignalBus.connect("update_battle_text", self, "_on_update_battle_text")
	SignalBus.connect("update_battle_text_enemy", self, "_on_update_battle_text_enemy")
	SignalBus.connect("update_secondary_text", self, "on_update_secondary_text")
	
func on_display_battle(show, enemy_type):
	if show:
		show()
		enemy_death = false
		is_player_turn = false
		GlobalNode.player_recharge = false
		GlobalNode.battle_button_lock = false
		var text = "You have encountered a " + enemy_type + "!"
		text_label.text = text
		animation_player.play("AnimateText")
	else:
		GlobalNode.battle_button_lock = true
		GlobalNode.battle_text_queue.clear()
		in_progress = false
		hide()
		
func show_text():
	var text = GlobalNode.battle_text_queue.pop_front()
	print(text)
	text_label.text = text
	animation_player.play("AnimateText")
	
func finish():
	if (is_player_turn):
		SignalBus.emit_signal("player_move_complete")
	else:
		GlobalNode.battle_button_lock = false
	in_progress = false
		
func next_line():
	if GlobalNode.battle_text_queue.size() == 1:
		show_text()
		finish()
	if GlobalNode.battle_text_queue.size() > 0:
		show_text()
#		yield(get_tree().create_timer(2), "timeout")
#		next_line()
	else:
		finish()
		
func _on_update_battle_text(text):
	in_progress = true
	GlobalNode.battle_text_queue.push_back(text)
	if (!is_player_turn):
		is_player_turn = true
		next_line()
	else:
		is_player_turn = true
	
func _on_update_battle_text_enemy(text):
	text_label2.text = ""
	in_progress = true
	GlobalNode.battle_text_queue.push_back(text)
	if (is_player_turn):
		is_player_turn = false
		next_line()
	else:
		is_player_turn = false
	
func on_update_secondary_text(text):
	text_label2.text = text
	animation_player2.play("AnimateText")
