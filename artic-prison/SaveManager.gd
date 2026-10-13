extends Node

# The file path where Godot will save the settings file on the player's device
const SAVE_PATH = "user://settings.cfg"

# Default values if no save file exists yet
var music_volume: float = 0.5
var camera_speed: float = 400.0
var master_volume: float = 0.5

func _ready() -> void:
	load_settings()

func save_settings() -> void:
	var config = ConfigFile.new()
	
	# Store the current values in the config object
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("camera", "camera_speed", camera_speed)
	config.set_value("audio", "master_volume", master_volume)
	# Save the file to disk
	config.save(SAVE_PATH)

func load_settings() -> void:
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)
	
	# If the file loads successfully, grab the saved values
	if error == OK:
		music_volume = config.get_value("audio", "music_volume", music_volume)
		camera_speed = config.get_value("camera", "camera_speed", camera_speed)
		master_volume = config.get_value("audio", "master_volume", master_volume)
		
	# Immediately apply the loaded music volume to the AudioServer
	apply_music_volume(music_volume)

func apply_music_volume(linear_value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Music")
	if bus_index != -1: # Ensures the "Music" bus actually exists
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear_value))

func apply_master_volume(linear_value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	if bus_index != -1: # Ensures the "Master" bus actually exists
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear_value))
