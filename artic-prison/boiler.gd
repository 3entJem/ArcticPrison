extends StaticBody2D 

@export var temperature: float = 20.0     
@export var max_temperature: float = 100.0 
@export var heat_rate: float = 0.5        


@onready var temp_bar = $TempBar

var game_over: bool = false

func _ready() -> void:
	
	if temp_bar:
		temp_bar.min_value = 0.0
		temp_bar.max_value = max_temperature
		temp_bar.value = temperature

func _process(delta: float) -> void:
	if game_over:
		return
		
	
	temperature += heat_rate * delta
	
	
	if temp_bar:
		temp_bar.value = temperature
	
	
	if temperature >= max_temperature:
		trigger_explosion()


func feed_boiler(item_node: Node2D) -> void:
	if game_over:
		return
		
	if "cooldown_value" in item_node:
		var cooling = item_node.cooldown_value
		temperature = max(0.0, temperature - cooling) 
		

		if temp_bar:
			temp_bar.value = temperature
			
		print("❄️ Cooled down the boiler by ", cooling, " degrees! Current temp: ", snp_temp(temperature))
	else:
		print("Fed the boiler something, but it didn't have a cooldown value property.")

func trigger_explosion() -> void:
	game_over = true
	temperature = max_temperature
	if temp_bar:
		temp_bar.value = max_temperature
	print("💥 BOOM!!! The boiler overheated and exploded! Game Over!")


func snp_temp(val: float) -> String:
	return str(snof(val))

func snof(val: float) -> float:
	return snap_to(val, 0.1)

func snap_to(val: float, step: float) -> float:
	return round(val / step) * step
