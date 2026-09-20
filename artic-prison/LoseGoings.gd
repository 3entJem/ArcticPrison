extends CanvasLayer




@export_file("*.tscn") var main_level_scene_path: String
@export_file("*.tscn") var tutorial_level_scene_path: String
@export_file("*.tscn") var main_menu_scene_path: String


func _on_try_again_button_pressed() -> void:
	print("Try Again clicked! Checking difficulty memory slot...")
	
	
	var failed_mode = GlobalSettings.current_difficulty
	
	if failed_mode == "Tutorial":
		if tutorial_level_scene_path != "":
			get_tree().change_scene_to_file(tutorial_level_scene_path)
		else:
			print("Note: Drag your Tutorial level scene into the Lose Screen's inspector slot!")
	else:
		
		if main_level_scene_path != "":
			print("Reloading main core map file on mode preset: ", failed_mode)
			get_tree().change_scene_to_file(main_level_scene_path)
		else:
			print("Note: Drag your Main Game level scene into the Lose Screen's inspector slot!")


func _on_main_menu_button_pressed() -> void:
	print("Returning to Title Screen...")
	if main_menu_scene_path != "":
		get_tree().change_scene_to_file(main_menu_scene_path)
