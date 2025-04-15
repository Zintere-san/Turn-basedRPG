extends Resource
class_name Attack

## Unique name of this Attack.
@export var ID   : String

## Animation preset this will use when called in combat
@export var animation : String = ""

## How the targeting works
@export_enum("focused", "all", "random") var target_type := "focused"

## How the " target_type = "target" " works. [br]
## Single : Hits one creature; [br]
## Three  : Hits two creatures besides original target  if possible; [br]
## Focus  : Hits all creatures but deals higher damage to original target.
@export_enum("single", "three", "focus") var target_spread := "single"

## How many times this move hits. If "target_type" is set to "random", it will pick a new random target each time.
@export var number_of_hits : int = 1

## Damage type of (p)hysical or (m)agic.
@export_enum("p", "m") var damage_type := "p" 

## Attack element, reduced in % by elemental resistances.
@export_enum("neutral", "fire", "ice", "thunder", "earth", "light", "dark") var element := "neutral"

## How much of the relevant offensive stat is used in damage calculation, used in %.
@export_range(0, 10, 0.01) var damage_multiplier := 0.00

## How much of the relevant defensive stat is ignored in damage calculation, used in %. 
## Does not affect elemental resistances
@export_range(0, 1, 0.01) var damage_penetration := 0.00
