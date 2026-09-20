extends CanvasLayer


# 🏠 FILE PATH SLOT FOR YOUR MAIN MENU
@export_file("*.tscn") var main_menu_scene_path: String

@onready var ending_video = $EndingVideo
@onready var credits_video = $CreditsVideo
@onready var win_options = $WinOptions

func _ready() -> void:
	# 1. Initialize the layout states on scene load
	if ending_video:
		ending_video.visible = true
		ending_video.play() # Start the victory animation immediately!
		# Connect to its finished signal
		ending_video.finished.connect(_on_ending_video_finished)
		
	if credits_video:
		credits_video.visible = false
		credits_video.finished.connect(_on_credits_video_finished)
		
	if win_options:
		win_options.visible = false

# 🛑 RELAY 1: Triggers the exact frame the ending animation video finishes
func _on_ending_video_finished() -> void:
	print("Ending animation complete. Moving to credits video...")
	
	if ending_video:
		ending_video.visible = false
		
	if credits_video:
		credits_video.visible = true
		credits_video.play() # Start the credit roll video!

# 🛑 RELAY 2: Triggers the exact frame the credits video finishes rolling
func _on_credits_video_finished() -> void:
	print("Credits complete. Revealing text and main menu button...")
	
	if credits_video:
		credits_video.visible = false
		
	if win_options:
		win_options.visible = true # Pop up your text and button container!

# Connected to your MainMenuButton's pressed() signal via the Node panel tab
func _on_main_menu_button_pressed() -> void:
	print("Returning to Title Screen...")
	
	if main_menu_scene_path != "":
		get_tree().change_scene_to_file(main_menu_scene_path)
	else:
		print("⚠️ Note: Drag your primary MainMenu.tscn scene file into this inspector path slot!")
