extends Area2D

@export var item_name: String = "Snowball"
@export var item_texture: Texture2D
func collect():
	var inventory = get_tree().root.find_child("UI", true, false)
	
	
	if inventory:
		var success = inventory.add_item(item_texture, item_name)
		if success:
			print("Item picked up!")
			queue_free()
