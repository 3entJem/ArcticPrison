extends TextureRect

func _get_drag_data(_at_position: Vector2) -> Variant:
	var slot_index = get_index()
	var inv_panel = get_parent().get_parent()
	
	var item_data = inv_panel.inventory_data[slot_index]
	if item_data == null:
		return null
		
	var preview = TextureRect.new()
	preview.texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.custom_minimum_size = Vector2(40,40)
	set_drag_preview(preview)
	
	return {"from_slot": slot_index, "item_name": item_data["name"]}
