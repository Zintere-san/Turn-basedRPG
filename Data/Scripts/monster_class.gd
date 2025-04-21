extends Entity
class_name Monster

@export var moves : Dictionary[Attack, int]
@export_enum("support", "aggressive") var monsterAI := "aggressive"
@export_enum("boss", "normal") var monster_type := "normal"
@export_group("Loot")
@export_range(1, 9999, 1)  var EXP  := 1
@export_range(1, 9999, 1)  var Gold := 1

@export var item_drops : Dictionary[Item, float]
