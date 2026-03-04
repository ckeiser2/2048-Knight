extends Control

onready var GlobalNode = $"../../"


func _on_Resume_pressed():
	GlobalNode.pauseMenu()


func _on_Quit_pressed():
	get_tree().quit()
