extends Control 

@onready var boiler = get_parent()

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and data.has("item_node")

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var item_node = data["item_node"]
	
	print("🎯 NATIVE UI DROP TARGET HIT! Feeding item: ", item_node.name)
	
	
	if boiler.has_method("feed_boiler"):
		boiler.feed_boiler(item_node)
	
	
	var inv_panel = find_inventory_panel(get_tree().root)
	
	if inv_panel != null:
		var cleared_successfully = false
		
		
		for i in range(inv_panel.inventory_data.size()):
			var slot_entry = inv_panel.inventory_data[i]
			if slot_entry != null and slot_entry.has("node") and slot_entry["node"] == item_node:
				inv_panel.inventory_data[i] = null # 🛑 CLEAR IT CLEANLY!
				print("Successfully matched and cleared inventory data array slot: ", i)
				cleared_successfully = true
				break
				
		if not cleared_successfully:
			print("⚠️ Warning: Could not find this item node instance inside inventory_data array slots.")
	else:
		print("❌ CRITICAL ERROR: BoilerDropZone could not locate the inventory array node!")


	item_node.queue_free()


func find_inventory_panel(current_node: Node) -> Node:
	if "inventory_data" in current_node:
		return current_node
	for child in current_node.get_children():
		var found = find_inventory_panel(child)
		if found != null:
			return found
	return null
