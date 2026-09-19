extends Control

@onready var slots = [$HBoxContainer/Slot1, $HBoxContainer/Slot2, $HBoxContainer/Slot3]
var inventory_data = [null, null, null]

func teleport_item_to_slot(item_node: Node2D) -> bool:
	for i in range(3):
		if inventory_data[i] == null:
			# 1. Store the reference data
			inventory_data[i] = {"name": item_node.item_name, "node": item_node}
			
			# 2. Detach the item from the 2D level map layout
			item_node.get_parent().remove_child(item_node)
			
			# 3. Attach the item as a child of your UI Slot node!
			slots[i].add_child(item_node)
			
			# 4. Center the physical 2D sprite directly inside the UI slot visual boundaries
			item_node.position = slots[i].size / 2
			
			return true
			
	print("Inventory full!")
	return false

# Keep your original add_item function below just in case you need it later
func add_item(item_texture: Texture2D, item_name: String) -> bool:
	for i in range(3):
		if inventory_data[i] == null:
			inventory_data[i] = {"name": item_name, "texture": item_texture}
			slots[i].texture = item_texture
			return true
	return false
