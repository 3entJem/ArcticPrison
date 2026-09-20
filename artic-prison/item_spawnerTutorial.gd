extends Node2D


@export var snowball_scene: PackedScene
@export var water_scene: PackedScene
@export var ice_bucket_scene: PackedScene
@export var toothpaste_scene: PackedScene


@export var min_spawn_x: float = 100.0
@export var max_spawn_x: float = 3300.0
@export var spawn_y_height: float = 530.0

@onready var spawn_timer = $SpawnTimer

func _ready() -> void:
	if spawn_timer:
		spawn_timer.wait_time = GlobalSettings.get_current_spawn_time()
		spawn_timer.timeout.connect(_on_spawn_timer_timeout)
		
		
		if GlobalSettings.tutorial_is_active:
			spawn_timer.stop() 
			print("Spawner: Tutorial lock detected. Item generation paused.")
		else:
			spawn_timer.start() 
			print("Spawner: Regular match initialized. Generation active!")

func _on_spawn_timer_timeout() -> void:
	
	var selected_scene = pick_random_weighted_item()
	
	if selected_scene == null:
		print(" Spawner Warning: Dropped item skip, check your inspector scene slots!")
		return
		
	
	var fresh_item = selected_scene.instantiate()
	var random_x = randf_range(min_spawn_x, max_spawn_x)
	fresh_item.global_position = Vector2(random_x, spawn_y_height)
	
	get_parent().add_child(fresh_item)
	print(" Weighted Spawner: Spawned a fresh ", fresh_item.item_name, " at X: ", snf(random_x))


func pick_random_weighted_item() -> PackedScene:
	
	var item_pool = [
		{"scene": snowball_scene, "weight": 50},   
		{"scene": water_scene, "weight": 30},      
		{"scene": ice_bucket_scene, "weight": 15}, 
		{"scene": toothpaste_scene, "weight": 5}    
	]
	
	
	var total_weight = 0
	for item in item_pool:
		if item["scene"] != null:
			total_weight += item["weight"]
			
	if total_weight == 0:
		return null
		
	
	var roll = randf_range(0.0, total_weight)
	
	
	var current_sum = 0.0
	for item in item_pool:
		if item["scene"] != null:
			current_sum += item["weight"]
			if roll <= current_sum:
				return item["scene"]
				
	return null

func snf(val: float) -> float:
	return round(val * 10.0) / 10.0
