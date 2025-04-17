extends Button

@export var target : Node

func _ready() -> void:
	text = target.character.ID
