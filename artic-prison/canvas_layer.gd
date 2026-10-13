extends CanvasLayer



@export_file("*.tscn") var tutorial_level_path: String
@export_file("*.tscn") var main_level_path: String 

@onready var logo_sprite = $LogoSprite
@onready var main_options = $MainOptions
@onready var difficulty_options = $DifficultyOptions
var camera_speed: float = 400.0

func _ready() -> void:
	if logo_sprite: logo_sprite.visible = true
	if main_options: main_options.visible = true
	if difficulty_options: difficulty_options.visible = false
	#$OptionsOptions/MasterSlider.value = SaveManager.master_volume
	#$OptionsOptions/MusicSlider.value = SaveManager.music_volume
	
	#$OptionsOptions/CameraSlider.value = SaveManager.camera_speed
	
func _on_music_slider_changed(value: float) -> void:
	SaveManager.music_volume = value
	SaveManager.apply_music_volume(value)
	
	SaveManager.save_settings()
	
func _on_master_slider_changed(value: float) -> void:
	SaveManager.master_volume = value
	SaveManager.apply_master_volume(value)
	
	SaveManager.save_settings()
	
func _on_camera_slider_changed(value: float) -> void:
	SaveManager.camera_speed = value
	
	SaveManager.save_settings()
	
func _on_new_game_button_pressed() -> void:
	print("New Game clicked! Flipping global settings to Tutorial ignition lock...")
	
	
	GlobalSettings.current_difficulty = "Tutorial" 
	GlobalSettings.tutorial_is_active = true
	
	if tutorial_level_path != "":
		get_tree().change_scene_to_file(tutorial_level_path)

func _on_levels_button_pressed() -> void:
	if logo_sprite: logo_sprite.visible = false
	if main_options: main_options.visible = false
	if difficulty_options: difficulty_options.visible = true

func _on_options_button_pressed() -> void:
	if logo_sprite: logo_sprite.visible = false
	if main_options: main_options.visible = false
	$OptionsOptions.visible = true
	$OptionsOptions/MasterSlider.value = SaveManager.master_volume
	$OptionsOptions/MusicSlider.value = SaveManager.music_volume
	
	$OptionsOptions/CameraSlider.value = SaveManager.camera_speed
	
func _on_options_back_button_pressed() -> void:
	if logo_sprite: logo_sprite.visible = true
	if main_options: main_options.visible = true
	$OptionsOptions.visible = false
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_back_button_pressed() -> void:
	if difficulty_options: difficulty_options.visible = false
	if logo_sprite: logo_sprite.visible = true
	if main_options: main_options.visible = true


func _on_tutorial_button_pressed() -> void:
	GlobalSettings.current_difficulty = "Tutorial" 
	if tutorial_level_path != "":
		get_tree().change_scene_to_file(tutorial_level_path)

func _on_normal_button_pressed() -> void:
	GlobalSettings.current_difficulty = "Normal"   
	load_main_game()

func _on_hard_button_pressed() -> void:
	GlobalSettings.current_difficulty = "Hard"     
	load_main_game()


func load_main_game() -> void:
	if main_level_path != "":
		get_tree().change_scene_to_file(main_level_path)
	else:
		print("Note: Drag your main core level .tscn file into the MainMenu's Main Level Path box!")
