extends Control


@export_file("*.tscn") var main_menu_scene_path: String


@onready var win_options = $WinOptions
@onready var ending_container = $Ending
@onready var credits_container = $Credits
@onready var credits_sound: AudioStreamPlayer2D = $Credits/CreditsSound
@onready var is_tutorial_mode: bool = false

@onready var ending_audio = $Ending/AudioStreamPlayer2D



func _ready() -> void:
	#var previous_scene = GlobalSettings.active_level_scene_path
	if GlobalSettings.current_difficulty == "Tutorial":
		print("recognized as tutorial")
		%WinOptions.visible = true
		%Credits.visible = false
		ending_audio.stop()
		$Credits/CreditsSound.stop()
		
		$"../ArticPrisionWinVideoSpriteSheet".visible = false
	else:
		print("recognized as NOT tutorial")
		if ending_container: ending_container.visible = true

		if ending_audio: ending_audio.play()
	
	


#func _on_ending_scene_animation_finished() -> void:
	#print("Ending animation complete. Moving to credits sequence...")
	
	
	#if ending_container: ending_container.visible = false
	#if ending_audio: ending_audio.stop()
	
	
	#if credits_container: credits_container.visible = true
	#if credits_sprite: credits_sprite.play("default") 
	#if credits_sound: credits_sound.play()


func _on_creditsanim_animation_finished() -> void:
	print("Credits complete. Revealing menu options text and buttons...")
	
	
	if credits_container: credits_container.visible = false
	if credits_sound: credits_sound.stop()
	
	
	%WinOptions.visible = true


func _on_main_menu_button_pressed() -> void:
	print("Returning to Title Screen...")
	if main_menu_scene_path != "":
		get_tree().change_scene_to_file(main_menu_scene_path)
	else:
		print(" Note: Drag your primary MainMenu.tscn scene file into this script's path box!")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "animation":
		$"../ArticPrisionWinVideoSpriteSheet".hide()
		
		$Credits/CreditsSound.play()
		%Creditsanim.play("default")
		
