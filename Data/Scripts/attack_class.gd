extends Resource
class_name Attack

@export var ID   : String
@export_enum("TARGET", "ALL") var target_type := "TARGET"
@export_enum("SINGLE", "THREE", "FOCUSED") var target_spread := "SINGLE"
@export_enum("PHYS", "MAGIC", "TRUE") var damage_type := "PHYS"
@export_enum("NEUTRAL", "FIRE", "WATER", "DARK", "LIGHT") var element := "NEUTRAL"
@export_range(0, 10, 0.01) var damage_multiplier := 0.00
@export_range(0, 1, 0.01) var damage_penetration := 0.00
