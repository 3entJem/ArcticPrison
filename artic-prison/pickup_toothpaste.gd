extends Area2D

@export var item_name: String = "Toothpaste"

func collect():
	# 1. Find the UI node
	var inventory = get_tree().root.find_child("UI", true, false)
	
	if inventory:
		# 2. Disable collisions immediately so the bot doesn't try to grab it again
		monitoring = false
		monitorable = false
		$CollisionShape2D.disabled = true
		
		# 3. Hand this entire object over to the inventory
		var success = inventory.teleport_item_to_slot(self)
		
		if success:
			print(item_name, " successfully teleported to inventory UI!")
			# 🛑 WE NO LONGER CALL queue_free() HERE! The item stays alive inside the UI.
		else:
			print("Inventory full, leaving item on ground.")
			$CollisionShape2D.disabled = false
			monitoring = true
			monitorable = true
	else:
		print("CRITICAL: Could not find the UI node!")
