extends Node2D

@export_group("Animation Settings")
@export var idle_animation_name: String = "idle"


@onready var anim = find_child("AnimatedSprite2D", true, false)
@onready var player_node = get_tree().root.find_child("Player", true, false)

func _ready() -> void:
	
	if anim and anim.sprite_frames.has_animation(idle_animation_name):
		anim.play(idle_animation_name)
	elif anim == null:
		print("NPC Warning: ", name, " could not automatically locate an AnimatedSprite2D child node container!")

func _process(_delta: float) -> void:
	
	if player_node != null and anim != null:
		var direction_to_player = player_node.global_position.x - global_position.x
		
		if direction_to_player < 0:
			anim.flip_h = true   
		elif direction_to_player > 0:
			anim.flip_h = false  
