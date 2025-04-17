extends Node


var characters : Array = []  #Lista de todos os personagens 
var turn_order : Array = []  #Lista dos personagens prontos para agir

@onready var player_actions: GridContainer = %player_actions
@onready var combat_animator: AnimationPlayer = $combat_animator
@onready var turn_updater: Timer = $turn_updater

var attack_selected : Attack

const move_button   = preload("res://CombatUI/move_button.tscn")
const target_button = preload("res://CombatUI/target_button.tscn")

func _ready():
	for i in %Players.get_children():
		add_character(i)
	for i in %Monsters.get_children():
		add_character(i)
	for i in %Monsters.get_child_count():
		%Monsters.get_child(i).position = %Spots.get_child(i).position
		
		
	#This is a test. Delete afterwards
	var anim = combat_animator.get_animation("key_tests")
	combat_animator.play("key_tests")
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
		show_player_action(turn_order[0])
	else:
		#Reinicia o timer de turno para que o jogo continue
		turn_updater.start(1)

func player_attack_selected(attack : Attack):
	hide_player_action()
	match attack.target_type:
		"focused":
			show_target_select()
		"all":
			show_action_confirm()
		"random":
			show_action_confirm()

func show_player_action(character : BaseCharacter):
	%player_action_c.visible = true
	for i in character.character.moves:
		var button = move_button.instantiate()
		button.move = i
		%player_actions.add_child(button)

func hide_player_action():
	%player_action_c.visible = false
	for i in %player_actions.get_children():
		i.queue_free()

func show_target_select():
	%target_select_c.visible = true
	for i in %Monsters.get_children():
		var button = target_button.instantiate()
		button.target = i
		%targets.add_child(button)

func hide_target_select():
	%target_select_c.visible = false
	for i in %targets.get_children():
		i.queue_free()

func show_action_confirm():
	%action_confirm.visible = true

func hide_action_confirm():
	%action_confirm.visible = false

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




func bullshit_test(number : int = 0, second_number : int = 0):
	
	print("BULLSHIT TEST: ", number, second_number)
