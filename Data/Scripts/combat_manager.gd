extends Node


var characters : Array = []  #Lista de todos os personagens 
var turn_order : Array = []  #Lista dos personagens prontos para agir

@onready var combat_animator: AnimationPlayer = $combat_animator
@onready var turn_updater: Timer = $turn_updater
@onready var player_ui: Control = $player_UI

@export var attack_selected : Attack
@export var target_selected : BaseCharacter
@export var current_actor   : BaseCharacter

const move_button   = preload("res://CombatUI/move_button.tscn")
const item_button   = null
const target_button = preload("res://CombatUI/target_button.tscn")

enum states {
	animating,
	action_select,
	attack_select,
	spell_select,
	items_select,
	target_select,
	action_confirm,
	item_confirm,
	resolve_action}

var cur_state : states
var old_state : states


#region Setup and Timers
func _ready():
	for i in %Players.get_children():
		add_character(i)
	for i in %Monsters.get_children():
		add_character(i)
	for i in %Monsters.get_child_count():
		%Monsters.get_child(i).position = %Spots.get_child(i).position
		
	%attack_button.pressed.connect(func(): change_state(states.attack_select))
	%spell_button.pressed.connect(func(): change_state(states.spell_select))
	%items_button.pressed.connect(func(): change_state(states.items_select))
	%refuse_action.pressed.connect(func(): change_state(old_state))
	%accept_action
	%return.pressed.connect(func(): change_state(states.action_select))
	
func change_state(new_state : states):
	old_state = cur_state
	cur_state = new_state

	for i in %player_actions.get_children():
		i.visible = false

	match new_state:
		states.animating:
			pass
		states.action_select:
			show_player_action(true)
		states.attack_select:
			show_player_attack(true, current_actor)
		states.spell_select:
			show_player_spells(true, current_actor)
		states.items_select:
			show_player_items(true)
		states.target_select:
			show_target_select(true, attack_selected.move_type)
		states.action_confirm:
			show_action_confirm(true)
		states.resolve_action:
			pass
		
func _physics_process(_delta: float) -> void:
	$Label.text = "%.1f" % $turn_updater.time_left

func _on_update_turns_timeout() -> void:
	update_turn_bars()
	# Executando turnos assim que houverem personagens prontos
	if turn_order.size() > 0:
		execute_turns()

func update_turn_bars():
	for character in characters:
		if character.character is Player and not character.is_alive:
			continue
		if character.update_turn_bar() and character not in turn_order:
			turn_order.append(character)

func execute_turns():
	turn_order = turn_order.filter(func(node): return node.turn_bar >= node.max_act)
	turn_order.sort_custom(compare_turn_order)
	%player_actions.visible = false
	if turn_order:
		#Executa o turno do primeiro da lista
		turn_updater.stop()
		%player_actions.visible = true
		change_state(states.action_select)
	else:
		#Reinicia o timer de turno para que o jogo continue
		turn_updater.start(1)
#endregion

#region UI flow

func hide_or_disable_combat_UI():
	pass

func player_attack_selected(attack : Attack):
	attack_selected = attack
	match attack.target_type:
		"focused":
			change_state(states.target_select)
		"all":
			change_state(states.action_confirm)
		"random":
			change_state(states.action_confirm)

func show_player_action(show : bool):
	%player_action_select.visible = show
	%return.visible = !show
	
func show_player_attack(show : bool, character : BaseCharacter = null):
	for i in %player_attacks.get_children():
		i.queue_free()
		
	for i in character.character.moves:
		var button = move_button.instantiate()
		button.move = i
		%player_attacks.add_child(button)
		button.pressed.connect(func() : change_state(states.target_select))
		
	%player_attack_select.visible = show
	%return.visible = show

func show_player_spells(show : bool, character : BaseCharacter = null):
	for i in %player_attacks.get_children():
		i.queue_free()
		
	for i in character.character.spells:
		var button = move_button.instantiate()
		button.move = i
		%player_attacks.add_child(button)
	%player_attack_select.visible = show
	%return.visible = show

func show_player_items(show : bool):
	%player_items_select.visible = show
	%return.visible = show

func show_target_select(show : bool, type : String = " "):
	for i in %targets.get_children():
		i.queue_free()
	%player_target_select.visible = show
	if type == "atk":
		for i in %Monsters.get_children():
			var button = target_button.instantiate()
			button.target = i
			%targets.add_child(button)
	if type == "sup":
		for i in %Players.get_children():
			var button = target_button.instantiate()
			button.target = i
			%targets.add_child(button)
	for i in %targets.get_children():
		i.pressed.connect(func() : change_state(states.action_confirm))

	%return.visible = show

func show_action_confirm(show : bool):
	%action_confirm.visible = show
	%return.disabled = !show

#endregion

#region Extra combat logic
#Seleciona um alvo aleatório nos nodes "Players" ou "Monsters"
func get_random_target(node: Node) -> BaseCharacter:
	var child_count = node.get_child_count()
	if child_count == 0:
		return null
	var random_index = randi() % child_count
	return node.get_child(random_index)

func get_three_targets(og: BaseCharacter) -> Array:
	
	return []

func deal_damage(caster : BaseCharacter, targets : Array[BaseCharacter], move : Attack):
	var random_multiplier = [0,0]
	if caster.character is Player:
		random_multiplier[0] = -0.25
		random_multiplier[1] =  0.25
	
	var c_multiplier = randf_range(random_multiplier[0], random_multiplier[1])
	
	var after_damage = (caster.get(move.damage_type + "atk") * move.damage_multiplier) * c_multiplier
	
	for i in targets:
		i.calculate_damage(after_damage, move.damage_type, move.element, move.damage_penetration)

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
