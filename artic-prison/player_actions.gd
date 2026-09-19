extends CharacterBody2D

@export var walk_spd = 200.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var target_position: float = 0.0
var has_target: bool = false
var target_item: Area2D = null

func _ready() -> void:
	target_position = global_position.x

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:

		var clicked_item = checkForClickedItem()
		if clicked_item != null:
			target_item = clicked_item
			target_position = clicked_item.global_position.x
			has_target = true
		else:
			target_item = null
			target_position = get_global_mouse_position().x
			has_target = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	
	if has_target:
		var distance_to_target = target_position - global_position.x
		
		if abs(distance_to_target) < 5.0:
			global_position.x = target_position
			velocity.x = 0
			has_target = false
			
			if target_item != null and is_instance_valid(target_item):
				target_item.collect()
				target_item = null
		else:
			var walk_direction = sign(distance_to_target)
			velocity.x = walk_direction * walk_spd
	else:
		velocity.x = move_toward(velocity.x, 0, walk_spd)
		
	move_and_slide()

func checkForClickedItem() -> Area2D:
	var space_state = get_world_2d().direct_space_state
	var mouse_pos = get_global_mouse_position()
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = true
	query.collide_with_bodies = false
	
	var results = space_state.intersect_point(query)
	
	for result in results:
		var collider = result["collider"]
		if collider.has_method("collect"):
			return collider
			
	return null
