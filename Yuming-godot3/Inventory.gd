extends Node2D

const SlotClass = preload("res://Slot1.gd")
onready var inventory_slots = $GridContainer
onready var potion_prompt = $PotionPromptLabel
var holding_item = null
var selected_item = null

func _ready():
	for inv_slot in inventory_slots.get_children():
		inv_slot.connect("gui_input", self, "slot_gui_input", [inv_slot])
	SignalBus.connect("item_selected", self, "_on_item_selected")
func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if holding_item != null:
				if !slot.item:
					slot.putIntoSlot(holding_item)
					holding_item = null
				else:
					var temp_item = slot.item
					slot.pickFromSlot()
					temp_item.global_position = event.global_position
					slot.putIntoSlot(holding_item)
					holding_item = temp_item
			elif slot.item:
				holding_item = slot.item
				slot.pickFromSlot()
				holding_item.global_position = get_global_mouse_position()
					


func _on_item_selected(item):
	if item.item_type == "potion": # If item_type is a property of item
		selected_item = item # Store the actual item object
		potion_prompt.show()
	else:
		selected_item = null # Deselect if the item is not a potion

func use_potion(item):
	if item and item.item_type == "potion":
		# Implement what happens when a potion is used
		print("Potion used")
		GlobalNode.PlayerHealth = min(GlobalNode.PlayerHealth + 20, GlobalNode.PlayerMaxHealth)
		# Now you would likely want to remove the potion from the inventory
		remove_item_from_inventory(item)
	else:
		print('Invalid item')

func remove_item_from_inventory(item):
	# Implement the logic to remove the item from inventory
	if item and item.get_parent():
		item.get_parent().remove_child(item)
		item.queue_free() # Free the item if it's no longer needed

	
func _input(event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()	
	if event is InputEventKey and event.pressed and event.scancode == KEY_T:
		print("is T") 
		if selected_item and selected_item.item_type == "potion":
			use_potion(selected_item)
			potion_prompt.hide()
			selected_item = null # Deselect the item after use
