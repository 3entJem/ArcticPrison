extends StaticBody2D 

@export var temperature: float = 20.0     
@export var max_temperature: float = 100.0 
@export var heat_rate: float = 2.0        


@export var survival_time_seconds: float = 180.0 
var time_left: float = 0.0

@export_file("*.tscn") var win_scene_path: String
@export_file("*.tscn") var lose_scene_path: String


@onready var temp_bar = $TempBar


@onready var gauge_sprite = get_tree().root.find_child("GaugeSprite", true, false)


@onready var time_label = get_tree().root.find_child("TimeLabel", true, false)

var game_over: bool = false
var level_won: bool = false

func _ready() -> void:
	GlobalSettings.active_level_scene_path = scene_file_path
	heat_rate = GlobalSettings.get_current_heat_rate()
	time_left = survival_time_seconds
	
	if temp_bar:
		temp_bar.min_value = 0.0
		temp_bar.max_value = max_temperature
		temp_bar.value = temperature
	update_gauge_frame()
	
	
	if GlobalSettings.current_difficulty == "Tutorial" or GlobalSettings.tutorial_is_active:
		set_process(false)
		print("Boiler Security Valve: Tutorial mode detected. Processing frozen at setup.")

func _process(delta: float) -> void:
	if game_over:
		return
		
	
	if GlobalSettings.tutorial_is_active:
		return 
		
	
	temperature += heat_rate * delta
	if temp_bar:
		temp_bar.value = temperature 
	update_gauge_frame()             
	
	time_left -= delta
	var minutes = int(max(0.0, time_left)) / 60
	var seconds = int(max(0.0, time_left)) % 60
	if time_label:
		time_label.text = "%02d:%02d" % [minutes, seconds]
	
	if temperature >= max_temperature: trigger_loss("💥 Overheated!")
	elif temperature <= 0.0: trigger_loss("Frozen Over!")
	elif time_left <= 0.0: trigger_win()

func feed_boiler(item_node: Node2D) -> void:
	if game_over or level_won:
		return
		
	if "cooldown_value" in item_node:
		var cooling = item_node.cooldown_value
		temperature -= cooling 
		
		if temp_bar:
			temp_bar.value = temperature
		update_gauge_frame()
		
		print("❄️ Cooled down boiler by ", cooling, " degrees!")


func update_gauge_frame() -> void:
	if gauge_sprite != null and "frame" in gauge_sprite:
		var frame_ratio = (temperature / max_temperature) * 10.0
		var target_frame = clamp(int(frame_ratio), 0, 10)
		gauge_sprite.frame = target_frame


func trigger_loss(reason: String) -> void:
	game_over = true
	print(reason, " Game Over!")
	
	
	if "Overheated" in reason or "" in reason:
		GlobalSettings.loss_reason_type = "Hot"
	elif "Frozen" in reason or "" in reason:
		GlobalSettings.loss_reason_type = "Cold"
	
	if lose_scene_path != "":
		get_tree().change_scene_to_file(lose_scene_path)


func trigger_win() -> void:
	level_won = true
	print("Victory! Level Completed Stabilized!")
	
	if win_scene_path != "":
		get_tree().change_scene_to_file(win_scene_path)
	else:
		print("Note: Drag your Win.tscn file into the Boiler's inspector slot to load it here!")
