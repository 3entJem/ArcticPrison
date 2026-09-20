extends CanvasLayer


@export_group("Scene Transitions")
@export_file("*.tscn") var main_level_scene_path: String
@export_file("*.tscn") var tutorial_level_scene_path: String
@export_file("*.tscn") var main_menu_scene_path: String

@export_group("Hot Ending Assets")
@export var hot_audio_stream: AudioStream

@export_group("Cold Ending Assets")
@export var cold_audio_stream: AudioStream


@onready var hot_sprite: Sprite2D = $Hot
@onready var cold_sprite: Sprite2D = $Cold
@onready var ending_audio: AudioStreamPlayer = $EndingAudio

func _ready() -> void:
	
	var fail_type = GlobalSettings.loss_reason_type
	print("Lose Scene initialized. Loading assets for fail type: ", fail_type)
	
	
	if fail_type == "Hot":
		if hot_sprite: hot_sprite.visible = true
		if cold_sprite: cold_sprite.visible = false
		
		if ending_audio and hot_audio_stream:
			ending_audio.stream = hot_audio_stream
			ending_audio.play()
	else: 
		if hot_sprite: hot_sprite.visible = false
		if cold_sprite: cold_sprite.visible = true
		
		if ending_audio and cold_audio_stream:
			ending_audio.stream = cold_audio_stream
			ending_audio.play()

# 

func _on_try_again_button_pressed() -> void:
	if ending_audio: ending_audio.stop()

	var failed_mode = GlobalSettings.current_difficulty
	if failed_mode == "Tutorial":
		if tutorial_level_scene_path != "":
			get_tree().change_scene_to_file(tutorial_level_scene_path)
	else:
		if main_level_scene_path != "../../": 
			get_tree().change_scene_to_file(main_level_scene_path)

func _on_main_menu_button_pressed() -> void:
	if ending_audio: ending_audio.stop()
	
	if main_menu_scene_path != "":
		get_tree().change_scene_to_file(main_menu_scene_path)
