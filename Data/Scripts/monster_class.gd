extends Entity
class_name Monster

@export_group("Loot")
@export_range(1, 9999, 1)  var EXP  := 1
@export_range(1, 9999, 1)  var Gold := 1

@export_group("")
@export var moves : Dictionary[Attack, int]
