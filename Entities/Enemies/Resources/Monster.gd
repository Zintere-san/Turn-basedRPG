extends BaseCharacter

@export_range (1, 5, 1) var current_position : int

#func _ready() -> void:
	#print("I will take ", calculate_damage(20, "p", "neutral", 0), " damage")
	##print(get_attack(character.moves).ID) this gets a random atk
	#pass

func take_turn():
	get_attack(character.moves)

func get_attack(weights : Dictionary) -> Attack:
	var total_weight  = 0
	var cumulative_weight = 0
	
	for weight in weights.values():
		total_weight += weight
	
	var random_number = randi_range(0, total_weight - 1)
	
	for item in weights.keys():
		cumulative_weight += weights[item]
		if random_number < cumulative_weight:
			return item
	return
	
func die():
	var mat = $Sprite.material
	if not mat is ShaderMaterial:
		return
	var tween := create_tween()
	tween.tween_method(func(val): mat.set_shader_parameter("pixelate_amount", val), 0.0, 1.0, 0.3)
	tween.tween_method(func(val): mat.set_shader_parameter("explode_amount", val), 0.0, 1.0, 0.5)
