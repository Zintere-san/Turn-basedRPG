extends Button

@export var move : Attack

signal attack_select(attack : Attack)

func _ready() -> void:
	attack_select.connect(Callable(get_tree().current_scene, "player_attack_selected"))
	text = move.ID + " : " + str(move.mana_cost)

func _on_pressed() -> void:
	emit_signal("attack_select", move)
