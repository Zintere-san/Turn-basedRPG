extends Resource
class_name Entity

@export var ID : String

@export_group("Base stats")
@export_range(1, 99999, 1) var hp   := 1
@export_range(1, 99999, 1) var mp   := 1
@export_range(1, 9999, 1)  var patk := 1
@export_range(1, 9999, 1)  var matk := 1
@export_range(1, 9999, 1)  var pdef := 1
@export_range(1, 9999, 1)  var mdef := 1
@export var agility : int = 1
@export var max_act : int = 1

@export_subgroup("Elemental resistances")
@export_range(-2.0, 1.0, 0.01) var neutral : float = 0.0
@export_range(-2.0, 1.0, 0.01) var fire    : float = 0.0
@export_range(-2.0, 1.0, 0.01) var ice     : float = 0.0
@export_range(-2.0, 1.0, 0.01) var thunder : float = 0.0
@export_range(-2.0, 1.0, 0.01) var earth   : float = 0.0
@export_range(-2.0, 1.0, 0.01) var light   : float = 0.0
@export_range(-2.0, 1.0, 0.01) var dark    : float = 0.0
