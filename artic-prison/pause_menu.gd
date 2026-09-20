extends Node2D


@export_file("*.tscn") var main_menu_scene_path: String

@onready var play_button = $PlayButton
@onready var main_menu_button = $MainMenuButton

func _ready() -> void:
	
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("ui_cancel") or (event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE):
		if not get_tree().paused:
			pause_game()
		else:
			unpause_game()


func _on_pause_button_pressed() -> void:
	pause_game()


func _on_play_button_pressed() -> void:
	unpause_game()


func _on_main_menu_button_pressed() -> void:
	
	get_tree().paused = false
	
	if main_menu_scene_path != "":
		get_tree().change_scene_to_file(main_menu_scene_path)
	else:
		print("⚠Note: Drag your MainMenu.tscn file into the PauseMenu's inspector path slot!")

func pause_game() -> void:
	get_tree().paused = true
	visible = true 

func unpause_game() -> void:
	get_tree().paused = false
	visible = false 
