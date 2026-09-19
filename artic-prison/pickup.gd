extends Area2D

@export var item_name: String = "Snowball"
@export var cooldown_value: float = 5.0

func _ready() -> void:
	# Connect the invisible drag surface to handle mouse clicks once inside the inventory
	if has_node("DragSurface"):
		$DragSurface.gui_input.connect(_on_drag_surface_input)
		$DragSurface.mouse_filter = Control.MOUSE_FILTER_IGNORE
func collect():
	var inventory = get_tree().root.find_child("UI", true, false)
	
	if inventory:
		# Disable physics immediately so the bot stops grabbing it
		monitoring = false
		monitorable = false
		$CollisionShape2D.disabled = true
		
		
		var success = inventory.teleport_item_to_slot(self)
		if success:
			print(item_name, " successfully teleported to inventory UI!")
			# Turn ON the drag surface only when it enters the inventory bag
			$DragSurface.mouse_filter = Control.MOUSE_FILTER_STOP
		else:
			# If bag is full, turn physics back on
			$CollisionShape2D.disabled = false
			monitoring = true
			monitorable = true
	else:
		print("CRITICAL: Could not find the UI node!")

# 🛑 THE DRAG LOGIC HANDLED BY THE SNOWBALL ITSELF
func _on_drag_surface_input(event: InputEvent) -> void:
	# Detect when the player drags the mouse on the snowball
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var slot_index = get_parent().get_index() # Figure out which slot number we are sitting inside
		
		# Create the visual drag icon floating under the cursor
		var preview = TextureRect.new()
		if has_node("Sprite2D"):
			preview.texture = $Sprite2D.texture
			
		preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		preview.custom_minimum_size = Vector2(40, 40)
		preview.position = Vector2(10, 10) # Offset so it doesn't block the cursor point
		
		# Force Godot to start a global UI drag action using this snowball node
		$DragSurface.force_drag({"from_slot": slot_index, "item_node": self}, preview)
