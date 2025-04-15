extends BaseCharacter

var cur_hp
var cur_mp
var max_hp
var max_mp

func _ready() -> void:
	max_hp = character.hp
	max_mp = character.mp
