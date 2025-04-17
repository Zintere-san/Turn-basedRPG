extends Entity
class_name Player

@export var moves : Array[Attack]

@export_group("Level up stats")
@export_range(1, 99, 1) var vitality
@export_range(1, 99, 1) var strength
@export_range(1, 99, 1) var dexterity
@export_range(1, 99, 1) var magic
@export_range(1, 99, 1) var luck
