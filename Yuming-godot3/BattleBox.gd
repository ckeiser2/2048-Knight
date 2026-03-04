extends CanvasLayer

func _ready():
	hide()
	SignalBus.connect("display_battle", self, "on_display_battle")

func on_display_battle(show, enemy_type):
	if show:
		show()
		get_tree().paused = true
	else:
		hide()
		get_tree().paused = false
