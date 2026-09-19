extends Control

@onready var boiler = get_parent() # Grabs the Boiler script right above it

# Tells Godot: "Yes! You can drop dragged items right here!"
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and data.has("item_node")

# Triggers instantly the exact frame you release the mouse button over the boiler area
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var item_node = data["item_node"]
	var source_slot = data["from_slot"]
	
	print("🎯 NATIVE UI DROP TARGET HIT! Feeding item...")
	
	# Feed the boiler code properties directly
	if boiler.has_method("feed_boiler"):
		boiler.feed_boiler(item_node)
	
	# Clear out the visual panel data slots array memory
	var inv_panel = get_tree().root.find_child("UI", true, false)
	if inv_panel:
		inv_panel.inventory_data[source_slot] = null
		
	# Permanently erase the snowball node from existence
	item_node.queue_free()
