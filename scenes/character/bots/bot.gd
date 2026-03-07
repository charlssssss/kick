extends Character

@export var animation: AnimatedSprite2D
@export var bot_state_machine: BotStateMachine

func _ready() -> void:
	apply_bars()
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

func take_damage(damage: int, enemy_body: CharacterBody2D) -> void:
	health -= damage
	health_bar.health = health
	
	spawn_blood(enemy_body)
	show_floating_text(damage)
	
	if health_bar != null and health_bar.health <= 0:
		die()

func die() -> void:
	bot_state_machine.transition_to("death")
