extends Node
class_name BaseCharacter

@export var character : Entity

@export var ID : String = " "
@export var turn_bar : int

var cur_hp : int
var cur_mp : int
var max_hp : int
var max_mp : int

var agility : int
var max_act : int

func _ready() -> void:
	agility = character.agility
	max_act = character.max_act
	max_hp = character.hp
	max_mp = character.mp

func update_turn_bar():
	turn_bar += agility
	if turn_bar >= max_act:
		return true  
	else:
		return false

func take_damage():
	pass

func calculate_damage(dmg: int, type: String, element: String, pen: float):
	pen = clamp(pen, 0, 1)
	return ceili((dmg * dmg) / (dmg + (character.get(type + "def") * 1 - pen)) * 1 - character.get(element))

func take_turn():
	pass

func end_turn():
	pass
