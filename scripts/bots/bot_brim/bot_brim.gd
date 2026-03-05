extends CharacterBody2D

@export var animation: AnimatedSprite2D
@export var bot_state_machine: BotStateMachine
@export var bot_follow_range: Area2D
@export var health_bar: ProgressBar
@export var health: int = 100

func _ready() -> void:
	bot_state_machine.init(self, animation)

func _unhandled_input(event: InputEvent) -> void:
	bot_state_machine.process_input(event)

func _process(delta: float) -> void:
	bot_state_machine.process_frame(delta)

func _physics_process(delta: float) -> void:
	bot_state_machine.process_physics(delta)

func apply_knockback(force: Vector2) -> void:
	var knockback_state = bot_state_machine.states["knockback"]
	knockback_state.knockback_velocity = force
	bot_state_machine.transition_to("knockback")
