extends Camera2D

@export var camera_speed: float = 400.0


@export var left_wall_x: float = 0.0
@export var right_wall_x: float = 1600.0

@onready var player_node = get_tree().root.find_child("Player", true, false)

func _process(delta: float) -> void:
	
	var cam_dir = 0.0
	if Input.is_key_pressed(KEY_D):
		cam_dir += 1.0  
	if Input.is_key_pressed(KEY_A):
		cam_dir -= 1.0  
	
	
	global_position.x += cam_dir * camera_speed * delta

	
	var viewport_width = get_viewport_rect().size.x
	
	
	var min_cam_x = left_wall_x + (viewport_width / 2.0)
	var max_cam_x = right_wall_x - (viewport_width / 2.0)
	global_position.x = clamp(global_position.x, min_cam_x, max_cam_x)

	
	if player_node != null:
		var screen_left_edge = global_position.x - (viewport_width / 2.0)
		var screen_right_edge = global_position.x + (viewport_width / 2.0)
		
		
		var margin = 60.0
		
		
		if player_node.global_position.x < (screen_left_edge + margin):
			
			var safety_target = screen_left_edge + margin + 10.0
			
			if player_node.has_method("catch_up_to_screen"):
				player_node.catch_up_to_screen(safety_target)
				
		
		elif player_node.global_position.x > (screen_right_edge - margin):
			
			var safety_target = screen_right_edge - margin - 10.0
			
			if player_node.has_method("catch_up_to_screen"):
				player_node.catch_up_to_screen(safety_target)
