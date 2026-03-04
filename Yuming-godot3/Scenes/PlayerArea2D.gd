extends Area2D

func _ready():
	# Connect the area_entered signal to a function that handles the collision
	connect("body_entered", self, "_on_Area2D_area_entered")

func _on_Area2D_body_entered(body):
	# Check if the area (or its parent, depending on your setup) is the specific type you're looking for
	print("something happened...")
	if body.is_in_group("specific_type"):  # Assuming you've added your targets to a group called "specific_type"
		print("Collision detected with specific type!")
