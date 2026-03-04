extends ProgressBar


var max_health = GlobalNode.EnemyMaxHealth

func _ready():

	var foreground_style = StyleBoxFlat.new()
	foreground_style.bg_color = Color(1, 0, 0)  
	foreground_style.border_color = Color(1, 1, 1)  
	foreground_style.border_width_left = 1
	foreground_style.border_width_top = 1
	foreground_style.border_width_right = 1
	foreground_style.border_width_bottom = 1

	var background_style = StyleBoxFlat.new()
	background_style.bg_color = Color(0, 0, 0, 0.5)  
	background_style.border_color = Color(1, 1, 1)  
	background_style.border_width_left = 1
	background_style.border_width_top = 1
	background_style.border_width_right = 1
	background_style.border_width_bottom = 1

	
	add_stylebox_override("fg", foreground_style)
	add_stylebox_override("bg", background_style)


	self.max_value = 100  
	update_health_bar(GlobalNode.EnemyHealth)


func update_health_bar(current_health):
	var health_percentage = current_health / max_health * self.max_value
	self.value = health_percentage


func _on_enemy_health_changed(new_health):
	update_health_bar(new_health)


func _draw():
	var progress_text = str(int(self.value)) 
	var font_color = Color(1, 1, 1)  #
	var font = get_font("font")  
	var text_size = font.get_string_size(progress_text)


	var text_position = Vector2(
		(get_size().x - text_size.x) / 2,
		(get_size().y + font.get_ascent()) / 2
	)

	
	draw_string(font, text_position, progress_text, font_color)
