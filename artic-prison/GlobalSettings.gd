extends Node

var current_difficulty: String = "Normal"
var active_level_scene_path: String = ""
var tutorial_is_active: bool = false


var loss_reason_type: String = "Hot"

var presets = {
	"Tutorial": { "heat_rate": 1.0, "spawn_time": 5.0 },
	"Normal":   { "heat_rate": 2.0, "spawn_time": 4.0 },
	"Hard":     { "heat_rate": 5.0, "spawn_time": 2.5 }
}

func get_current_heat_rate() -> float:
	return presets[current_difficulty]["heat_rate"]

func get_current_spawn_time() -> float:
	return presets[current_difficulty]["spawn_time"]
