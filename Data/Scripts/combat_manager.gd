extends Node

#region Combat

var characters : Array = []  #Lista de todos os personagens 
var turn_order : Array = []  #Lista dos personagens prontos para agir

@onready var player_actions: Panel = %player_actions
@onready var turn_updater: Timer = $turn_updater

func _ready():
	for i in %Players.get_children():
		add_character(i)
	for i in %Monsters.get_children():
		add_character(i)
	for i in %Monsters.get_child_count():
		%Monsters.get_child(i).position = %Spots.get_child(i).position

func _physics_process(_delta: float) -> void:
	$Label.text = "%.1f" % $turn_updater.time_left
	
func _on_update_turns_timeout() -> void:
	update_turn_bars()
	# Executando turnos assim que houverem personagens prontos
	if turn_order.size() > 0:
		execute_turns()
		#turn_updater.stop()
	
func update_turn_bars():
	for character in characters:
		if character.update_turn_bar():
			turn_order.append(character)

func execute_turns():
	turn_order = turn_order.filter(func(node): return node.turn_bar >= node.max_act)
	turn_order.sort_custom(compare_turn_order)
	if turn_order:
		#Executa o turno do primeiro da lista
		turn_updater.stop()
		turn_order[0].take_turn()
	else:
		#Reinicia o timer de turno para que o jogo continue
		turn_updater.start(1)

#Seleciona um alvo aleatório nos nodes "Players" ou "Monsters"
func get_random_target(node: Node) -> Node:
	var child_count = node.get_child_count()
	if child_count == 0:
		return null
	var random_index = randi() % child_count
	return node.get_child(random_index)

func deal_damage(target : Node, move : Attack):
	target.calculate_damage()

func add_character(character: Node):
	characters.append(character)

func remove_character(character: Node):
	characters.erase(character)

func compare_turn_order(a, b):
	return b.turn_bar < a.turn_bar 

func can_summon() -> bool:
	if %Monsters.get_child_count() < 5:
		return true
	else:
		return false
#endregion
