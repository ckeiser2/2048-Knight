extends CanvasLayer

export (String, FILE, "*json") var scene_text_file

var scene_text = {}
var selected_text = []

onready var background = $Background
onready var text_label = $MainBattleLabel
onready var white_outline = $WhiteOutline
onready var animation_player = get_node("MainBattleLabel/AnimationPlayer")

func _ready():
	background.visible = false
	white_outline.visible = false
	scene_text = load_scene_text()
	SignalBus.connect("display_dialog", self, "on_display_dialog")
	SignalBus.connect("display_dialog_dynamic", self, "on_display_dialog_dynamic")

func load_scene_text():
	var file = File.new()
	if file.file_exists(scene_text_file):
		file.open(scene_text_file, File.READ)
		return parse_json(file.get_as_text())

func show_text():
	text_label.text = selected_text.pop_front()
	animation_player.play("AnimateText")
	print(text_label.text)

func next_line():
	if selected_text.size() > 0:
		print('next_line')
		show_text()
	else:
		finish()

func finish():
	print("finished")
	text_label.text = ""
	background.visible = false
	white_outline.visible = false
	get_tree().paused = false
	yield(get_tree().create_timer(1.0), "timeout")
	SignalBus.in_progress = false

func on_display_dialog(text_key):
	show()
	if SignalBus.in_progress:
		print("in_progress")
		next_line()
	else:
		get_tree().paused = true
		background.visible = true
		white_outline.visible = true
		SignalBus.in_progress = true
		if text_key != "ignore":
			print("ignored")
			selected_text = scene_text[text_key].duplicate()
			show_text()
		else:
			print("not ignored")
		
func on_display_dialog_dynamic():
	print("called display dialog dynamic")
	var items = ["green orb", "red stone", "blue jewel"]
	var item = "You have acquired a " + items[(randi() % 3) - 1] + "!"
	selected_text = [item, "One", "Two", "Three", "Four", "Five", "Six"]
	show()
	SignalBus.in_progress = true
	get_tree().paused = true
	background.visible = true
	white_outline.visible = true
	SignalBus.in_progress = true
	SignalBus.emit_signal("display_dialog", "ignore")
#	else:
	
	
