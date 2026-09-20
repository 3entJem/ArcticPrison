extends Node2D

@export_group("Animation Settings")
@export var idle_animation_name: String = "idle"

@export_multiline var tutorial_lines: Array[String] = [
	"Heeeyy! You finally woke up! Look the Warden has given you a special opportunity.",
	"All you have to do to get your freedom is to manage the boiler room for a bit. Simple, right?",
	"Not as much as you would think. Ya see, there is a meter you must watch to keep it from going too far into the red. It go into red, we all explode, capice? and it go to far into green we all become icicles.",
	"You have all of these coolants around you. in order from how effective they are you have toothpaste, snowballs, water, and ice buckets.",
	"You do this for however long the Warden wants and you get to leave and see your family. You Ready?"
]

@export var character_reveal_speed: float = 0.03 

var dialogue_index: int = 0
var tutorial_has_started: bool = false
var bubble_shake_timer: float = 0.0

var is_typing: bool = false
var typewriter_timer: float = 0.0
var active_ui_label: Label = null

@onready var anim = find_child("AnimatedSprite2D", true, false)
@onready var speech_bubble = $SpeechBubble
@onready var player_node = get_tree().root.find_child("Player", true, false)
@onready var spawn_timer = get_tree().root.find_child("SpawnTimer", true, false)

func _ready() -> void:
	GlobalSettings.current_difficulty = "Tutorial"
	lock_level_systems(true)
	
	if anim:
		anim.play(idle_animation_name)
	if speech_bubble:
		speech_bubble.visible = true
		
	var sensor = find_child("ProximitySensor", true, false)
	if sensor and sensor is Area2D:
		sensor.body_entered.connect(_on_proximity_sensor_body_entered)
		print("Sensor successfully connected itself directly in code!")

func _process(delta: float) -> void:
	if player_node != null and anim != null:
		var dir = player_node.global_position.x - global_position.x
		anim.flip_h = (dir < 0)
		
	if speech_bubble != null and speech_bubble.visible:
		bubble_shake_timer += delta * 25.0
		speech_bubble.position = Vector2(-150.0, -200.0) + Vector2(sin(bubble_shake_timer) * 3.0, 0.0)
		
		if active_ui_label == null:
			active_ui_label = speech_bubble.get_node_or_null("DialogueLabel")
			
		if is_typing and active_ui_label != null:
			typewriter_timer += delta
			if typewriter_timer >= character_reveal_speed:
				typewriter_timer = 0.0
				active_ui_label.visible_characters += 1
				if active_ui_label.visible_characters >= active_ui_label.text.length():
					is_typing = false
					
		
		if active_ui_label and active_ui_label.text != "":
			var text_size = active_ui_label.get_minimum_size()
			speech_bubble.size.x = max(140.0, text_size.x + 40.0) # Expanded minimum width boundary
			speech_bubble.size.y = max(80.0, text_size.y + 40.0)

func _on_proximity_sensor_body_entered(body: Node2D) -> void:
	if body == player_node and not tutorial_has_started:
		print("Player reached the tutorial NPC boundary line!")
		tutorial_has_started = true
		
		if "has_target" in player_node:
			player_node.has_target = false
			player_node.velocity.x = 0
			
		advance_tutorial_dialogue()

func _input(event: InputEvent) -> void:
	if tutorial_has_started and event is InputEventKey and event.pressed and not event.is_echo():
		if event.keycode == KEY_E:
			if is_typing:
				is_typing = false
				if active_ui_label != null:
					active_ui_label.visible_characters = active_ui_label.text.length()
			else:
				advance_tutorial_dialogue()

func advance_tutorial_dialogue() -> void:
	if active_ui_label == null and speech_bubble != null:
		active_ui_label = speech_bubble.get_node_or_null("DialogueLabel")

	if dialogue_index < tutorial_lines.size():
		if active_ui_label != null:
			var base_sentence = tutorial_lines[dialogue_index]
			active_ui_label.text = base_sentence + "\n\n[Press E to Continue]"
			active_ui_label.visible_characters = 0
			typewriter_timer = 0.0
			is_typing = true
		dialogue_index += 1
	else:
		
		print("Tutorial dialogue complete! Disengaging system safety overrides...")
		
		if active_ui_label != null: active_ui_label.text = ""
		if speech_bubble: speech_bubble.visible = false
		
		
		GlobalSettings.tutorial_is_active = false
		
		
		var spawner = get_tree().root.find_child("ItemSpawner", true, false)
		if spawner:
			var timer = spawner.get_node_or_null("SpawnTimer")
			if timer:
				timer.start()
				print("Spawner Activated by dialogue handshake!")
				
		# 
		var boiler = get_tree().root.find_child("boiler", true, false)
		if boiler:
			boiler.set_process(true) 
			print("Boiler Activated by dialogue handshake!")
				
		set_process_input(false) 

func lock_level_systems(should_lock: bool) -> void:
	var boiler = get_tree().root.find_child("Boiler", true, false)
	if boiler:
		boiler.set_process(!should_lock)
	if spawn_timer:
		if should_lock:
			spawn_timer.stop()
		else:
			var spawner = spawn_timer.get_parent()
			if spawner and spawner.has_method("_on_spawn_timer_timeout"):
				if not spawn_timer.timeout.is_connected(spawner._on_spawn_timer_timeout):
					spawn_timer.timeout.connect(spawner._on_spawn_timer_timeout)
			spawn_timer.start()
