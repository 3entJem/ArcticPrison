extends TextureRect

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and data.has("from_slot")
	
	var inv_panel = get_tree().root.find_child("UI", true, false)
	
	
