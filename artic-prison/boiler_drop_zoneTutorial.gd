extends Control

@export_file("*.tscn") var main_menu_scene_path: String


@onready var win_options = $WinOptions
@onready var ending_container = $Ending
@onready var credits_container = $Credits

@onready var ending_sprite = $Ending/EndingScene
@onready var credits_sprite = $Credits/Creditsanim

@onready var ending_audio = $Ending/AudioStreamPlayer2D
@onready var credits_audio = $Credits/AudioStreamPlayer2D

func _ready() -> void:
	print("Win Scene Initialized. Setting up layout tracks...")

	
	if win_options: win_options.visible = false
	if credits_container: credits_container.visible = false
	
	
	if ending_sprite:
		if ending_sprite.animation_finished.is_connected(_on_ending_scene_animation_finished):
			ending_sprite.animation_finished.disconnect(_on_ending_scene_animation_finished)
		ending_sprite.animation_finished.connect(_on_ending_scene_animation_finished)
		
	if credits_sprite:
		if credits_sprite.animation_finished.is_connected(_on_creditsanim_animation_finished):
			credits_sprite.animation_finished.disconnect(_on_creditsanim_animation_finished)
		credits_sprite.animation_finished.connect(_on_creditsanim_animation_finished)

	
	if ending_container: ending_container.visible = true
	if ending_audio: ending_audio.play()
	if ending_sprite:
		ending_sprite.frame = 0
		ending_sprite.play()

	
	await get_tree().create_timer(3.0).timeout 
	_on_ending_scene_animation_finished()      


func _on_ending_scene_animation_finished() -> void:
	
	if credits_container and credits_container.visible:
		return
		
	print("Sequence Gate: Transitioning directly to credits container...")
	
	
	if ending_sprite: ending_sprite.stop()
	if ending_audio: ending_audio.stop()
	if ending_container: ending_container.visible = false
	
	
	if credits_container: credits_container.visible = true
	if credits_audio: credits_audio.play()
	if credits_sprite:
		credits_sprite.frame = 0
		credits_sprite.play()


func _on_creditsanim_animation_finished() -> void:
	print("🎯 Sequence Gate: Revealing final win text menu...")
	
	if credits_sprite: credits_sprite.stop()
	if credits_audio: credits_audio.stop()
	if credits_container: credits_container.visible = false
	
	
	if win_options: win_options.visible = true


func _on_main_menu_button_pressed() -> void:
	print("Returning to Title Screen...")
	if main_menu_scene_path != "":
		get_tree().change_scene_to_file(main_menu_scene_path)
