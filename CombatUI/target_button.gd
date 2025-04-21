extends Button

@export var target : Node

func _ready() -> void:
	text = target.character.ID

func _on_pressed() -> void:
	pass # Replace with function body.
