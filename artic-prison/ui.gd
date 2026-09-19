extends Control

@onready var slots = [$HBoxContainer/Slot1, $HBoxContainer/Slot2, $HBoxContainer/Slot3]
var inventory_data = [ null, null, null]

func add_item(item_texture: Texture2D, item_name: String) -> bool:
	for i in range(3):
		if inventory_data[i] == null:
			inventory_data[i] = {"name": item_name, "texture": item_texture}
			
			slots[i].texture = item_texture
			return true
			
	print("Inventory full!")
	return false
