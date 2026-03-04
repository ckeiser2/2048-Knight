extends ProgressBar

func _ready():
	var foreground_style = StyleBoxFlat.new()
	foreground_style.bg_color = Color(0, 1, 0)  # Green foreground
	foreground_style.border_color = Color(1, 1, 1)  # White border
	foreground_style.border_width_left = 1
	foreground_style.border_width_top = 1
	foreground_style.border_width_right = 1
	foreground_style.border_width_bottom = 1

	var background_style = StyleBoxFlat.new()
	background_style.bg_color = Color(0, 0, 0, 0.5)  # Semi-transparent black background
	background_style.border_color = Color(1, 1, 1)  # White border
	background_style.border_width_left = 1
	background_style.border_width_top = 1
	background_style.border_width_right = 1
	background_style.border_width_bottom = 1

	
	add_stylebox_override("fg", foreground_style)
	add_stylebox_override("bg", background_style)

	
	self.connect("value_changed", self, "_on_value_changed")

	
	value = GlobalNode.PlayerHealth

func _on_value_changed(_value):
	update()

func _draw():
	var progress_text = str(GlobalNode.PlayerHealth)
	var font_color = Color(1, 1, 1)  # White font color
	var font = get_font("font")
	var text_size = font.get_string_size(progress_text)


	var scale_factor = 1.5
	var text_position = Vector2(
		(get_size().x - text_size.x * scale_factor) / 2,
		(get_size().y - text_size.y * scale_factor) / 2 + font.get_ascent() * scale_factor)
	
	var transform = Transform2D().scaled(Vector2(scale_factor, scale_factor))
	transform.origin = text_position  
	draw_set_transform_matrix(transform)
	draw_string(font, Vector2(), progress_text, font_color)  
	draw_set_transform_matrix(Transform2D())  

	
func get_progress_color(value):
	return Color(1, 0, 0) if value < 20 else Color(0, 1, 0)
