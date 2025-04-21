extends BaseCharacter

var item_used : bool = false
var is_alive  : bool = true

signal player_turn(player : BaseCharacter)

func setup() -> void:
	pass
func get_damage_fluctuation() -> Array:
	return [0,0]

func take_turn():
	pass
