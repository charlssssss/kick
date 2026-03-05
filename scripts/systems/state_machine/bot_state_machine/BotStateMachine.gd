extends Node
class_name  BotStateMachine

@export var initial_state: BotState

var current_state: BotState
var states: Dictionary = {}

func init(char_body: CharacterBody2D, animation: AnimatedSprite2D) -> void:
	for child in get_children():
		if child is BotState:
			states[child.name.to_lower()] = child
			child.char_body = char_body
			child.animation = animation
			child.transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func process_input(event: InputEvent) -> void:
	if current_state:
		current_state.process_input(event)

func process_frame(delta: float) -> void:
	if current_state:
		current_state.process_frame(delta)

func process_physics(delta: float) -> void:
	if current_state:
		current_state.process_physics(delta)

func on_child_transition(state: BotState, new_state_name: String, body: CharacterBody2D) -> void:
	if state != current_state:
		return
	
	var new_state: BotState = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enemy_body = body
	new_state.enter()
	current_state = new_state

func transition_to(new_state_name: String, body: CharacterBody2D = null) -> void:
	var new_state: BotState = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enemy_body = body
	new_state.enter()
	current_state = new_state
